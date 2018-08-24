function fft_seq = myFFT1D(input_sequence, n_points)
	
	% Finding the nearest power of 2
	% n_points = length(input_sequence);
	near_pow2 = pow2(nextpow2(n_points));
	pad_points = near_pow2-n_points;

	% Zero padding the input_sequence
	if pad_points > 0
		pad_array = zeros(1, pad_points);
		pad_input = double([input_sequence, pad_array]);
	else
		pad_input = input_sequence;
	end
	
	% Calculating DFT at each point
	fft_seq = myFFT1D_helper(pad_input, near_pow2);

	% Naive DFT-1D
	% fft_seq = ones(1,n_points);
	% for k=0:n_points-1
	% 	n = 0:n_points-1;
	% 	w = exp(-1i*2*pi*n*k/n_points);
	% 	fft_seq(k+1) = sum(input_sequence.*w);
	% end
	
end