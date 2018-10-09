% dog = imread('images/mydog.jpg');
imtool(dog)
pause

noisy_hsv = rgb2hsv(noisy_patch);
g = noisy_hsv(:,:,3);
f = imsharpen(g);
% f = mean(mean(f)).*ones(size(f));

G = fft2(g);
F = fft2(f);
F = F+0.0001;

H = (abs(F)>0.001).*G./F;

h = real(ifft2(H));

rest_dog = restore_img(dog, h, 'clsf', 0.01);


figure(1)
subplot(151);
imshow(dog);
subplot(152)
imshow(g)
subplot(153)
imshow(f)
subplot(154)
imshow(h)
subplot(155)
imshow(rest_dog)

figure(2)
subplot(121)
imshow(dog)
subplot(122)
imshow(rest_dog)