function [dft] = dft2D(orig_img)
	% Input:
	%       orig_img    -> Original Input Image
	%
	% Output:
	%		 dft 		-> 2D DFT of the input image 
	%
	% Description:
	%		: Calculates the centralised 2D DFT of the input image
	%		: All the operations are performed on the variable "img_intensity"
	%       : For colored images the same algorithm is performed on the Value(V) plane in HSV

	tic

	if ndims(orig_img) == 3								% Colored Images
		img_hsv = rgb2hsv(orig_img);
		img_intensity = double(255.0*img_hsv(:,:,3));			% To ensure range of value is in mapped to [0,255]
	else
		img_intensity = double(orig_img);						% Grayscale Images
	end

	[M,N] = size(img_intensity);

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Centralised Wala %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% ext_M = round((M-1)/2);
	% ext_N = round((N-1)/2); 

	% x_coord = [0:M-1]-ext_M;
	% y_coord = [0:N-1]-ext_N;
	% [nx,ny] = ndgrid(x_coord, y_coord);

	% % Centralized 2D Discrete Fourier Transform
	% dft = zeros(M,N);
	% du=1;
	% for u = x_coord
	% 	dv=1;
	% 	for v = y_coord

	% 		% dft(du, dv) = sum(sum(img_intensity.*exp(-1i*2*pi*(u*nx/M+v*ny/N))));
	% 		temp = sum(img_intensity.*exp((-1i*2*pi*u/M)*nx));
	% 		dft(du, dv) = sum(temp.*exp((-1i*2*pi*v/N)*y_coord));
			
	% 		dv=dv+1;
	% 	end
	% 	du=du+1;
	% end

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Normal Wala %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	x_coord = [0:M-1];
	y_coord = [0:N-1];
	[nx,ny] = ndgrid(x_coord, y_coord);

	% Centralized 2D Discrete Fourier Transform
	dft = zeros(M,N);
	du=1;
	for u = x_coord
		dv=1;
		for v = y_coord

			% dft(du, dv) = sum(sum(img_intensity.*exp(-1i*2*pi*(u*nx/M+v*ny/N))));
			temp = sum(img_intensity.*exp((-1i*2*pi*u/M)*nx));
			dft(du, dv) = sum(temp.*exp((-1i*2*pi*v/N)*y_coord));
			
			dv=dv+1;
		end
		du=du+1;
	end


	%% Displaying the images
	mag = abs(dft);
	mag = uint8(255*mag/max(max(mag)));

	subplot(1,3,1);
	imshow(orig_img);
	title('Original Image');
	subplot(1,3,2)
	imshow(mag);
	title('Magnitude Plot');
	
	toc

end