function blurred_img = gauss_blur(orig_img, n, sig)

	% Guassian kernel in 2D
	filt2D = double(gauss2D(n, sig, sig));
	
	blurred_img = filter_image(orig_img, filt2D);

	% Displaying the images
	% subplot(1,2,1)
	% imshow(orig_img);
	% title('Original Image');
	% subplot(1,2,2)
	% imshow(blurred_img);
	% title('Enhanced image');
end