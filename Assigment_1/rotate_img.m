function [rotated_img] = rotate_img(orig_img,theta)
    
    [M,N,C] = size(orig_img);                     % Assuming Black and white
    rotated_img = zeros(M,N,C);

    %Specify the degree
    rad = theta*pi/180;

    midx = round(M/2);
    midy = round(N/2);

    for i=1:M
        for j=1:N             
             % Rotating each coordinate w.r.t the center of the image
             x = (i-midx)*cos(rad)-(j-midy)*sin(rad);       % Center is assumed to be (midx, midy)
             y = (i-midx)*sin(rad)+(j-midy)*cos(rad);
             x = round(x) + midx;
             y = round(y) + midy;

             if (x>=1 && y>=1 && x<=M && y<=N)
                 if C == 1
                    rotated_img(i,j) = orig_img(x,y);
                 else
                    rotated_img(i,j,:) = orig_img(x,y,:);
                 end
             end
        end
    end
    
    rotated_img = uint8(rotated_img);
    
    %subplot(1,2,1)
    %imshow(orig_img);
    %subplot(1,2,2)
    %imshow(rotated_img);
    
end