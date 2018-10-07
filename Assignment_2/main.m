ground_truth = rgb2gray(imread('images/lena_bw.png'));
kernel = ones(9,9)/9^2;
degraded_img = double(imfilter(ground_truth, kernel)) + double(10*randn(M, N));

radius = 80;
thresh = 1;
k = 0.5;
gam = 1;

% Inverse Filtering
% inverse_filtering(degraded_img, kernel, thresh);

% Truncated inverse filtering
% truncated_inverse_filtering(degraded_img, kernel, thresh, radius);

% Wiener Filtering
% wiener_filtering(degraded_img, kernel, thresh, k);

% Constrained Least square filtering
clsf(degraded_img, kernel, thresh, gam);
