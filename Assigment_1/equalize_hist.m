function [enhanced_img] = equalize_hist(im)
    %%% NOTE: color_images not handled

    img = im;
	if length(size(img))==3
		img = rgb2gray(img);
	end
	
	L = 256;
	[M, N] = size(img);
	
	% Calculating the pdf of the img
	pdf = zeros(1, 256);
	for i=1:M
		for j=1:N
			pdf(1, 1+img(i,j)) = pdf(1, 1+img(i,j)) + 1;
		end
	end
	pdf = pdf/(M*N);        % Normalisation
	
	% cdf of the image is used as the transformation function
	cdf = zeros(1, 256);
	cdf(1) = pdf(1);
	for i = 2:256
		cdf(i) = cdf(i-1)+pdf(i);
	end
	
	% Final image
	enhanced_img = zeros(M, N);
	for i=1:M
		for j=1:N
			enhanced_img(i,j) = (L-1)*cdf(img(i,j)+1);
		end
	end
	enhanced_img = uint8(enhanced_img); 
	
	% Displaying images
	subplot(1,2,1)
	imshow(im)
	title('Original Image');
	subplot(1,2,2)
	imshow(enhanced_img)
	title('Enhanced image');

end