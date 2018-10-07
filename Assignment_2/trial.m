%% Blur the image
% kernel = imread('images/Kernel1.png');
% kernel = double(kernel)/sum(sum(kernel));

% ground_truth = imread('images/GroundTruth1.jpg');
% degraded_img = imfilter(ground_truth, kernel);

%-------------------------------------------------- Image Restoration -------------------------------------------%
% %%  Resize the image and filter to the same by padding zeros
% [M,N,P] = size(ground_truth);
% [M_filt, N_filt] = size(kernel);

% diff_x = M-M_filt;
% diff_y = N-N_filt;

% % Assuming both to be even
% padded_filt = padarray(kernel, [diff_x/2, diff_y/2], 0, 'both');
% kernel_DFT = fftshift(fft2(padded_filt));

% reconstructed_img = zeros(M,N,P);
% for i=1:3
% 	degraded_img_plane = degraded_img(:,:,i);

% 	%% Take FT of both the degraded img and the filter
% 	degraded_img_DFT = fftshift(fft2(degraded_img_plane));

% 	%% Apply inverse filtering
% 	reconstructed_img_DFT = degraded_img_DFT./kernel_DFT;

% 	%% Apply truncation
% 	radius = 80;
% 	low_pass_filter = construct_LPF(radius,[M,N]);
% 	reconstructed_img_DFT = abs(reconstructed_img_DFT).*low_pass_filter.*exp(angle(reconstructed_img_DFT));

% 	%% Take inverse FFT
% 	reconstructed_img_plane = linear_contrast(real(ifft2(fftshift(reconstructed_img_DFT))));
% 	% reconstructed_img_plane = uint8(real(ifft2(fftshift(reconstructed_img_DFT))));

% 	%% Combine back the image
% 	reconstructed_img(:,:,i) = reconstructed_img_plane;

% end

kernel = ones(9,9)/9^2;
ground_truth = rgb2gray(imread('images/lena_bw.png'));

[M,N] = size(ground_truth);
[M_filt, N_filt] = size(kernel);

ext_M = floor((M-M_filt)/2);
ext_N = floor((N-N_filt)/2);

degraded_img = double(imfilter(ground_truth, kernel)) + double(10*randn(M, N));

%% Take FT of both the degraded img and the filter
degraded_img_DFT = fftshift(fft2(degraded_img));
padded_kernel = padarray(kernel, [ext_M, ext_N]);

[M_P, N_P] = size(padded_kernel);
if ((M-M_filt)/2 - ext_M) == 0.5
	row = zeros(1,N_P);
	padded_kernel = [padded_kernel; row];
end

[M_P, N_P] = size(padded_kernel);
if ((N-N_filt)/2 - ext_N) == 0.5
	col = zeros(M_P,1);
	padded_kernel = [padded_kernel, col];
end

kernel_DFT = fftshift(fft2(padded_kernel));

% size(degraded_img_DFT)
% size(kernel_DFT)

%% Apply inverse filtering
reconstructed_img_DFT = degraded_img_DFT./kernel_DFT;

%% Truncating
radius = 80;
low_pass_filter = construct_LPF(radius, [M,N]);
reconstructed_img_DFT = abs(reconstructed_img_DFT).*low_pass_filter.*exp(1i*angle(reconstructed_img_DFT));

%% Take inverse FFT
reconstructed_img = uint8(real(ifft2(fftshift(reconstructed_img_DFT))));
% reconstructed_img_plane = uint8(real(ifft2(fftshift(reconstructed_img_DFT))));


%% Display imgs
figure
subplot(1,3,1);
imshow(ground_truth);
title('Original Image');
subplot(1,3,2)
imshow(uint8(degraded_img));
title('Degraded Image');
subplot(1,3,3)
imshow(fftshift(reconstructed_img));
title('Reconstructed Image')
