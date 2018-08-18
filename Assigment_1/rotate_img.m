function [rotated_img] = rotate_img(im,theta)
img = im;
A=imread(img);

%new image empty matrix
rotated_img = zeros(size(A));

%Specify the degree
deg=theta;

%changing the origin
nRow = size(A,1);
nCol = size(A,2);
half_nRow = nRow./2;
half_nCol = nCol./2;

for i=1:size(rotated_img,1)
    for j=1:size(rotated_img,2)
         x= (i)*cos(deg)+(j)*sin(deg);
         y=-(i)*sin(deg)+(j)*cos(deg);
         x= round(x)+half_nRow;
         y= round(y)+half_nCol;

         if (x >= 1 && y >= 1 && x <= size(A,2) && y <= size(A,1))
              rotated_img(i,j) = A(x,y); % k degrees rotated image         
         end
    end
end