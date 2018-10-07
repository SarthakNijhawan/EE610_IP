
f=rgb2gray(imread('images/lena_bw.png'));
[M,N] = size(f);
n=0.2;

b=ones(4,4)/4^2;
F=fft2(f);
B=fft2(b,M,N);
G=F.*B;
g=ifft2(G)+10*randn(M,N);
G=fft2(g);

BF=find(abs(B)<n);
%B(BF)=max(max(B))/1.5;
B(BF)=n;
H=ones(M,N)./B;
I=G.*H;
im=abs(ifft2(I));

figure(1)
imshow(f)
figure(2)
imshow(abs(ifft2(G)))
figure(3)
imshow(im)
