% Author: Sarthak Nijhawan
% 
% Description:	This function attempts to restore the underlying ground truth image
% 				,given the degradation image and the estimated degrading kernel
% 				using various methods such as
% 				(1)	Inverse Filtering
% 				(2) Truncated Inverse Filtering
% 				(3) Wiener Filtering
% 				(4) Constrained Least Square Filtering

function reconstructed_img = restore_img(degraded_img, kernel, filter, arg)
	
	%Handling the colored images
	if ndims(degraded_img) == 3										% Colored Images
		img_hsv = rgb2hsv(degraded_img);
		degraded_intesity = 255.0*img_hsv(:,:,3);				% To ensure range of value is in mapped to [0,255]
	else
		degraded_intesity = degraded_img;						% Grayscale Images
	end

	%finding the size of the degraded image and kernel and the next power of 2 for FFT
	[M,N] = size(degraded_intesity);
	[M_kernel,N_kernel] = size(kernel);

	M_pow2 = pow2(nextpow2(M));
	N_pow2 = pow2(nextpow2(N));

	%Padding the degraded image
	padded_image = zeros(M_pow2,N_pow2);			
	padded_image(1:M, 1:N) = degraded_img_grayscale;
	degraded_intesity = padded_image;

	%Padding the kernel
	padded_kernel = zeros(M_pow2,N_pow2);
	padded_kernel(1:M_kernel,1:N_kernel) = kernel;
	kernel = padded_kernel;

	%finding DFT of degraded image
	degraded_img_DFT = fftshift(fft2(degraded_intesity));

	%finding DFT of the kernel
	kernel_DFT = fftshift(fft2(kernel));

	% Apply inverse filtering method
	if strcmp(filter, 'inverse')
		reconstructed_img_DFT = degraded_img_DFT./kernel_DFT;

	% Pseudo-inverse filtering
	elseif strcmp(filter, 'pseudo inverse')
		reconstructed_img_DFT = ((abs(kernel_DFT)>arg).*degraded_img_DFT)./kernel_DFT;

	% Truncation Method
	elseif strcmp(filter, 'truncated inverse')
		reconstructed_img_DFT = degraded_img_DFT./kernel_DFT;		
		low_pass_filter = construct_LPF(arg, [M, N]);
		reconstructed_img_DFT = abs(reconstructed_img_DFT).*low_pass_filter.*exp(1i*angle(reconstructed_img_DFT));

	% Wiener Filtering
	elseif strcmp(filter, 'wiener')
		reconstructed_img_DFT = conj(kernel_DFT).*degraded_img_DFT./(abs(kernel_DFT).^2 + arg*ones(M,N,P));

	% Constrained Least Squares Method	
	elseif strcmp(filter, 'clsf')
		laplacian = [0 -1 0; -1 4 -1; 0 -1 0];
		padded_laplacian = zeros(M_pow2,N_pow2);			
		padded_laplacian(1:3, 1:3) = laplacian;

		laplacian_DFT = fftshift(fft2(padded_laplacian));
		reconstructed_img_DFT = conj(kernel_DFT).*degraded_img_DFT./(abs(kernel_DFT).^2 + arg*laplacian_DFT);	
	else 
		fprintf('Please enter the correct filter name!');
		return;
	end

	% Intensity
	reconstructed_img = abs(ifft2(fftshift(reconstructed_img_dft)));
	reconstructed_img = reconstructed_img(1:M,1:N);

	if ndims(degraded_img) == 3								% Colored Images
		img_hsv(:,:,3) = reconstructed_img/255.0;			% range for V in HSV must be in [0,1]
		reconstructed_img = uint8(255*hsv2rgb(img_hsv));
	end

	% Display imgs
	figure(2)
	subplot(1,3,1);
	imshow(degraded_img);
	title('Degraded Image');
	subplot(1,3,2)
	% imshow(log_transform(linear_contrast(abs(reconstructed_img_DFT))));
	title('Reconstructed Image DFT');
	subplot(1,3,3)
	imshow(reconstructed_img);
	title('Reconstructed Image')

end