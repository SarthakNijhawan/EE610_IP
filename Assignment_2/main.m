% Author: Sarthak Nijhawan
% 
% Description:  Main Script to initiate an interactive command line interface 
%               to showcase and compare various image restoration techniques

close all
clear all

original_img = imread('images/GroundTruth2.jpg');
degraded_img = imread('images/Blurry2_2.jpg');
kernel = imread('images/kernel2_tiled.png');

% Normalising the kernel
kernel = double(kernel)/sum(sum(kernel));

% Calculating the evaluation metrics
calculate_similarity(degraded_img, original_img);

% Display the ground truth and degraded images
figure(1),clf
subplot(221),imshow(original_img),title('GroundTruth Image')
subplot(222),imshow(degraded_img),title('Degraded Image')

disp('Original and Degraded images are shown!');
disp('Next, choose any filter you wanna apply');
disp('press any key to continue ...')
pause

% Inverse Filtering
ans = input('Enter 1 to try Inverse Filtering, other key to skip : ');
if ~isempty(ans)
	finv = restore_img(degraded_img, kernel, 'inverse');
	calculate_similarity(finv, original_img);
	figure(1),
	subplot(223),imshow(finv),title('Inverse Filtering')
end

% Truncated Inverse filtering
while 1
	ans = input('Enter 1 to try Truncated Inverse Filtering, other key to skip : ');
	if ~isempty(ans)
		radius = input('Enter the radius : ');
		ftrunc = restore_img(degraded_img, kernel, 'truncated inverse', radius);
		calculate_similarity(ftrunc, original_img);
		figure(1),
		subplot(224),imshow(ftrunc),title(strcat('Truncated Inverse Filtering, radius = ', num2str(radius)))
	else
		break;
	end
end

disp('Opening new figure for Wiener and CLS filters, press enter to continue!');
pause

% Display the ground truth and degraded images
figure(2),clf
subplot(221),imshow(original_img),title('GroundTruth Image')
subplot(222),imshow(degraded_img),title('Degraded Image')

% Wiener filtering
while 1
	ans = input('Enter 1 to try Wiener Filtering, other key to skip : ');
	if ~isempty(ans)
		K = input('Enter K (the parameter, default=0.01) : ');
		if isempty(K) K=0.01; end
		fwin = restore_img(degraded_img, kernel, 'wiener', K);
		calculate_similarity(fwin, original_img);
		figure(2),
		subplot(223),imshow(fwin),title(strcat('Wiener Filtering, K = ', num2str(K)))
	else
		break;
	end
end

% CLSF
while 1
	ans = input('Enter 1 to try CLS Filtering, other key to skip : ');
	if ~isempty(ans)
		gamma = input('Enter gamma (the parameter, default=0.01) : ');
		if isempty(gamma) gamma=0.01; end
		fcls = restore_img(degraded_img, kernel, 'clsf', gamma);
		calculate_similarity(fcls, original_img);
		figure(2),
		subplot(224),imshow(fcls),title(strcat('CLS Filtering, gamma = ', num2str(gamma)))
	else
		break;
	end
end

disp('STOP!!!')
pause

% gamma = .001;
% p=[0 -1 0; -1 4 -1; 0 -1 0];
% Pp=fft2(p.*tmp(1:size(p,1),1:size(p,2)),64,64);
% Hhcls=conj(Hh).*Gg./(H2+gamma*abs(Pp).^2);
% hcls=abs(ifft2(Hhcls));
% figure(1),subplot(325),imagesc(hcls),title(['CLS, gamma=' num2str(gamma)])
% colormap('gray')

% disp(['Initial result of CLS filter using gamma = ' num2str(gamma)])

% % now start iteration
% eta2=mn*sigma^2;  % (5.9-12), m_eta = 0 in this example
% disp(['||eta||^2 = ' num2str(eta2)])
% icnt=0; cntmax=20;
% converge=0; 
% accuracy=mn*sigma;  % accuracy factor a in (5.9-8), every pixel within sigma
% gub=10; glb=0; % upper and lower bounds of gamma initially
% while converge==0, % start iteration
%    icnt=icnt+1; disp(['iteration # ' int2str(icnt)]);
%    % Use Parsevel theorem, ||r||^2 = sum sum |R|^2
%    Rr=abs(Gg-Hh.*Hhcls);
%    r2=(sum(sum(abs(Rr).^2))-Rr(1,1)^2)/mn;  % remove the mean value
%    disp(['||r||^2 = ' num2str(r2) ', ||eta||^2 = ' num2str(eta2)])
%    if abs(r2-eta2)<accuracy, converge=1;  %done, do nothing
%    else
% 	  if r2 < eta2, % gamma too small
% 		 if gamma > glb, glb=gamma; end % update lower bound
% 		 % gamma=gamma*(1+0.9^icnt); disp(['gamma increased to: ' num2str(gamma)]);
% 	  elseif r2 > eta2, % gamma too large
% 		 if gamma < gub, gub=gamma; end % update upper bound
% 		 % gamma=gamma*(1-0.9^icnt); disp(['gamma decreased to: ' num2str(gamma)]);
% 	  end
% 	  gamma=0.5*(gub+glb);  % use bisection search
% 	  Hhcls=conj(Hh).*Gg./(H2+gamma*abs(Pp).^2);
% 	  hcls=abs(ifft2(Hhcls));
% 	  if rem(icnt-1,3)==0, % plot 1, 4, 7, 10, 13 iterations
% 		figure(2),
% 		eval(['subplot(23' int2str(ceil(icnt/3)) '),'])
% 		imagesc(hcls),title(['iteration ' int2str(icnt) ', gamma=' num2str(gamma)])
% 		colormap('gray')
% 		disp(['gamma = ' num2str(gamma) ', enter any key to continue ...'])
% 	  end
% 	  pause
% 	  if icnt == cntmax, 
% 		 converge=1; disp('Reach max. iteration count, stop!')
% 	  end
%    end % if abs(... loop
% end % while loop
% figure(2),
% subplot(236),
% imagesc(hcls),title(['iteration ' int2str(icnt) ', gamma=' num2str(gamma)])
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