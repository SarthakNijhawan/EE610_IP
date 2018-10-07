%% clsf: function description
function [reconstructed_img] = clsf(degraded_img, kernel, thresh, gam)

	[M,N] = size(degraded_img);

	%% Resizing the filter to the same size f input image by padding woth zeros
	padded_kernel = pad_image(kernel, [M,N]);

	%% Laplacian Operator and its resizing
	P = [0 -1 0; -1 4 -1; 0 -1 0];
	padded_P = pad_image(P, [M,N]);

	%% Take FT of both the degraded img and the filter
	degraded_img_DFT = fft2(degraded_img);
	kernel_DFT = fft2(padded_kernel);
	P_DFT = fft2(padded_P);

	% Thresholding the zero regions to avoid "NaN or infitnities" in division
	zero_kernel = kernel_DFT < thresh;
	kernel_DFT(zero_kernel) = thresh;
	% kernel_DFT = [abs(kernel_DFT)<thresh].*thresh + kernel_DFT;

	%% Constrained Least Square Filtering
	energy_spectrum_kernel = abs(kernel_DFT).^2;							% Calculating |H(u,v)|^2 
	energy_spectrum_P = abs(kernel_DFT).^2;

	numerator = energy_spectrum_kernel.*degraded_img_DFT;
	denominator = (energy_spectrum_kernel + gam*energy_spectrum_P).*kernel_DFT;
	reconstructed_img_DFT = numerator./denominator;

	%% Take inverse FFT
	reconstructed_img = uint8(abs(ifft2(reconstructed_img_DFT)));
	% reconstructed_img = linear_contrast(double(reconstructed_img));

	%% Display imgs
	figure
	subplot(1,3,1);
	imshow(uint8(degraded_img));
	title('Degraded Image');
	subplot(1,3,2)
	imshow(linear_contrast(abs(reconstructed_img_DFT)));
	title('Reconstructed Image DFT');
	subplot(1,3,3)
	imshow(reconstructed_img);
	title('Reconstructed Image')

end
