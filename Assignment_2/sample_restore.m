% Author: Sarthak Nijhawan
% 
% Disclaimer: None of the code has been copied or emulted from any outside source
% 
% Description:  Main Script to initiate an interactive command line interface 
% 				to showcase and compare various image restoration techniques on
% 				sample images mentioned in the problem statement

img = input('Enter the image number in the range 1 to 4 : ');
% ker = input('Enter the kernel number in the range 1 to 4 : ');

orig_img_path = sprintf('images/GroundTruth%d.jpg', img);
degraded_path = sprintf('images/Blurry%d_%d.jpg', img, img);
kernel_path = sprintf('images/Kernel%d_%d.jpg', img, img);
% kernel_path =sprintf('images/kernel%d_tiled.png', img);

original_img = imread(orig_img_path);
degraded_img = imread(degraded_path);
kernel = imread(kernel_path);

% Normalising the kernel
kernel = double(kernel)/sum(sum(kernel));

% Display the ground truth and degraded images
figure(1),clf
subplot(131),imshow(original_img),title('GroundTruth Image')
subplot(132),imshow(degraded_img),title('Degraded Image')

% figure(1),clf
% subplot(221),imshow(original_img),title('GroundTruth Image')
% subplot(222),imshow(degraded_img),title('Degraded Image')

% Calculating the evaluation metrics
calculate_similarity(degraded_img, original_img, ' degraded image');

disp('Next, choose any filter you wanna apply');
disp('press any key to continue ...')
pause

while 1
	fprintf('\n\n');
	disp('Please enter any one of the filter numbers : ')
	disp('(1) Inverse Filtering');
	disp('(2) Truncated Inverse Filtering');
	disp('(3) Wiener Filtering');
	disp('(4) Constrained Least Square Filtering');
	ans = input('Response = ');

	switch ans
		case 1
			restored = restore_img_rgb(degraded_img, kernel, 'inverse');
			
			str1 = 'Inverse Filtering';
			str2 = ' inverse filtered image';

		case 2
			% ans = input('Do you wish to calculate the optimum value? y/n ', 's');
			% if ans=='y' || ans=='Y'
			% 	radius = calculate_optimum_val(original_img, degraded_img, kernel, 'truncated inverse');
			% else
				radius = input('Enter the radius : ');
			% end

			restored = restore_img_rgb(degraded_img, kernel, 'truncated inverse', radius);
			
			str1 = strcat('Truncated Inverse Filtering, radius = ', num2str(radius));
			str2 = ' truncated image';

		case 3
			% ans = input('Do you wish to calculate the optimum value? y/n ', 's');
			% if ans=='y' || ans=='Y'
			% 	K = calculate_optimum_val(original_img, degraded_img, kernel, 'wiener');
			% else
				K = input('Enter K (the parameter, default=0.01) : ');
				if isempty(K) K=0.01; end
			% end

			restored = restore_img_rgb(degraded_img, kernel, 'wiener', K);
			
			str1 = strcat('Wiener Filtering, K = ', num2str(K));
			str2 = ' wiener filtered image';

		case 4	
			% ans = input('Do you wish to calculate the optimum value? y/n ', 's');
			% if ans=='y' || ans=='Y'
			% 	alpha = calculate_optimum_val(original_img, degraded_img, kernel, 'clsf');
			% else
				alpha = input('Enter alpha (the parameter, default=0.01) : ');
			% 	if isempty(alpha) alpha=0.01; end
			% end
				
			restored = restore_img_rgb(degraded_img, kernel, 'clsf', alpha);

			str1 = strcat('CLS Filtering, alpha = ', num2str(alpha));
			str2 = ' CLS filtered image';

		otherwise
			fprintf('Invalid entry\n Exiting........' );
			break;
	end

	figure(1),
	subplot(133),imshow(restored),title(str1)
	calculate_similarity(restored, original_img, str2);
	
	ans = input('Do wanna save the image? y/n', 's');
	if ans == 'y' || ans == 'Y'
		img_path = input('Please enter the image path!! ', 's');
		imwrite(restored, img_path);
	end
end

% % Inverse Filtering
% ans = input('Enter 1 to try Inverse Filtering, other key to skip : ');
% if ~isempty(ans)
% 	finv = restore_img_rgb(degraded_img, kernel, 'inverse');
% 	figure(1),
% 	subplot(223),imshow(finv),title('Inverse Filtering')
% 	calculate_similarity(finv, original_img, ' inverse filtered image');
% end

% % Truncated Inverse filtering
% while 1
% 	ans = input('Enter 1 to try Truncated Inverse Filtering, other key to skip : ');
% 	if ~isempty(ans)
% 		radius = input('Enter the radius : ');
% 		ftrunc = restore_img_rgb(degraded_img, kernel, 'truncated inverse', radius);
% 		figure(1),
% 		subplot(224),imshow(ftrunc),title(strcat('Truncated Inverse Filtering, radius = ', num2str(radius)))
% 		calculate_similarity(ftrunc, original_img, ' truncated filtered image');
% 	else
% 		break;
% 	end
% end

% disp('Opening new figure for Wiener and CLS filters, press enter to continue!');
% pause

% % Display the ground truth and degraded images
% figure(2),clf
% subplot(221),imshow(original_img),title('GroundTruth Image')
% subplot(222),imshow(degraded_img),title('Degraded Image')

% % Wiener filtering
% while 1
% 	ans = input('Enter 1 to try Wiener Filtering, other key to skip : ');
% 	if ~isempty(ans)
% 		K = input('Enter K (the parameter, default=0.01) : ');
% 		if isempty(K) K=0.01; end
% 		fwin = restore_img_rgb(degraded_img, kernel, 'wiener', K);
% 		figure(2),
% 		subplot(223),imshow(fwin),title(strcat('Wiener Filtering, K = ', num2str(K)))
% 		calculate_similarity(fwin, original_img, ' wiener filtered image');
% 	else
% 		break;
% 	end
% end

% % CLSF
% while 1
% 	ans = input('Enter 1 to try CLS Filtering, other key to skip : ');
% 	if ~isempty(ans)
		% alpha = input('Enter alpha (the parameter, default=0.01) : ');
		% if isempty(alpha) alpha=0.01; end
		% fcls = restore_img_rgb(degraded_img, kernel, 'clsf', alpha);
		% figure(2),
		% subplot(224),imshow(fcls),title(strcat('CLS Filtering, alpha = ', num2str(alpha)))
		% calculate_similarity(fcls, original_img, ' CLS filtered image');
% 	else
% 		break;
% 	end
% end

disp('The program ends here!!!');
disp('Press any key to continue...........');
pause

% alpha = .001;
% p=[0 -1 0; -1 4 -1; 0 -1 0];
% Pp=fft2(p.*tmp(1:size(p,1),1:size(p,2)),64,64);
% Hhcls=conj(Hh).*Gg./(H2+alpha*abs(Pp).^2);
% hcls=abs(ifft2(Hhcls));
% figure(1),subplot(325),imagesc(hcls),title(['CLS, alpha=' num2str(alpha)])
% colormap('gray')

% disp(['Initial result of CLS filter using alpha = ' num2str(alpha)])

% % now start iteration
% eta2=mn*sigma^2;  % (5.9-12), m_eta = 0 in this example
% disp(['||eta||^2 = ' num2str(eta2)])
% icnt=0; cntmax=20;
% converge=0; 
% accuracy=mn*sigma;  % accuracy factor a in (5.9-8), every pixel within sigma
% gub=10; glb=0; % upper and lower bounds of alpha initially
% while converge==0, % start iteration
%    icnt=icnt+1; disp(['iteration # ' int2str(icnt)]);
%    % Use Parsevel theorem, ||r||^2 = sum sum |R|^2
%    Rr=abs(Gg-Hh.*Hhcls);
%    r2=(sum(sum(abs(Rr).^2))-Rr(1,1)^2)/mn;  % remove the mean value
%    disp(['||r||^2 = ' num2str(r2) ', ||eta||^2 = ' num2str(eta2)])
%    if abs(r2-eta2)<accuracy, converge=1;  %done, do nothing
%    else
% 	  if r2 < eta2, % alpha too small
% 		 if alpha > glb, glb=alpha; end % update lower bound
% 		 % alpha=alpha*(1+0.9^icnt); disp(['alpha increased to: ' num2str(alpha)]);
% 	  elseif r2 > eta2, % alpha too large
% 		 if alpha < gub, gub=alpha; end % update upper bound
% 		 % alpha=alpha*(1-0.9^icnt); disp(['alpha decreased to: ' num2str(alpha)]);
% 	  end
% 	  alpha=0.5*(gub+glb);  % use bisection search
% 	  Hhcls=conj(Hh).*Gg./(H2+alpha*abs(Pp).^2);
% 	  hcls=abs(ifft2(Hhcls));
% 	  if rem(icnt-1,3)==0, % plot 1, 4, 7, 10, 13 iterations
% 		figure(2),
% 		eval(['subplot(23' int2str(ceil(icnt/3)) '),'])
% 		imagesc(hcls),title(['iteration ' int2str(icnt) ', alpha=' num2str(alpha)])
% 		colormap('gray')
% 		disp(['alpha = ' num2str(alpha) ', enter any key to continue ...'])
% 	  end
% 	  pause
% 	  if icnt == cntmax, 
% 		 converge=1; disp('Reach max. iteration count, stop!')
% 	  end
%    end % if abs(... loop
% end % while loop
% figure(2),
% subplot(236),
% imagesc(hcls),title(['iteration ' int2str(icnt) ', alpha=' num2str(alpha)])
% colormap('gray')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% h = fspecial('disk', 15);

% cam = im2double(rgb2gray(imread('images/lena_bw.png')));
% hf = fft2(h, size(cam,1), size(cam,2));
% cam_blur = real(ifft2(hf.*fft2(cam)));
% sigma_u = 10^(-40/20)*abs(1-0);
% img = cam_blur + sigma_u*randn(size(cam_blur));


% h = fspecial('disk', 15);

% % Read image and convert to double for FFT
% cam = im2double(rgb2gray(imread('images/lena_bw.png')));
% hf = fft2(h,size(cam,1),size(cam,2));

% cam_blur = real(ifft2(hf.*fft2(cam)));

% figure
% subplot(141)
% imshow(cam_blur)

% sigma_u = 10^(-40/20)*abs(1-0);
% cam_blur_noise = cam_blur + sigma_u*randn(size(cam_blur));
% subplot(142)
% imshow(cam_blur_noise)

% cam_inv = inverse_filtering(cam_blur_noise, h, 0.1);
% subplot(143)
% imshow(cam_inv)

% cam_pinv = real(ifft2((abs(hf) > 0.1).*fft2(cam_blur_noise)./hf));
% subplot(144)
% imshow(cam_pinv)
% xlabel('pseudo-inverse restoration')