function [translated_img] = translate_img(orig_img, x, y, mod_check)
	% Input:
	%       orig_img    -> Input Image
	%       x           -> Translation in x-direction
	%       y           -> Translation in y-direction
	%
	% Output:
	%       translated_img -> Translated version of the input image 
	%
	% Description:
	%       : Returns the translated image

	[M,N,C] = size(orig_img);

	% Translation Algorithm
	translated_img = zeros(M,N,C);
	for i=1:M
		for j=1:N             

		x1 = i + x;
		y1 = j + y;

		if mod_check
			x1 = mod(i + x, M)+1;
			y1 = mod(j + y, N)+1;
		end

		if (x1>=1 && y1>=1 && x1<=M && y1<=N)
			if C == 1
				translated_img(x1,y1) = orig_img(i,j);
			else
				translated_img(x1,y1,:) = orig_img(i,j,:);
			end
		end
		end
	end
	
	translated_img = uint8(translated_img);
	
	%subplot(1,2,1)
	%imshow(orig_img);
	%subplot(1,2,2)
	%imshow(translated_img);
	
end