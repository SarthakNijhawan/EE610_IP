function [Rotated_img] = rotate_img(im,theta)
img = im;
A=imread(img);

x1=zeros([size(A,1)*size(A,2) 1]);
x2=zeros([size(A,2)*size(A,1) 1]);

%Specify the degree
deg=theta;

%Change the image size
Rotated_img=uint8(zeros([size(A,1) size(A,2) 3 ]));

m=1;
%Find the midpoint
midx=ceil((size(Rotated_img,1)+1)/2);
midy=ceil((size(Rotated_img,2)+1)/2);

for i=1:size(A,1)
    i1=i-midx;
    for j=1:size(A,2)
        %convert from cartesian to polar
        [t,r]=cart2pol(i1,j-midy);
        %Convert from radians to degree and add the degree value
        t1=radtodeg(t)+deg;
        %Convert from degree to radians
        t=degtorad(t1);
        %Convert to Cartesian Co-ordinates
        [x,y]=pol2cart(t,r);
        x1(m)=round(x+midx);
        x2(m)=round(y+midy);  
        m=m+1;
    end
end

%check whether the values are within the image size.
x1(find(x1 < 1))=1;
x2(find(x2 < 1))=1;

n=1;
for i=1:size(A,1)
    for j=1:size(A,2)
        Rotated_img(x1(n),x2(n),:)=A(i,j,:);
        n=n+1;
    end
end