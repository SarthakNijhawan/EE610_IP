img = 
h = fspecial('disk', 15);

% Read image and convert to double for FFT
cam = im2double(rgb2gray(imread('images/lena_bw.png')));
hf = fft2(h,size(cam,1),size(cam,2));

cam_blur = real(ifft2(hf.*fft2(cam)));

figure
subplot(141)
imshow(cam_blur)

sigma_u = 10^(-40/20)*abs(1-0);
cam_blur_noise = cam_blur + sigma_u*randn(size(cam_blur));
subplot(142)
imshow(cam_blur_noise)

cam_inv = inverse_filtering(cam_blur_noise, h, 0.1);
subplot(143)
imshow(cam_inv)

cam_pinv = real(ifft2((abs(hf) > 0.1).*fft2(cam_blur_noise)./hf));
subplot(144)
imshow(cam_pinv)
xlabel('pseudo-inverse restoration')