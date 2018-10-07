function filtered_img = inverse_filtering(degraded_img, kernel, thresh)
	% This function recontructs the image using the method of inverse filtering,
	% given a degraded image and the estimated kernel. For RGB images inverse
	% filtering is applied independently to each of the plane.
	% 
	% Author: Sarthak Nijhawan

	[M,N] = size(degraded_img);
	[M_filt, N_filt] = size(kernel);

	ext_M = floor((M-M_filt)/2);
	ext_N = floor((N-N_filt)/2);

	%% Take FT of both the degraded img and the filter
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

	% Centralised DFT of both
	kernel_DFT = fft_shift(fft2(padded_kernel));
	degraded_img_DFT = fft_shift(fft2(degraded_img));

	% size(degraded_img_DFT)
	% size(kernel_DFT)

	% Thresholding the zero regions to avoid "NaN or infitnities"
	zero_kernel = abs(kernel_DFT) < thresh;
	kernel_DFT(zero_kernel) = thresh;

	%% Apply inverse filtering method
	reconstructed_img_DFT = degraded_img_DFT./kernel_DFT;

	%% Truncation Method
	% radius = 80;
	% low_pass_filter = construct_LPF(radius, [M,N]);
	% reconstructed_img_DFT = abs(reconstructed_img_DFT).*low_pass_filter.*exp(1i*angle(reconstructed_img_DFT));

	%% Take inverse FFT
	reconstructed_img = uint8(abs(ifft2(fft_shift(reconstructed_img_DFT))));

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