function [enhanced_img] = sharpen(orig_img, n, k)
	% Input Parameters:
	%		orig_img 	-> 	Original Input Image
	%		n 			-> 	size of filter used for blurring
	%		k 			-> 	proportion of unsharp masking
	% 
	% Note	: all the operations are performed on the variable "img_val"
	%		: 

	if ndims(orig_img) == 3						% Colored Images
		img_hsv = rgb2hsv(orig_img);
		img_val = 255.0*img_hsv(:,:,3);			% To ensure range of value is in mapped to [0,255]
	else
		img_val = orig_img;						% Grayscale Images
	end
	
	[M,N] = size(img_val);

	blur_img = blur(img_val, n, 5);

	% mask used for sharpening
	mask = double(img_val)-double(blur_img);
	img_val = double(img_val);

	% unsharp masking
	enhanced_img = (img_val + k*mask)/(1+k);
	
	% contrast enhancement
	max_im = double(max(max(enhanced_img)));
	min_im = double(min(min(enhanced_img)));
	
	enhanced_img = 255*(double(enhanced_img) - min_im*ones(M,N))/(max_im-min_im);

	if ndims(orig_img) == 3						% Colored Images
		img_hsv(:,:,3) = enhanced_img/255.0;	% range for V in HSV must be in [0,1]
		enhanced_img = hsv2rgb(img_hsv);
	else 										% Grayscale Images
		enhanced_img = uint8(enhanced_img);		% Casting the image back for b/w images
	end
	
	% Displaying images
	subplot(1,3,1);
	imshow(orig_img);
	title('Original Image');
	subplot(1,3,2)
	imshow(mask);
	title('Mask');
	subplot(1,3,3);
	imshow(enhanced_img);
	title('Enhanced image');
	
end