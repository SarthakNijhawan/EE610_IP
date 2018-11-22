N_CLASSES = 9;
IM_WIDTH = 20;
IM_HEIGHT = 20;
IM_PIX = IM_WIDTH * IM_HEIGHT;

NUM_EIGENFACES = 50;
NUM_FISHERFACES = 8;

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


% find training class means, overall mean for training images
class_means = zeros(NUM_EIGENFACES, N_CLASSES);
for i=1:N_CLASSES
    S2_class = S2_train(:,class_train==i);
    class_means(:,i) = mean(S2_class,2);
end
overall_mean = mean(S2_train,2);

% compute Rb, Rw
Rb = zeros(NUM_EIGENFACES, NUM_EIGENFACES);
Rw = zeros(NUM_EIGENFACES, NUM_EIGENFACES);
for i=1:N_CLASSES
    S2_class = S2_train(:,class_train==i);
    n = size(S2_class,2);
    
    % add to Rb
    means_diff = class_means(:,i) - overall_mean;
    Rb = Rb + n * (means_diff * means_diff');
    
    % add to Rw
    for j=1:n
        diff = S2_class(:,j) - class_means(:,i);
        Rw = Rw + (diff * diff');
    end
end


% find top N generalized eigenvector Rb*w = lambda*Rw*w
[fishers,D] = eigs(Rb,Rw,NUM_FISHERFACES);
fishers = normc(fishers);


% convert them back from eigenspace to pixels space
fisherfaces = SV * fishers;

% show the top N fisher faces
for i=1:NUM_FISHERFACES
   subplot(ceil(NUM_FISHERFACES/4),4,i);
   fisherface = reshape(fisherfaces(:,i), [IM_HEIGHT,IM_WIDTH]);
   imshow(mat2gray(fisherface));
   title(['fisherface ', num2str(i)]);
end


accuracies = zeros(1,NUM_FISHERFACES);
for NPCA=1:NUM_FISHERFACES  
    fishers_NPCA = fishers(:,1:NPCA);
    fisherfaces_NPCA = fisherfaces(:,1:NPCA);
    
    % find training class means in fisher space
    fisher_class_means = fishers_NPCA*(fishers_NPCA\class_means);
    
    
    % project training images onto fisherfaces space
    E_train = (S_train' * SV)';
    F_train = fishers_NPCA*(fishers_NPCA\E_train);
    
    
    % project testing images onto fisherfaces space
    E_test = (S_test' * SV)';
    F_test = fishers_NPCA*(fishers_NPCA\E_test);

    
    % match testing images to training images using nearest neighbor
    %IDX = knnsearch(F_train', F_test');
    %accuracies(NPCA) = sum(class_train(IDX)==class_test) / size(F_test,2);
    
    % match test images to training image class mean using nearest neighbor
    IDX = knnsearch(fisher_class_means', F_train');
    accuracies(NPCA) = sum(IDX'==class_train) / size(F_train,2);
end
accuracies
