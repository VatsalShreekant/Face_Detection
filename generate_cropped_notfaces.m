% you might want to have as many negative examples as positive examples
%1.1
n_have = 1;
n_want = numel(dir('cropped_training_images_faces/*.jpg'));

imageDir = 'images_notfaces';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);

new_imageDir = 'cropped_training_images_notfaces';
mkdir(new_imageDir);
dim = 36;
squareSize = [36, 36];



i = 1;
while n_have < n_want + 1
    
    % generate random 36x36 crops from the non-face images
img = rgb2gray(imread(imageList(i).name));
name = imageList(i).name;
[row, col, ~] = size(img);
imgSize = [row, col];
maximumPosValue = (imgSize - squareSize + 1);
initialRandomPos = [randi(maximumPosValue(1)), randi(maximumPosValue(2))];
cropRect = [initialRandomPos(2), initialRandomPos(1), squareSize(2)-1, squareSize(1)-1];
imgCropped = imcrop(img, cropRect);
fprintf('%d\n',n_have);
imwrite(imgCropped, append('C:\Users\guest_admin\Downloads\A3\code_and_images\cropped_training_images_notfaces\' ,num2str(n_have),'.jpg'));
n_have = n_have +1;
check = n_have/nImages;
if rem(check,1)==0
   i = 0;
end
i = i + 1;
end
%%
%1.2
faceDir = 'cropped_training_images_faces';
FaceList = dir(sprintf('%s/*.jpg',faceDir));
[m,n] = size(FaceList) ;
P = 0.80 ;
idx = randperm(m)  ;
TrainingFace = FaceList(idx(1:round(P*m)),:) ; 
ValidationFace = FaceList(idx(round(P*m)+1:end),:) ;
n_face = 0;
%%
NotFaceList = dir(sprintf('%s/*.jpg',new_imageDir));
[m,n] = size(NotFaceList) ;
P = 0.80 ;
idx = randperm(m)  ;
TrainingNotFace = NotFaceList(idx(1:round(P*m)),:) ; 
ValidationNotFace = NotFaceList(idx(round(P*m)+1:end),:) ;
