function reconstructed_img = wiener_filtering(degraded_img, kernel, thresh, k)

	[M,N] = size(degraded_img);
	[M_filt, N_filt] = size(kernel);

	ext_M = floor((M-M_filt)/2);
	ext_N = floor((N-N_filt)/2);

	%% Resizing the filter to the same size f input image by padding woth zeros
	padded_kernel = padarray(kernel, [ext_M, ext_N], 0, 'both');

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

	%% Take FT of both the degraded img and the filter
	degraded_img_DFT = fft2(degraded_img);
	kernel_DFT = fft2(padded_kernel);
	
	% Thresholding the zero regions to avoid "NaN or infitnities" in division
	% zero_kernel = kernel_DFT < thresh;
	% kernel_DFT(zero_kernel) = thresh;
	% kernel_DFT = [abs(kernel_DFT)<thresh].*thresh + kernel_DFT;

	%% Wiener Filtering
	% ratio = 0.4;
	energy_spectrum = abs(kernel_DFT).^2;					% Calculating |H(u,v)|^2 
	reconstructed_img_DFT = (energy_spectrum.*degraded_img_DFT)./((energy_spectrum + k*ones(M,N)).*kernel_DFT);

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