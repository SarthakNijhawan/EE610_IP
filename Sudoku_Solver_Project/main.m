%% Pre-processing
%Load the image
img = imread('test_imgs/sudoku1.jpg');
img = imresize(img, 0.3);
gray = rgb2gray(img);

%% Main Code
%Adaptive Thresholding
bw = adaptivethresh(gray);
bw = ~bw;
bw = edge(gray, 'Canny');

%Noise Removal (Morph Opening)
se = strel('disk', 1);				%Try other SEs too
opened = imopen(bw, se);
closed = imclose(opened, se);

%Largest Connected Component
% outer_grid = ExtractLargestCC(opened);
s = regionprops(bw,'centroid');
centroids = cat(1, s.Centroid);

%Morphing


%Hough Transform 


%Divide into boxes

%Digit extraction

%Apply digit classification


%% Display the images
figure(1)
subplot(231)
imshow(gray);
title('Gray Version');

subplot(232)
imshow(bw);
title('Adaptive Thresholding');

subplot(233)
imshow(opened);
title('Opened Image');

subplot(234)
imshow(bw)
hold on
plot(centroids(:,1), centroids(:,2), 'b*')
hold off
