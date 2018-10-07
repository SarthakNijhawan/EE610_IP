% load image f
ground_truth = double(rgb2gray(imread('images/lena_bw.png')));
[m,n] = size(ground_truth);

gt_DFT = fft2(ground_truth);

% create blurring mask
kernel = double(motionblur(45, 15)); % a 9 x 9 window of 45 degree motion blur
kernel = kernel/sum(sum(h));  % scale h so that its elements add to 1
kernel = pad_image(kernel, [m,n]);
kernel_DFT = fft2(kernel);

% generate noise
% psnr = 20*log_10 256/sigma
% hence sigma = 256*10^(-psnr/20)
% psnr0=input('Peak-to-peak signal to noise ratio (PSNR, default = 30db) = ');
% if isempty(psnr0), psnr0=30; end
psnr0 = 30;
sigma=255*10^(-psnr0/20);
noise=randn(m, n)*sigma;  % gaussian noise with psnr = 30 dB

Gg0 = gt_DFT.*kernel_DFT;   % Fourier transform of the noiseless blurred image
degraded_img=round(abs(ifft2(Gg0))+noise); % blurred image + noise

% calculate RMS error per pixel
erms=sqrt(sum(sum(abs(degraded_img - ground_truth).^2))/mn);
psnr=20*log10(255/erms);
disp(['RMS error per pixel = ' num2str(erms)]);
disp(['Calculated PSNR = ' num2str(psnr) ' dB']);

figure(1),clf
subplot(221),imagesc(ground_truth),title('original, f'),colormap('gray')
subplot(222),imagesc(degraded_img),title('degraded, g'),colormap('gray')

disp('original and degraded images, ')
disp('Next, compare inverse filter and Wiener filter, ')
disp('press any key to continue ...')
pause

degraded_img_DFT = fft2(degraded_img); % FFT of blurred+noise image

% Inverse filtering
Ffinv = degraded_img_DFT./([abs(kernel_DFT)<1e-3].*1e-3+kernel_DFT);
finv = abs(ifft2(Ffinv));

% Wiener filtering
K = sigma;
H2 = abs(kernel_DFT).^2; 
Ffwin = H2.*degraded_img_DFT./((H2+K).*kernel_DFT);
fwin=abs(ifft2(Ffwin));
figure(1),
subplot(223),imagesc(finv),title('Inverse'),colormap('gray')
subplot(224),imagesc(fwin),
title(['Wiener, K=' num2str(K) ]),colormap('gray')

disp(['Inverse filter and Wiener filter results displayed, K = ' num2str(K)])
disp('Now, you have a chance to experiment with different values of K ...')
otherK = input('Enter 1 to try other values of K, other key to skip: ');

