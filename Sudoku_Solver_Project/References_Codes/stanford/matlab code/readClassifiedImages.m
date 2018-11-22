function [S, class, I_avg] = readClassifiedImages(images_dir, n_classes,...
    im_width, im_height, I_training_avg)

im_pix = im_width * im_height;

training_images = cell(1,n_classes);

I_avg = 0;
n_images = 0;
for N = 1:n_classes
    % read images from this class's folder
    dir_path = [images_dir, num2str(N), '/'];
    files = dir(dir_path);
    
    % store them in a matrix for this class
    j = 0;
    images = zeros(im_pix,length(files));
    for i=1:length(files)
        filename = files(i).name;
        C = strsplit(filename, '.');
        if ~strcmp(C{length(C)}, 'png');
            continue;
        end
        j = j + 1;
        
        I = im2double(imread([dir_path, filename]));
        images(:,j) = I(:);
        I_avg = I_avg + I;
    end
    images = images(:,1:j);
    training_images{N} = images;
    n_images = n_images + j;
end

if isempty(I_training_avg)
    I_avg = I_avg / n_images;
else
    I_avg = I_training_avg;
end

% subtract avg from all images
for N = 1:n_classes
    j = size(training_images{N}, 2);
    %training_images{N} = training_images{N} - repmat(I_avg(:),[1,j]);
end

% compute S matrix and class array
% class[i] tells you which class image i belongs to
S = zeros(im_pix, n_images);
i = 1;
for N = 1:n_classes
    j = size(training_images{N}, 2);
    S(:, i:i+j-1) = training_images{N};
    class(i:i+j-1) = N;
    i = i + j;
end

end