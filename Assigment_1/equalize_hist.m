function [enhanced_img] = equalize_hist(orig_img)
	% Input Parameters:
	%		orig_img 	-> 	Original Input Image
	% 
	% Note	: all the operations are performed on the variable "img_val"
	%		: 

	if ndims(orig_img) == 3						% Colored Images
		img_hsv = rgb2hsv(orig_img);
		img_val = 255.0*img_hsv(:,:,3);			% To ensure range of value is in mapped to [0,255]
	else
		img_val = orig_img;						% Grayscale Images
	end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%
	L = 256;									% Number of levels in intensity
	[M, N] = size(img_val);
	
	% Calculating the pdf of the img
	pdf = zeros(1, 256);
	for i=1:M
		for j=1:N
			pdf(1, 1+img_val(i,j)) = pdf(1, 1+img_val(i,j)) + 1;
		end
	end
	pdf = pdf/(M*N);        					% Normalisation
	
	% cdf of the image is used as the transformation function
	cdf = cumsum(pdf);
	
	% Final image
	enhanced_img = (L-1)*cdf(img_val+1);

	% enhanced_img = zeros(M, N);
	% for i=1:M
	% 	for j=1:N
	% 		enhanced_img(i,j) = (L-1)*cdf(img(i,j)+1);
	% 	end
	% end
	%%%%%%%%%%%%%%%%%%%%%%

	if ndims(orig_img) == 3						% Colored Images
		img_hsv(:,:,3) = enhanced_img/(L-1);	% range for V in HSV must be in [0,1]
		enhanced_img = hsv2rgb(img_hsv);
	else 										% Grayscale Images
		enhanced_img = uint8(enhanced_img);		% Casting the image back for b/w images
	end

	% Displaying Images	
	subplot(1,2,1)
	imshow(orig_img);
	title('Original Image');
	subplot(1,2,2)
	imshow(enhanced_img);
	title('Enhanced image');
	
end