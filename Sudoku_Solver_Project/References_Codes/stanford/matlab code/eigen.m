N_CLASSES = 9;
IM_WIDTH = 20;
IM_HEIGHT = 20;
IM_PIX = IM_WIDTH * IM_HEIGHT;

NUM_EIGENFACES = 50;

training_dir = 'training20/';
testing_dir = 'testing20b/';

% read training images
[S_train,class_train,avg_train] = readClassifiedImages(training_dir, ...
                                    N_CLASSES, IM_WIDTH, IM_HEIGHT, []);
                                
% read testing images
[S_test,class_test] = readClassifiedImages(testing_dir, N_CLASSES, ...
                                IM_WIDTH, IM_HEIGHT, avg_train);


% compute eigenvectors of S matrix with largest eigenvalues
[V,D] = eigs(S_train'*S_train, NUM_EIGENFACES);
SV = normc(S_train*V);


% project training images onto eigenfaces space
S2_train = (S_train' * SV)';


% find class means
S2_class_means = zeros(NUM_EIGENFACES, N_CLASSES);
for i=1:N_CLASSES
    S2_class = S2_train(:,class_train==i);
    S2_class_means(:,i) = mean(S2_class,2);
end


% project testing images onto eigenfaces space
S2_test = (S_test' * SV)';


% match images to a class mean image using nearest neighbor

[IDX,D] = knnsearch(S2_class_means', S2_train');
train_accuracy = sum(IDX'==class_train) / size(S2_train,2)

[IDX,D] = knnsearch(S2_class_means', S2_test');
test_accuracy = sum(IDX'==class_test) / size(S2_test,2)


% match test image to a training image using nearest neighbor
%{
[IDX,D] = knnsearch(S2_train', S2_test');
test_accuracy = sum(class_train(IDX)==class_test) / size(S2_test,2)
%}