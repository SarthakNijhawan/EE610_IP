function [enhanced_img] = sharpen(orig_img, n, sig, k)
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

	%% Sharpening Algo
	identity_mask = zeros(n);
	identity_mask((n+1)/2,(n+1)/2) = 1;

	% "mask" Acts a High Pass Filter
	% mask_filter = identity_mask - gauss2D(n, sig, sig);
	mask_filter = identity_mask - box2D(n);
	
	% Applying the mask
	mask = double(filter_image(img_val, mask_filter));
	mask = double(255*(mask > mean(mean(mask))));

	% Unsharp masking
	enhanced_img = (1-k)*double(img_val) + k*mask;
	% enhanced_img = adapthisteq(enhanced_img);	

	% contrast enhancement of mask
	% max_im = double(max(max(enhanced_img)));
	% min_im = double(min(min(enhanced_img)));
	% enhanced_img = 255*(double(enhanced_img) - min_im*ones(M,N))/(max_im-min_im);

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