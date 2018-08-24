function out_img = fft_shift(input_img)

	[M,N] = size(input_img)

	out_img = ones(M,N);

	out_img(1:M_pow2/2, 1:N_pow2/2) = mag(M_pow2/2+1:M_pow2, 1+N_pow2/2:N_pow2);
 	out_img(M_pow2/2+1:M_pow2, 1+N_pow2/2:N_pow2) = mag(1:M_pow2/2, 1:N_pow2/2);

	out_img(M_pow2/2+1:M_pow2, 1:N_pow2/2) = mag(1:M_pow2/2, 1+N_pow2/2:N_pow2);
 	out_img(1:M_pow2/2, 1+N_pow2/2:N_pow2) = mag(M_pow2/2+1:M_pow2, 1:N_pow2/2); 

end