
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
B(BF)=n;
H=ones(M,N)./B;
I=G.*H;
im=abs(ifft2(I));

%% Display imgs
figure
subplot(1,3,1);
imshow(f);
subplot(1,3,2)
imshow(abs(ifft2(G)));
subplot(1,3,3)
imshow(im);
