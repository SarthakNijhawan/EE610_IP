function [enhanced_img] = log_transform(img)

	enhanced_img = log10(double(img)+1.0);
	enhanced_img = uint8(enhanced_img*255.0/log10(255.0));				%Normalisation
	
	subplot(1,2,1)
	imshow(img)
	title('Original Image');
	subplot(1,2,2)
	imshow(enhanced_img)
	title('Enhanced image');

end