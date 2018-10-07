% Author: Sarthak Nijhawan
% 
% Description:	This function recontructs the image using the method of inverse filtering,
% 				given a degraded image and the estimated kernel. For RGB images inverse
% 				filtering is applied independently to each of the plane.

function reconstructed_img = inverse_filtering(degraded_img, kernel, thresh)

	if ndims(degraded_img) == 3								% Colored Images
		img_hsv = rgb2hsv(degraded_img);
		img_intensity = 255.0*img_hsv(:,:,3);				% To ensure range of value is in mapped to [0,255]
	else
		img_intensity = degraded_img;						% Grayscale Images
	end

	enhanced_img = log10(double(img_intensity)+1.0);
	enhanced_img = enhanced_img*255.0/log10(256.0);		% Normalisation	so that the range is [0,255]
	
	if ndims(original_img) == 3								% Colored Images
		img_hsv(:,:,3) = enhanced_img/255.0;			% range for V in HSV must be in [0,1]
		enhanced_img = uint8(255*hsv2rgb(img_hsv));
	else 												% Grayscale Images
		enhanced_img = uint8(enhanced_img);				% Casting the image back for b/w images
	end

	[M,N,P] = size(degraded_img);					% P keeps track of the number of planes
	[M_filt, N_filt] = size(kernel);				% Kernel is assumed to be 2-Dimensional

	% Resize the kernel to match that of the degraded image
	padded_kernel = pad_image(kernel, [M,N]);
	kernel_DFT = fftshift(fft2(padded_kernel));

	% kernel_DFT = fft2(kernel, M, N);

	%% Each plane os processed individually
	reconstructed_img = double(zeros(M,N,P));

	% DFT of the image plane
	degraded_img_DFT = fftshift(fft2(degraded_img(:,:,i)));

	% Apply inverse filtering method
	reconstructed_img_DFT = degraded_img_DFT./kernel_DFT;

	% Truncation Method
	radius = 40;
	low_pass_filter = construct_LPF(radius, [M,N]);
	reconstructed_img_DFT = abs(reconstructed_img_DFT).*low_pass_filter.*exp(1i*angle(reconstructed_img_DFT));

	% Pseudo-inverse filtering
	% reconstructed_img_DFT = ((abs(kernel_DFT)>thresh).*degraded_img_DFT)./kernel_DFT;

	% Take inverse FFT
	reconstructed_img(:,:,i) = real(ifft2(fftshift(reconstructed_img_DFT)));

	% %% Display imgs
	% figure
	% subplot(1,3,1);
	% imshow(uint8(degraded_img));
	% title('Degraded Image');
	% subplot(1,3,2)
	% imshow(linear_contrast(abs(reconstructed_img_DFT)));
	% title('Reconstructed Image DFT');
	% subplot(1,3,3)
	% imshow(reconstructed_img);
	% title('Reconstructed Image')

end