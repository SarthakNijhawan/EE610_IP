%% calculate_similarity: function description
function [] = calculate_similarity(img1, img2, name)
	ans = input(strcat(['Do u wanna calculate similarity metrics for', name, ' ?y/n']), 's');
	if ans == 'y' || ans == 'Y'
		disp('Calculating.................');
		m = immse(img1, img2);                 % MSE
		p = psnr(img1, img2);                  % PSNR
		s = ssim(img1, img2);                  % SSIM

		disp(['RMS error per pixel = ', num2str(m)]);
		disp(['Calculated PSNR = ', num2str(p) ' dB']);
		disp(['Calculated SSIM = ', num2str(s)]);
	end
end