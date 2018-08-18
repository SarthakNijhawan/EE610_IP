function [enhanced_img] = hist_spec(original_img, reference_img)
    %  File and function name : threshold_grayscale_image
	%  thresholded_image = threshold_grayscale_image(original_image,min_threshold,max_threshold)
	%            (0 <= min_threshold, max_threshold <= 255)
	%
	%  Inputs        :   original_image  - original monochrome image (0 - black, 255 - white)
	%                    min_threshold   - minimum value that should be recognized as a feature (inclusive).
	%                    max_threshold   - maximum value that should be recoginized as a feature (inclusive).
	%                    Inputs can be any data type.
	%
	%  Outputs       :   thresholded_image - binary thresholded image of type uint8
	%                         Outside threshold = black(0),   Within threshold = white(1)
	%
	%  Description   :   If the pixel in the original image has a value between the min_threshold 
	%                    and max_threshold (inclusive), then it will be assigned as a white pixel in the binary 
	%                    image. Otherwise it will be a black pixel.
	%
	%  Sample Code to run:
	%  monoImageArray = int16(imread('coins.png'));
	%  thresholded_image = threshold_grayscale_image(original_image, 83, 255)
	%            (0 <= min_threshold, max_threshold <= 255)
	
	[orig_M, orig_N] = size(original_img);
	[ref_M, ref_N] = size(reference_img);

	[orig_histo_count, x] = imhist(original_img);
	orig_pdf = orig_histo_count/sum(orig_histo_count);

	[ref_histo_count, x] = imhist(reference_img);
	ref_pdf = ref_histo_count/sum(ref_histo_count);
	
	orig_function = uint8(255*cumsum(orig_pdf));
	ref_function = uint8(255*cumsum(ref_pdf));

	transform_func = zeros(1, 256);

    for i = 1:256
        for index = 256:1
            if ref_function(index) <= orig_function(i)
                transform_func(i) = ref_function(index);
                transform_func(i)
                break
            end
        end
    end
    
	enhanced_img = transform_func(original_img+1);

	% Displaying images
	subplot(1,3,1);
	imshow(original_img);
	title('Original Image');
	subplot(1,3,2)
	imshow(reference_img);
	title('Mask');
	subplot(1,3,3);
	imshow(enhanced_img);
	title('Enhanced image');

end