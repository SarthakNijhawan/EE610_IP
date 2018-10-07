% Author: Sarthak Nijhawan
% 
% Description:	This function attempts to restore the underlying ground truth image
% 				,given the degradation image and the estimated degrading kernel
% 				using various methods such as
% 				(1)	Inverse Filtering
% 				(2) Pseudo Inverse Filtering
% 				(3) Truncated Inverse Filtering
% 				(4) Wiener Filtering
% 				(5) Constrained Least Square Filtering

function reconstructed_img = restore_img(degraded_img, kernel, filter, arg)

	if ndims(degraded_img) == 3										% Colored Images
		img_hsv = rgb2hsv(degraded_img);
		degraded_img_intensity = 255.0*img_hsv(:,:,3);				% To ensure range of value is in mapped to [0,255]
	else
		degraded_img_intensity = degraded_img;						% Grayscale Images
	end

	[M,N] = size(degraded_img_intensity);							% Value Channel is in 2D
	M_pow2 = pow2(nextpow2(M));
	N_pow2 = pow2(nextpow2(N));

	% Resize the kernel to match that of the degraded image
	degraded_img_intensity = pad_image(degraded_img_intensity, [M_pow2,N_pow2]);			% Nearest power of 2
	padded_kernel = pad_image(kernel, [M_pow2,N_pow2]);
	kernel_DFT = fft_shift(fft2(padded_kernel));

	% DFT of the image plane
	degraded_img_DFT = fft_shift(fft2(degraded_img_intensity));

	% Apply inverse filtering method
	if strcmp(filter, 'inverse')
		reconstructed_img_DFT = degraded_img_DFT./kernel_DFT;

	% Pseudo-inverse filtering
	elseif strcmp(filter, 'pseudo inverse')
		reconstructed_img_DFT = ((abs(kernel_DFT)>arg).*degraded_img_DFT)./kernel_DFT;

	% Truncation Method
	elseif strcmp(filter, 'truncated inverse')
		reconstructed_img_DFT = degraded_img_DFT./kernel_DFT;		
		low_pass_filter = construct_LPF(arg, [M_pow2,N_pow2]);
		reconstructed_img_DFT = abs(reconstructed_img_DFT).*low_pass_filter.*exp(1i*angle(reconstructed_img_DFT));

	% Wiener Filtering
	elseif strcmp(filter, 'wiener')
		reconstructed_img_DFT = conj(kernel_DFT).*degraded_img_DFT./(abs(kernel_DFT).^2 + arg*ones(M_pow2,N_pow2));

	% Constrained Least Squares Method	
	elseif strcmp(filter, 'clsf')
		P = [0 -1 0; -1 4 -1; 0 -1 0];
		padded_P = pad_image(P, [M_pow2, N_pow2]);
		P_DFT = fft_shift(fft2(padded_P));	
		reconstructed_img_DFT = conj(kernel_DFT).*degraded_img_DFT./(abs(kernel_DFT).^2 + arg*P_DFT);	
	else 
		fprintf('Please enter the correct filter name!');
		return;
	end

	% Take inverse FFT
	reconstructed_img = abs(ifft2(fft_shift(reconstructed_img_DFT)));
	reconstructed_img = reconstructed_img(1:M, 1:N);
		
	if ndims(degraded_img) == 3								% Colored Images
		img_hsv(:,:,3) = reconstructed_img/255.0;			% range for V in HSV must be in [0,1]
		reconstructed_img = uint8(255*hsv2rgb(img_hsv));
	end

	%% Display imgs
	figure
	subplot(1,3,1);
	imshow(degraded_img);
	title('Degraded Image');
	subplot(1,3,2)
	imshow(log_transform(linear_contrast(abs(reconstructed_img_DFT))));
	title('Reconstructed Image DFT');
	subplot(1,3,3)
	imshow(reconstructed_img);
	title('Reconstructed Image')

end