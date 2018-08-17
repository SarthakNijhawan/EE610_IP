function [enhanced_img, mask] = sharpen(img, n, k)
	
	if length(size(img)) == 2           % For grayscale images 
		D=1;
		[M,N]=size(img);
	else                                % Colored Images
		[M,N,D]=size(img);
	end
	
	blur_img = blur(img, n, 10);
	
	% mask used for sharpening
	mask = img-blur_img;
	
	% unsharp masking
	enhanced_img = uint8((img + k*mask)/(1+k));
	
% 	display([M,N,D]);
% 	display(size(enhanced_img));
	
	% contrast enhancement
	max_im = double(max(max(enhanced_img)));
	min_im = double(min(min(enhanced_img)));
	
	for k=1:D
		enhanced_img(:,:,k) = uint8(255*(double(enhanced_img(:,:,k)) - min_im(k).*ones(M,N))/(max_im(k)-min_im(k)));
	end
	
	% Displaying images
	subplot(1,3,1);
	imshow(img);
	title('Original Image');
	subplot(1,3,2)
	imshow(mask);
	title('Mask');
	subplot(1,3,3);
	imshow(enhanced_img);
	title('Enhanced image');
	
end