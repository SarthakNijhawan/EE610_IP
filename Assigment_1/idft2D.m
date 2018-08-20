function [idft] = idft2D(orig_img)
	% Input:
	%       orig_img    -> DFT of an image (Complex)
	%
	% Output:
	%		 dft 		-> 2D IDFT of the input image 
	%
	% Description:
	%		: Calculates the centralised 2D IDFT of the input image

	tic

	[M, N] = size(orig_img);

	ext_M = round((M-1)/2);
	ext_N = round((N-1)/2);

	% Shifting Centralised DFT back to origin

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Normal Wala %%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	% dft_img = orig_img;

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Centralised Wala %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	dft_img = double(translate_img(orig_img, -ext_M, -ext_N, 1));

	x_coord = [0:M-1];
	y_coord = [0:N-1];
	[nx,ny] = ndgrid(x_coord, y_coord);

	% Centralized 2D Discrete Fourier Transform
	idft = zeros(M,N);
	du=1;
	for u = x_coord
		dv=1;
		for v = y_coord

			% Output(du, dv) = sum(sum(img_intensity.*exp(-1i*2*pi*(u*nx/M+v*ny/N))));
			temp = sum(dft_img.*exp((1i*2*pi*u/M)*nx));
			idft(du, dv) = sum(temp.*exp((1i*2*pi*v/N)*y_coord));

			dv=dv+1;
		end
		du=du+1;
	end
	idft = idft/(M*N);

	% idft = ifft2(dft_img);

	% Return scaled intensity map
	idft = real(idft);
	idft = uint8(255*idft/max(max(idft)));

	% Displaying the images
	figure;
	subplot(1,3,1);
	imshow(orig_img);
	title('DFT Image');
	subplot(1,3,2)
	imshow(idft);
	title('Reconstructed Image');
	
	toc

end