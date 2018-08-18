function [mirrored_img] = mirror_img(orig_img)
	
	[M,N,C] = size(orig_img);                     % Assuming Black and white
	mirrored_img = zeros(M,N,C);

	for i=1:M
		for j=1:N             
			 % Rotating each coordinate w.r.t the center of the image
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