function [] = idft2D(orig_img)
	% Input Parameters:
	%		orig_img 	-> 	Original Input Image
	% 
	% Note	: all the operations are performed on the variable "img_val"
	%		: 

	tic

	if ndims(orig_img) == 3						% Colored Images
		img_hsv = rgb2hsv(orig_img);
		img_val = double(255.0*img_hsv(:,:,3));			% To ensure range of value is in mapped to [0,255]
	else
		img_val = double(orig_img);						% Grayscale Images
	end

	[M,N] = size(img_val);

	ext_M = (M-1)/2;
	ext_N = (N-1)/2; 

	x_coord = [0:M-1]-ext_M;
	y_coord = [0:N-1]-ext_N;

	%% Centralized 2D Discrete Fourier Transform
	[nx,ny] = ndgrid(x_coord, y_coord);
	Output = zeros(M,N);

	du=1;
	for u = x_coord
		dv=1;
		for v = y_coord

			Output(du, dv) = sum(sum(img_val.*exp(-1i*2*pi*(u*nx/M+v*ny/N))));
			dv=dv+1;

		end
		du=du+1;
	end

	mag = abs(Output);
	phase = angle(Output);

	mag = uint8(255*mag/max(max(mag)));
	phase = uint8(255*phase/max(max(phase)));

	% Displaying the images
	subplot(1,3,1);
	imshow(orig_img);
	title('Original Image');
	subplot(1,3,2)
	imshow(mag);
	title('Magnitude Plot');
	subplot(1,3,3);
	imshow(phase);
	title('Phase Plot');

	toc
	
end