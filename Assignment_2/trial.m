% Author: Sarthak Nijhawan
% 
% Description:  This code is used to compare different image restoration techniques on set of
%               images 

clear all

% h = fspecial('disk', 15);

% cam = im2double(rgb2gray(imread('images/lena_bw.png')));
% hf = fft2(h, size(cam,1), size(cam,2));
% cam_blur = real(ifft2(hf.*fft2(cam)));
% sigma_u = 10^(-40/20)*abs(1-0);
% img = cam_blur + sigma_u*randn(size(cam_blur));

original_img = imread('images/GroundTruth2.jpg');
degraded_img = imread('images/Blurry2_2.jpg');
kernel = imread('images/kernel2_tiled.png');
kernel = double(kernel)/sum(sum(kernel));

% Calculating the evaluation metrics
erms = immse(degraded_img, original_img);
psnr = psnr(degraded_img, original_img);
ssim = ssim(degraded_img, original_img);

disp(['RMS error per pixel = ', num2str(erms)]);
disp(['Calculated PSNR = ', num2str(psnr) ' dB']);
disp(['Calculated SSIM = ', num2str(ssim)]);

figure(1),clf
subplot(221),imshow(original_img),title('original')
subplot(222),imshow(degraded_img),title('degraded')

disp('Original and Degraded images are shown!');
disp('Next, choose any filter you wanna apply');
disp('press any key to continue ...')
pause

% Inverse Filtering
finv = restore_img(degraded_img, kernel, 'inverse', 0.5);

% Truncated Inverse filtering
ftrunc = restore_img(degraded_img, kernel, 'truncated inverse', 40);

% Wiener filtering
K = 0.01;
fwin = restore_img(degraded_img, kernel, 'wiener', K);

figure(1),
subplot(223),imshow(finv),title('Inverse')
subplot(224),imshow(fwin),title(['Wiener, K = ' K ])

disp(['Inverse filter and Wiener filter results displayed, K = ' num2str(K)])
disp('Now, you have a chance to experiment with different values of K ...')
otherK=input('Enter 1 to try other values of K, other key to skip: ');
if isempty(otherK), otherK=0.01; end
while otherK==1, %
   K = input('Enter a positive value for K: ')
   fwin = restore_img(degraded_img, kernel, 'wiener', K);
   subplot(224),imshow(fwin),title(['Wiener, K=' num2str(K) ])
   otherK=input('Enter 1 to try other values of K,  other key to skip: ');
end

disp('Press any key to demonstrate constraint least square filters ...')
pause

figure(2),clf
gamma = .001;
p=[0 -1 0; -1 4 -1; 0 -1 0];
Pp=fft2(p.*tmp(1:size(p,1),1:size(p,2)),64,64);
Hhcls=conj(Hh).*Gg./(H2+gamma*abs(Pp).^2);
hcls=abs(ifft2(Hhcls));
figure(1),subplot(325),imagesc(hcls),title(['CLS, gamma=' num2str(gamma)])
colormap('gray')

disp(['Initial result of CLS filter using gamma = ' num2str(gamma)])

% now start iteration
eta2=mn*sigma^2;  % (5.9-12), m_eta = 0 in this example
disp(['||eta||^2 = ' num2str(eta2)])
icnt=0; cntmax=20;
converge=0; 
accuracy=mn*sigma;  % accuracy factor a in (5.9-8), every pixel within sigma
gub=10; glb=0; % upper and lower bounds of gamma initially
while converge==0, % start iteration
   icnt=icnt+1; disp(['iteration # ' int2str(icnt)]);
   % Use Parsevel theorem, ||r||^2 = sum sum |R|^2
   Rr=abs(Gg-Hh.*Hhcls);
   r2=(sum(sum(abs(Rr).^2))-Rr(1,1)^2)/mn;  % remove the mean value
   disp(['||r||^2 = ' num2str(r2) ', ||eta||^2 = ' num2str(eta2)])
   if abs(r2-eta2)<accuracy, converge=1;  %done, do nothing
   else
      if r2 < eta2, % gamma too small
         if gamma > glb, glb=gamma; end % update lower bound
         % gamma=gamma*(1+0.9^icnt); disp(['gamma increased to: ' num2str(gamma)]);
      elseif r2 > eta2, % gamma too large
         if gamma < gub, gub=gamma; end % update upper bound
         % gamma=gamma*(1-0.9^icnt); disp(['gamma decreased to: ' num2str(gamma)]);
      end
      gamma=0.5*(gub+glb);  % use bisection search
      Hhcls=conj(Hh).*Gg./(H2+gamma*abs(Pp).^2);
      hcls=abs(ifft2(Hhcls));
      if rem(icnt-1,3)==0, % plot 1, 4, 7, 10, 13 iterations
        figure(2),
        eval(['subplot(23' int2str(ceil(icnt/3)) '),'])
        imagesc(hcls),title(['iteration ' int2str(icnt) ', gamma=' num2str(gamma)])
        colormap('gray')
        disp(['gamma = ' num2str(gamma) ', enter any key to continue ...'])
      end
      pause
      if icnt == cntmax, 
         converge=1; disp('Reach max. iteration count, stop!')
      end
   end % if abs(... loop
end % while loop
figure(2),
subplot(236),
imagesc(hcls),title(['iteration ' int2str(icnt) ', gamma=' num2str(gamma)])
colormap('gray')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

img = imread('images/Blurry2_4.jpg');
h = imread('images/kernel4_tiled.png');
h = double(h)/sum(sum(h));

% h = fspecial('disk', 15);

% cam = im2double(rgb2gray(imread('images/lena_bw.png')));
% hf = fft2(h, size(cam,1), size(cam,2));
% cam_blur = real(ifft2(hf.*fft2(cam)));
% sigma_u = 10^(-40/20)*abs(1-0);
% img = cam_blur + sigma_u*randn(size(cam_blur));

restore_img(img, h, 'clsf', 0.3);

% h = fspecial('disk', 15);

% % Read image and convert to double for FFT
% cam = im2double(rgb2gray(imread('images/lena_bw.png')));
% hf = fft2(h,size(cam,1),size(cam,2));

% cam_blur = real(ifft2(hf.*fft2(cam)));

% figure
% subplot(141)
% imshow(cam_blur)

% sigma_u = 10^(-40/20)*abs(1-0);
% cam_blur_noise = cam_blur + sigma_u*randn(size(cam_blur));
% subplot(142)
% imshow(cam_blur_noise)

% cam_inv = inverse_filtering(cam_blur_noise, h, 0.1);
% subplot(143)
% imshow(cam_inv)

% cam_pinv = real(ifft2((abs(hf) > 0.1).*fft2(cam_blur_noise)./hf));
% subplot(144)
% imshow(cam_pinv)
% xlabel('pseudo-inverse restoration')