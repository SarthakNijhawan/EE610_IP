function [filt] = gauss1D(n, sigma)
    
    % n must be odd
    x = 0:n-1;
    x = x - ((n-1)/2)*ones(1,n);
    filt = exp(-x.^ 2/(2 * sigma^2));
    filt = filt/sum(filt); % normalize
    
end