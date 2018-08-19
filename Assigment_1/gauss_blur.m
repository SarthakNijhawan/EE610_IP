function blurred_img = gauss_blur(orig_img, n, sig)
	% Input:
	%       orig_img    -> DFT of an image (Complex)
	%		n			-> Kernel Size (nxn)
	%		sig			-> Standard deviation of Gaussian Kernel
	% 
	% Description:
	%		: Returns a blurred image
	%		: n must be an odd integer

	% Guassian kernel in 2D
	filt2D = gauss2D(n, sig, sig);
	
	% Applying the filter on the image
	blurred_img = filter_image(orig_img, filt2D);

	% % Displaying the images
	% subplot(1,2,1)
	% imshow(orig_img);
	% title('Original Image');
	% subplot(1,2,2)
	% imshow(blurred_img);
	% title('Enhanced image');
end