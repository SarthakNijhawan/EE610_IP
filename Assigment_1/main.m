einstein = imread('images/einstein.jpg');
barbara = imread('images/barbara.png');
lena = imread('images/lena.png');
baboon = imread('images/baboon.png');
photo = imread('images/photo.jpeg');
goldhill = imread('images/goldhill.bmp');
hist_eq = imread('images/histo_eq.jpg');
hist_eq3 = imread('images/hist_eq3.jpg');

img = rgb2gray(einstein);
img2 = rgb2gray(hist_eq3);

% blur(lena, 3, 1);
