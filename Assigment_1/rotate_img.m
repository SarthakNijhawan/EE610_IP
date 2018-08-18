function [rotated_img] = rotate_img(im,theta)
A = im;
%A=imread(img);

rotated_img = zeros(size(A));

%Specify the degree
rad = theta*pi/180;

midx = size(A,1);
midy = size(A,2);

for i=1:size(A,1)
    for j=1:size(A,2)

         x=(i)*cos(rad)+(j)*sin(rad);
         y= -(i)*sin(rad)+(j)*cos(rad);
         x=round(x)+midx;
         y=round(y)+midy;

         if (x>=1 && y>=1 && x<=size(A,2) && y<=size(A,1))
              rotated_img(x,y)=A(i,j);          
         end
    end
end

imshow(rotated_img);