function [spliced_img] = bitplane_splicing(orig_img)
	
    if ndims(orig_img) == 3						% Colored Images
            img_hsv = rgb2hsv(orig_img);
            img_val = 255.0*img_hsv(:,:,3);			% To ensure range of value is in mapped to [0,255]
        else
            img_val = orig_img;						% Grayscale Images
    end
    
    [M,N] = size(img_val);     %size of original image
	bit = zeros(M,N,8);         

	for i=1:M
		for j=1:N
			k = 0;
			num = img_val(i,j);
			while(num>0)
				k=k+1;
				bit(i,j,k) = uint8(num/2) - uint8((num-1)/2);
				num = uint8((num-1)/2);
            end
		end
	end

	spliced_img = 255*bit;
	spliced_img = uint8(spliced_img);

	subplot(241)
	imshow(spliced_img(:,:,1));
	subplot(242)
    imshow(spliced_img(:,:,2));
	subplot(243)
    imshow(spliced_img(:,:,3));
	subplot(244)
    imshow(spliced_img(:,:,4));
	subplot(245)
    imshow(spliced_img(:,:,5));
	subplot(246)
    imshow(spliced_img(:,:,6));
	subplot(247)
    imshow(spliced_img(:,:,7));
	subplot(248)
    imshow(spliced_img(:,:,8));
	
end
	