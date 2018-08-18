function [enhanced_img] = log_transform(orig_img)
	% Input Parameters:
	%		orig_img 	-> 	Original Input Image
	%		gamma 		-> 	Gamma value
	% 
	% Note	: all the operations are performed on the variable "img_val"
	%		: for the intensities are first mapped to [0,1] and then the law is applied to ensure final range to be [0,1]

	if ndims(orig_img) == 3						% Colored Images
		img_hsv = rgb2hsv(orig_img);
		img_val = 255.0*img_hsv(:,:,3);			% To ensure range of value is in mapped to [0,255]
	else
		img_val = orig_img;						% Grayscale Images
	end

	enhanced_img = log10(double(img_val)+1.0);
	enhanced_img = enhanced_img*255.0/log10(256.0);	% Normalisation	so that the range is [0,255]
	
	if ndims(orig_img) == 3						% Colored Images
		img_hsv(:,:,3) = enhanced_img/255.0;	% range for V in HSV must be in [0,1]
		enhanced_img = hsv2rgb(img_hsv);
	else 										% Grayscale Images
		enhanced_img = uint8(enhanced_img);		% Casting the image back for b/w images
	end

	% Displaying Images	
	% subplot(1,2,1)
	% imshow(orig_img);
	% title('Original Image');
	% subplot(1,2,2)
	% imshow(enhanced_img);
	% title('Enhanced image');

end