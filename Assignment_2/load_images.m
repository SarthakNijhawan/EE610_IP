gt1 = imread('images/GroundTruth1.jpg');
gt2 = imread('images/GroundTruth2.jpg');
gt3 = imread('images/GroundTruth3.jpg');
gt4 = imread('images/GroundTruth4.jpg');

k1 = imread('images/Kernel1.png');
k2 = imread('images/Kernel2.png');
k3 = imread('images/Kernel3.png');
k4 = imread('images/Kernel4.png');

k1_filt = double(k1)/sum(sum(k1));
k2_filt = double(k1)/sum(sum(k2));
k3_filt = double(k1)/sum(sum(k3));
k4_filt = double(k1)/sum(sum(k4));

blur1_1 = imread('images/Blurry1_1.jpg');
blur1_2 = imread('images/Blurry1_2.jpg');
blur1_3 = imread('images/Blurry1_3.jpg');
blur1_4 = imread('images/Blurry1_4.jpg');
blur2_1 = imread('images/Blurry1_1.jpg');
blur2_2 = imread('images/Blurry1_2.jpg');
blur2_3 = imread('images/Blurry1_3.jpg');
blur2_4 = imread('images/Blurry1_4.jpg');
blur3_1 = imread('images/Blurry1_1.jpg');
blur3_2 = imread('images/Blurry1_2.jpg');
blur3_3 = imread('images/Blurry1_3.jpg');
blur3_4 = imread('images/Blurry1_4.jpg');
blur4_1 = imread('images/Blurry1_1.jpg');
blur4_2 = imread('images/Blurry1_2.jpg');
blur4_3 = imread('images/Blurry1_3.jpg');
blur4_4 = imread('images/Blurry1_4.jpg');

