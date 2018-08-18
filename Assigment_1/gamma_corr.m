function [enhanced_img] = gamma_corr(orig_img, gamma)
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

	L = 256;	        						% Number of levels

	enhanced_img = double(img_val)/(L-1);		% Scaling down the intensity values in the range [0,1]
	enhanced_img = power(enhanced_img, gamma);	% Applying the power law function
	
	if ndims(orig_img) == 3						% Colored Images
		img_hsv(:,:,3) = enhanced_img;
		enhanced_img = hsv2rgb(img_hsv);
	else 										% Grayscale Images
		enhanced_img = uint8(255*enhanced_img);	% Rescaling the 
	end

	% Displaying Images	
	% subplot(1,2,1)
	% imshow(orig_img);
	% title('Original Image');
	% subplot(1,2,2)
	% imshow(enhanced_img);
	% title('Enhanced image');
	
end