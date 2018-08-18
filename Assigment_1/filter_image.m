function [enhanced_img] = filter_image(orig_img, filt2D)
	% Input Parameters:
	%		orig_img 	-> 	Original Input Image
	%		n 			-> 	Size of the input filter
	%		sig			->	Sigma of 2D-gaussian filter
	% 
	% Note	: n must be odd
	%		: all the operations are performed on the variable "img_val"

	if ndims(orig_img) == 3						% Colored Images
		img_hsv = rgb2hsv(orig_img);
		img_val = 255.0*img_hsv(:,:,3);			% To ensure range of value is in 255*[0,1]
	else
		img_val = orig_img;						% Grayscale Images
	end
	
	[M,N] = size(img_val);
    [n,n] = size(filt2D);
    
	ext = (n-1)/2;        	              		% Is an integer for odd n's

	% Zero-paddings in both dimensions
	pad_img = padarray(img_val, [ext, ext], 0);
	pad_img = double(pad_img);

	% applying the window
	enhanced_img = ones([M,N]);
	for i = 1:M
		for j = 1:N
			enhanced_img(i,j) = sum(sum(pad_img(i:(i+2*ext), j:(j+2*ext)).*filt2D));
		end
	end

	if ndims(orig_img) == 3						% Colored Images
		img_hsv(:,:,3) = enhanced_img/255.0;	% to ensure the range if "V" in HSV is [0,1]
		enhanced_img = hsv2rgb(img_hsv);
	else 										% Grayscale Images
		enhanced_img = uint8(enhanced_img);		% Casting the image into 8-bit integers
	end

end

