%% Use Local Features
% Registering two images is a simple way to understand local features. This example finds a geometric transformation between two images. It uses local features to find well-localized anchor points.

% Copyright 2015 The MathWorks, Inc.


%% Display two images. 
% The first image is the original image.

% original = imread('Lilie10.JPG');
% original = imread('beautifulFungi.tif');
% original = imread('Immunsystem Netz.bmp');
% original = imread('Libelle größer.tif');
% original = imread('Marienkäfer.jpg');
% original = imread('Fliege.JPG'); % wenige erkannte Features
 original = imread('P1240301.JPG'); % mit 'MetricThreshold', 20000.0 nur ein Punkt erkannt -> Fehlermeldung
 original2 = imread('P1240305.JPG');
% original = imread('Flechten.JPG');

original = rgb2gray(original);
original2 = rgb2gray(original2);
figure;
imshow(original);
%%
% The second image, is the original image rotated and scaled.
scale = 1.3;
%J = imresize(original2,scale);
theta = 31;
%distorted = imrotate(J,theta);%, 'bilinear', 'crop');
figure ('Name','SURFFeatures blob size 2','NumberTitle','off')
imshow(distorted); hold on;

%% Detect matching features between the original and distorted image.
% Detecting the matching SURF features is the first step in determining the transform needed to correct the distorted image.
ptsOriginal  = detectSURFFeatures(original);
% Parameter ab 1: Je größer desto größer die angezeigten blobs (Größe
% entspricht der Detailebene des entdeckten Features)
% ptsDistorted = detectSURFFeatures(distorted, 'NumOctaves', 1);
% strongest feature threshold: default 1000.0, je größer desto weniger wird
% angezeigt
ptsDistorted = detectSURFFeatures(distorted, 'MetricThreshold', 1000.0);
plot(ptsDistorted);
%% Extract features and compare the detected blobs between the two images.
% The detection step found several roughly corresponding blob structures in both images. Compare the detected blob features. This process is facilitated by feature extraction, which determines a local patch descriptor. 
[featuresOriginal,validPtsOriginal]  = extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = extractFeatures(distorted,ptsDistorted);
%%
% It is possible that not all of the original points were used to extract descriptors. Points might have been rejected if they were too close to the image border. Therefore, the valid points are returned in addition to the feature descriptors. 

%% 
% The patch size used to compute the descriptors is determined during the feature extraction step. The patch size corresponds to the scale at which the feature is detected. Regardless of the patch size, the two feature vectors, |featuresOriginal| and |featuresDistorted|, are computed in such a way that they are of equal length. The descriptors enable you to compare detected features, regardless of their size and rotation.

%% Find candidate matches.
% Obtain candidate matches between the features by inputting the descriptors to the |matchFeatures| function. Candidate matches imply that the results can contain some invalid matches. Two patches that match can indicate like features but might not be a correct match. A table corner can look like a chair corner, but the two features are obviously not a match.
indexPairs = matchFeatures(featuresOriginal,featuresDistorted);
%% Find point locations from both images.
% Each row of the returned |indexPairs| contains two indices of candidate feature matches between the images. Use the indices to collect the actual point locations from both images.
matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
%% Display the candidate matches. 
figure
showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted)
title('Candidate matched points (including outliers)')
%% Analyze the feature locations.
% If there are a sufficient number of valid matches, remove the false matches. An effective technique for this scenario is the RANSAC algorithm. The |estimateGeometricTransform| function implements M-estimator sample consensus (MSAC), which is a variant of the RANSAC algorithm. MSAC finds a geometric transform and separates the inliers (correct matches) from the outliers (spurious matches). 
[tform, inlierDistorted,inlierOriginal] = estimateGeometricTransform(matchedDistorted,matchedOriginal,'similarity');
%% Display the matching points.
figure
showMatchedFeatures(original,distorted,inlierOriginal,inlierDistorted)
title('Matching points (inliers only)')
legend('ptsOriginal','ptsDistorted')
%% Verify the computed geometric transform.
% Apply the computed geometric transform to the distorted image.
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tform,'OutputView',outputView);
%% 
% Display the recovered image and the original image.
figure
imshowpair(original,recovered,'montage')