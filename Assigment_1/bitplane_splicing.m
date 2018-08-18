function [spliced_img] = bitplane_splicing(orig_img)
	
    [M,N] = size(orig_img);     %size of original image
	bit = zeros(M,N,8);         

	for i=1:M
		for j=1:N
			k = 0;
			num = orig_img(i,j);
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
	