# Face_Detection

## Single Scale Face Detection:
This project implements a multi-scale face detector. An SVM is trained to categorize 36 x 36 pixel images as “face” or “not face”, using Histogram of Oriented Gradients (HOG) features.

The face detection is performed based on the following steps:
1. Generate a set of cropped, grayscale, non-face images.
2. Split the training images into two sets: a training set, and a validation set. Use 80% of the data for training, and 20% for validation.
3. Generate HOG features for all of the training and validation images.
4. Train an SVM on the features from the training set.
5. Test the SVM on the validation set features. 
6. Gather the best accuracy on the validation set.

Classifier performance on training images:
<p align="center">
<kbd>![Capture](https://user-images.githubusercontent.com/32462270/117911775-58de1300-b2ac-11eb-8edc-3083df64591e.PNG)</kbd>
</p>


## Multi Scale Face Detection

The multi-scale face detection is performed based on the following steps:
1. Create a single-scale sliding window face detector, using the SVM trained in 'Face Detection'.
2. Apply 'non-maximum suppression' so that the face detector does not make overlapping predictions.
3. Upgrade the face detector so that it makes predictions at multiple scales.
4. Apply the face detector on class.jpg, and plot the bounding boxes on the image.

Multi-scale face detection using bounded boxes:
<p align="center">
<kbd><img width="423" alt="Capture" src="https://user-images.githubusercontent.com/32462270/117912500-a6a74b00-b2ad-11eb-994c-665b695a8d2f.PNG"></kbd>
</p>
<p align="center">
<kbd><img width="297" alt="Capture" src="https://user-images.githubusercontent.com/32462270/117912619-cccceb00-b2ad-11eb-987f-7fb1256159ab.PNG"></kbd>
</p>

<kbd>![170255819_4521368387879551_2972130169533207361_n](https://user-images.githubusercontent.com/32462270/117912405-7a8bca00-b2ad-11eb-8e6e-43a608b5d598.jpg)</kbd>
