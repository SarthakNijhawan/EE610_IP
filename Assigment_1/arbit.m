tic

Y = fft2(einstein_bw);
Y = fftshift(Y);
mag = abs(Y);
imshow(uint8(255*mag/max(max(mag))));

toc