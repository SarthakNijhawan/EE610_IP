function [enhanced_img] = blur(img, n, sig)
	%%% NOTE: n is assumed to be an odd integer
	
	if length(size(img)) == 2           % For grayscale images 
		D=1;
		[M,N]=size(img);
	else                                % Colored Images
		[M,N,D]=size(img);
	end

	ext = (n-1)/2;                      % Is an integer for odd n's

	% Guassian mask 2D
	filt2D = double(gauss2D(n, sig, sig));
	
	% paddings on both sides
	pad_img = padarray(img, [ext, ext], 0);
	pad_img = double(pad_img);

	% filt2D at each layer
	for k = 1:D                         % For each layer
		filt(:,:,k) = filt2D;
	end

	% applying the window
	enhanced_img = ones([M,N,D]);
	for i = 1:M
		for j = 1:N
			enhanced_img(i,j,:) = sum(sum(pad_img(i:(i+2*ext), j:(j+2*ext), :).*filt));
		end
	end
	enhanced_img = uint8(enhanced_img);	% Casting the image 

	% Displaying the images
	subplot(1,2,1)
	imshow(img)
	title('Original Image');
	subplot(1,2,2)
	imshow(enhanced_img)
	title('Enhanced image');
end