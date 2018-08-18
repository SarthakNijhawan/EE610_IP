function [thresh_img] = adaptive_thresh(orig_img, n, C)
	% Input Parameters:
	%       orig_img    ->  Original Input Image
	% 		n 			-> size of the window
	% 		C 			-> Constant parameter in local windows
	%
	% Note  : all the operations are performed on the variable "img_val"
	%       : 

	if ndims(orig_img) == 3                     % Colored Images
		img_hsv = rgb2hsv(orig_img);
		img_val = 255.0*img_hsv(:,:,3);         % To ensure range of value is in mapped to [0,255]
	else
		img_val = orig_img;                     % Grayscale Images
	end

	ext = (n-1)/2;          % an integer for odd integers
	[M,N] = size(img_val);
	
	% Locally thresholding the image (pixel by pixel)
	thresh_img = zeros(M,N);
	for i=1:M
		for j=1:N
			start_x = max(1, i-ext); 
			end_x = min(M, i+ext);
			start_y = max(1, j-ext); 
			end_y = min(N, j+ext);
			
			window = img_val(start_x:end_x, start_y:end_y);
			
			% Mean as a threshold
			% thresh_img(i,j) = img_val(i,j) > (mean(mean(window))-C);

			% Median as a threshold
			% thresh_img(i,j) = img_val(i,j) > (median(median(window))-C);

			% Threshold using Otsu's method
			thresh_img(i,j) = img_val(i,j) > (Otsu(window)-C);

		end
	end
	
	thresh_img = uint8(255*thresh_img);

	size(thresh_img)

	% Displaying Images 
	subplot(1,2,1)
	imshow(orig_img);
	title('Original Image');
	subplot(1,2,2)
	imshow(thresh_img);
	title('Enhanced image');
	
end