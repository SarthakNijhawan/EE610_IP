function [spliced_img] = bitplane_splicing(orig_img, plane_num)
	% Input:
	%       orig_img    -> Original Input Image
	% 		plane_num 	-> Plane number to be shown (must be in the range 1-8) 
	%
	% Output:
	%		thresh_img 	-> Binary image 
	%
	% Description:  
	%		: All the operations are performed on the variable "img_intensity"
	%       : For colored images the same algorithm is performed on the Value(V) plane in HSV
	%		: n must be an odd integer

	if ndims(orig_img) == 3									% Colored Images
			img_hsv = rgb2hsv(orig_img);
			img_intensity = 255.0*img_hsv(:,:,3);			% To ensure range of value is in mapped to [0,255]
		else
			img_intensity = orig_img;						% Grayscale Images
	end
	
	plane_num = round(plane_num);							% To ensure plane number is an integer
	[M,N] = size(img_intensity);     						% size of original image				

	% Segregation of bit planes from the image (MSB:1 LSB:8)
	bit = zeros(M,N,8);
	temp_img = uint8(img_intensity);						% Ensures the image intensities lie in the range of 8-bits
	for i = 1:8
		bit(:,:,9-i) = mod(temp_img, 2);
		temp_img = temp_img/2;
	end

	% output plane
	spliced_img = uint8(255*bit(:, :, plane_num));

	% subplot(241)
	% imshow(spliced_img(:,:,1));
	% subplot(242)
	% imshow(spliced_img(:,:,2));
	% subplot(243)
	% imshow(spliced_img(:,:,3));
	% subplot(244)
	% imshow(spliced_img(:,:,4));
	% subplot(245)
	% imshow(spliced_img(:,:,5));
	% subplot(246)
	% imshow(spliced_img(:,:,6));
	% subplot(247)
	% imshow(spliced_img(:,:,7));
	% subplot(248)
	% imshow(spliced_img(:,:,8));
	
end
	