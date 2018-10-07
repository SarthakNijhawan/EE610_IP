function padded_img = pad_image(orig_img, req_size)
	M = req_size(1);
	N = req_size(2);
	
	[M_filt, N_filt] = size(orig_img);

	% ext_M = floor((M-M_filt)/2);
	% ext_N = floor((N-N_filt)/2);

	% padded_img = padarray(orig_img, [ext_M, ext_N], 0, 'both');

	% [M_P, N_P] = size(padded_img);
	% if ((M-M_filt)/2 - ext_M) == 0.5
	% 	row = zeros(1, N_P);
	% 	padded_img = [padded_img; row];
	% end

	% [M_P, N_P] = size(padded_img);
	% if ((N-N_filt)/2 - ext_N) == 0.5
	% 	col = zeros(M_P, 1);
	% 	padded_img = [padded_img, col];
	% end

	padded_img = zeros(M,N);
	padded_img(1:M_filt, 1:N_filt) = orig_img;

end