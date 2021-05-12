close all

%% Replace the vlfeat directory link with yours below:
run('C:/Users/guest_admin/Downloads/vlfeat-0.9.21-bin.tar/vlfeat-0.9.21-bin/vlfeat-0.9.21/toolbox/vl_setup');
%%
pos_imageDir = 'cropped_training_images_faces';
[pos_train_nImages,n] = size(TrainingFace);
[pos_valid_nImages,n] = size(ValidationFace);
neg_imageDir = 'cropped_training_images_notfaces';
[neg_train_nImages, n] = size(TrainingNotFace);
[neg_valid_nImages,n] = size(ValidationNotFace);
%%
cellSize = 6;
featSize = 31*cellSize^2;
%%
pos_train_feats = zeros(pos_train_nImages,featSize);
name = {TrainingFace(1:pos_train_nImages).name};
for i=1:pos_train_nImages
    im = im2single(imread(sprintf('%s/%s',pos_imageDir,name{i})));
    feat = vl_hog(im,cellSize);
    pos_train_feats(i,:) = feat(:);
    fprintf('got feat for pos train image %d/%d\n',i,pos_train_nImages);
end
neg_train_feats = zeros(neg_train_nImages,featSize);
name = {TrainingNotFace(1:neg_train_nImages).name};
for i=1:neg_train_nImages
    im = im2single(imread(sprintf('%s/%s',neg_imageDir,name{i})));
    feat = vl_hog(im,cellSize);
    neg_train_feats(i,:) = feat(:);
    fprintf('got feat for neg image %d/%d\n',i,neg_train_nImages);
end
save('train_feats.mat','pos_train_feats','neg_train_feats','pos_train_nImages','neg_train_nImages')
%%
pos_valid_feats = zeros(pos_valid_nImages,featSize);
name = {ValidationFace(1:pos_valid_nImages).name};
for i=1:pos_valid_nImages
    im = im2single(imread(sprintf('%s/%s',pos_imageDir,name{i})));
    feat = vl_hog(im,cellSize);
    pos_valid_feats(i,:) = feat(:);
    fprintf('got feat for pos valid image %d/%d\n',i,pos_valid_nImages);
end
neg_valid_feats = zeros(neg_valid_nImages,featSize);
name = {ValidationNotFace(1:neg_valid_nImages).name};
for i=1:neg_valid_nImages
    im = im2single(imread(sprintf('%s/%s',neg_imageDir,name{i})));
    feat = vl_hog(im,cellSize);
    neg_valid_feats(i,:) = feat(:);
    fprintf('got feat for neg image %d/%d\n',i,neg_valid_nImages);
end
save('valid_feats.mat','pos_valid_feats','neg_valid_feats','pos_valid_nImages','neg_valid_nImages')
