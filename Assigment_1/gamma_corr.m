function [enhanced_img] = gamma_corr(img, a)
	
	L = 256;        %Number of levels
	
	h = double(img)/(L-1);          %Scaling down the intensity values in the range [0,1]
	h = power(h, a);                %Applying the power law function
	
	enhanced_img = uint8((L-1)*h);       %Rescaling the intensity levels
	
	subplot(1,2,1)
	imshow(img);
	title('Original Image');
	subplot(1,2,2)
	imshow(enhanced_img);
	title('Enhanced image');
end