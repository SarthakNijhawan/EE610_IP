function [enhanced_img] = sharpen(orig_img, n, sig, amount)
	% Input Parameters:
	%		orig_img 	-> 	Original Input Image
	%		n 			-> 	size of filter used for blurring
	%		sig			-> 	Blur filter sigma
	%		amount 		-> 	proportion of unsharp masking
	% 
	% Note	: all the operations are performed on the variable "img_intensity"
	%		: All the colored images are sharpen over the Value layer in HSV model

	if ndims(orig_img) == 3								% Colored Images
		img_hsv = rgb2hsv(orig_img);
		img_intensity = 255.0*img_hsv(:,:,3);			% To ensure range of value is in mapped to [0,255]
	else
		img_intensity = orig_img;						% Grayscale Images
	end
	
	[M,N] = size(img_intensity);

	%% Sharpening Algo
	
	% Blurring the Image
	blurred_img = double(gauss_blur(img_intensity, n, sig));
	max_im = max(max(blurred_img));
	min_im = min(min(blurred_img));
	blurred_img = 255*(blurred_img - min_im)/(max_im-min_im);

	% sharpening mask
	mask = double(img_intensity) - blurred_img;

	% Unsharp masking
	enhanced_img = (1.001-amount)*double(img_intensity) + amount*mask;
	
	% contrast enhancement of final image
	max_im = double(max(max(enhanced_img)));
	min_im = double(min(min(enhanced_img)));
	enhanced_img = 255*(double(enhanced_img) - min_im)/(max_im-min_im);

	if ndims(orig_img) == 3								% Colored Images
		img_hsv(:,:,3) = enhanced_img/255.0;			% range for V in HSV must be in [0,1]
		enhanced_img = uint8(255*hsv2rgb(img_hsv));
	else 												% Grayscale Images
		enhanced_img = uint8(enhanced_img);				% Casting the image back for b/w images
	end
	
	% Displaying images
	% subplot(1,3,1);
	% imshow(orig_img);
	% title('Original Image');
	% subplot(1,3,2)
	% imshow(mask);
	% title('Mask');
	% subplot(1,3,3);
	% imshow(enhanced_img);
	% title('Enhanced image');
	
end