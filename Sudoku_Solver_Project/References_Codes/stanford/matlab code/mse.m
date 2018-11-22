N_CLASSES = 9;
IM_WIDTH = 20;
IM_HEIGHT = 20;
IM_PIX = IM_WIDTH * IM_HEIGHT;


training_dir = 'training20/';
testing_dir = 'testing20a/';

% read training images
[S_train,class_train,avg_train] = readClassifiedImages(training_dir, ...
                                    N_CLASSES, IM_WIDTH, IM_HEIGHT, []);
                                
% read testing images
[S_test,class_test] = readClassifiedImages(testing_dir, N_CLASSES, ...
                                IM_WIDTH, IM_HEIGHT, []);


imwrite(avg_train, 'mean.png', 'bitdepth',16);

fid = fopen('out.txt', 'w');
       


% find class means
fprintf(fid, ['float T[',num2str(N_CLASSES),'][',num2str(IM_PIX),'] = {']);
S_class_means = zeros(IM_PIX, N_CLASSES);
for i=1:N_CLASSES
    S_class = S_train(:,class_train==i);
    S_class_means(:,i) = mean(S_class,2);
    
    fprintf(fid, ['{',num2str(S_class_means(1,i))]);
    for j=2:IM_PIX
        fprintf(fid, [', ',num2str(S_class_means(j,i))]);
    end
    if i==N_CLASSES
        fprintf(fid, '}\n');
    else
        fprintf(fid, '},\n');
    end
end
fprintf(fid, '};\n');
fclose(fid);


% match images to a class mean image using nearest neighbor

[IDX,D] = knnsearch(S_class_means', S_train');
train_accuracy = sum(IDX'==class_train) / size(S_train,2)

[IDX,D] = knnsearch(S_class_means', S_test');
test_accuracy = sum(IDX'==class_test) / size(S_test,2)
