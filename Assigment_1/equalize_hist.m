function [enhanced_img] = equalize_hist(original_img)
	% Input:
	%       original_img    -> Original Input Image
	%
	% Output:
	%		enhanced_img -> Histogram Equalized image 
	%
	% Description:
	%		: All the operations are performed on the variable "img_intensity"
	%       : For colored images the same algorithm is performed on the Value(V) plane in HSV

	if ndims(original_img) == 3								% Colored Images
		img_hsv = rgb2hsv(original_img);
		img_intensity = 255.0*img_hsv(:,:,3);			% To ensure range of value is in mapped to [0,255]
	else
		img_intensity = original_img;						% Grayscale Images
	end

	L = 256;											% Number of levels in intensity
	[M, N] = size(img_intensity);
	
	% Calculating the pdf of the img
	pdf = zeros(1, 256);
	for i=1:M
		for j=1:N
			pdf(1, 1+img_intensity(i,j)) = pdf(1, 1+img_intensity(i,j)) + 1;
		end
	end
	pdf = pdf/(M*N);        							% Normalisation
	
	% cdf of the image is used as the transformation function
	cdf = cumsum(pdf);
	
	% Final image
	enhanced_img = (L-1)*cdf(img_intensity+1);

	if ndims(original_img) == 3							% Colored Images
		img_hsv(:,:,3) = enhanced_img/(L-1);			% range for V in HSV must be in [0,1]
		enhanced_img = uint8(255*hsv2rgb(img_hsv));
	else 												% Grayscale Images
		enhanced_img = uint8(enhanced_img);				% Casting the image back for b/w images
	end

	% Displaying Images	
	% subplot(1,2,1)
	% imshow(original_img);
	% title('Original Image');
	% subplot(1,2,2)
	% imshow(enhanced_img);
	% title('Enhanced image');
	
end