function [filt] = gauss2D(n, sig_x, sig_y)
    f1 = gauss1D(n, sig_x);
    f2 = gauss1D(n, sig_y);
    
    filt = transpose(f2)*f1;
    
%     filt = uint8(255*filt);
%     imshow(filt);
end