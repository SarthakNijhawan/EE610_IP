function [translated_img] = translate_img(orig_img,x,y)
    
    [M,N,C] = size(orig_img);                     % Assuming Black and white
    translated_img = zeros(M,N,C);

    midx = round(M/2);
    midy = round(N/2);

    for i=1:M
        for j=1:N             
             % Rotating each coordinate w.r.t the center of the image
             x1 = i + x;       % Center is assumed to be (midx, midy)
             y1 = j + y;
             
             if (x1>=1 && y1>=1 && x1<=M && y1<=N)
                 if C == 1
                    translated_img(i,j) = orig_img(x1,y1);
                 else
                    translated_img(i,j,:) = orig_img(x1,y1,:);
                 end
             end
        end
    end
    
    translated_img = uint8(translated_img);
    
    %subplot(1,2,1)
    %imshow(orig_img);
    %subplot(1,2,2)
    %imshow(translated_img);
    
end