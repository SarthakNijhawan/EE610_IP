function [thresh_img] = adaptive_thresh(original_img, n, C)
	% Input:
	%       original_img    -> Original Input Image
	% 		n 			-> Size of the kernel 
	% 		C 			-> Constant parameter to enhance contrast
	%
	% Output:
	%		thresh_img 	-> Binary (thresholded) image 
	%
	% Description:
	%		: All the operations are performed on the variable "img_intensity"
	%       : For colored images the same algorithm is performed on the Value(V) plane in HSV
	%		: n must be an odd integer
	%		: Out of the 2 procedures (Mean-Median) we have shown only mean_filtering in GUI
	%		  others can be shown ny uncommenting the respective ones.

	if ndims(original_img) == 3                     	% Colored Images
		img_hsv = rgb2hsv(original_img);
		img_intensity = 255.0*img_hsv(:,:,3);       	% To ensure range of value is in mapped to [0,255]
	else
		img_intensity = original_img;                   % Grayscale Images
	end

	ext = (n-1)/2;          							% an integer for odd integers
	[M,N] = size(img_intensity);
	
	% Locally thresholding the image (By window sliding method)
	thresh_img = zeros(M,N);
	for i=1:M
		for j=1:N
			start_x = max(1, i-ext); 
			end_x = min(M, i+ext);
			start_y = max(1, j-ext); 
			end_y = min(N, j+ext);
			
			window = img_intensity(start_x:end_x, start_y:end_y);

			% Mean-thresholding
			% thresh_img(i,j) = img_intensity(i,j) > (mean(mean(window))-C);

			% Median-thresholding
			% thresh_img(i,j) = img_intensity(i,j) > (median(median(window))-C);

		end
	end

	thresh_img = uint8(255*thresh_img);

	% % Displaying Images 
	% subplot(1,2,1)
	% imshow(original_img);
	% title('Original Image');
	% subplot(1,2,2)
	% imshow(thresh_img);
	% title('Enhanced image');
	
end