function [sheared_img] = shear_img(orig_img,alpha,beta)
    
    [M,N,C] = size(orig_img);                     % Assuming Black and white
    sheared_img = zeros(M,N,C);

    midx = round(M/2);
    midy = round(N/2);

    for i=1:M
        for j=1:N             
             % shifting each coordinate w.r.t the center of the image
             x1 = (i-midx) + alpha*(j-midy);    %shifting the origin to center of image  
             y1 = (j-midy) + beta*(i-midx);
             x1 = round(x1) + midx;
             y1 = round(y1) + midy;

             if (x1>=1 && y1>=1 && x1<=M && y1<=N)
                 if C == 1
                    sheared_img(i,j) = orig_img(x1,y1);
                 else
                    sheared_img(i,j,:) = orig_img(x1,y1,:);
                 end
             end
        end
    end
    
    sheared_img = uint8(sheared_img);
    
    subplot(1,2,1)
    imshow(orig_img);
    subplot(1,2,2)
    imshow(sheared_img);
    
end