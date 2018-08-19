function [mirrored_img] = mirror_img(orig_img)
	% Input:
	%       orig_img    -> Original Input Image
	%
	% Output:
	%		mirrored_img-> Mirrored Image about the vertical Axis 

	[M,N,C] = size(orig_img);

	% Mirroring Algorithm
	mirrored_img = zeros(M,N,C);
	for i=1:M
		for j=1:N             
			 % Flipping each coordinate
			 x1 = i ;
			 y1 = N - j;
			 
			 if (x1>=1 && y1>=1 && x1<=M && y1<=N)
				 if C == 1
					mirrored_img(i,j) = orig_img(x1,y1);
				 else
					mirrored_img(i,j,:) = orig_img(x1,y1,:);
				 end
			 end
		end
	end
	
	mirrored_img = uint8(mirrored_img);
	
	% subplot(1,2,1)
	% imshow(orig_img);
	% subplot(1,2,2)
	% imshow(mirrored_img);
	
end