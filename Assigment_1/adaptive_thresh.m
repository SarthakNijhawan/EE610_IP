function [thresh_img] = adaptive_thresh(img, n)
    
    if length(size(img))==3
        img = rgb2gray(img);
    end
    
    ext = (n-1)/2;          % an integer for odd integers
    
    [M,N] = size(img);
    
    % Locally thresholding the image
    thresh_img = zeros(M,N);
    for i=1:M
        for j=1:N
            start_x = max(1, i-ext); 
            end_x = min(M, i+ext);
            start_y = max(1, j-ext); 
            end_y = min(N, j+ext);
            
            window = img(start_x:end_x, start_y:end_y);
            thresh_img(i,j) = img(i,j) > mean(mean(window));
        end
    end
    
    thresh_img = uint8(255*thresh_img);
    
    % displaying images
    subplot(1,2,1)
    imshow(img);
    title('Original Image');
    subplot(1,2,2)
    imshow(thresh_img);
    title('Thresholded Image');
    
end