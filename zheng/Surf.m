original = imread('panda.jpg');
scale = 1.3;
J = imresize(original,scale);
theta = 31;
distorted = imrotate(J,theta);
original= rgb2gray(original);
figure
imshow(original);
distorted=rgb2gray(distorted);
figure
imshow(distorted);
ptsOriginalSURF  = detectSURFFeatures(original);
ptsDistortedSURF = detectSURFFeatures(distorted);
[featuresOriginalSURF,  validPtsOriginalSURF]  = extractFeatures(original,  ptsOriginalSURF);
[featuresDistortedSURF, validPtsDistortedSURF] = extractFeatures(distorted, ptsDistortedSURF);
indexPairsSURF = matchFeatures(featuresOriginalSURF, featuresDistortedSURF);
matchedOriginalSURF  = validPtsOriginalSURF(indexPairsSURF(:,1));
matchedDistortedSURF = validPtsDistortedSURF(indexPairsSURF(:,2));
figure
showMatchedFeatures(original, distorted, matchedOriginalSURF, matchedDistortedSURF)
title('Putative matches using SURF & FREAK')
legend('ptsOriginalSURF','ptsDistortedSURF')

[tform, inlierDistorted,inlierOriginal] = estimateGeometricTransform(matchedDistortedSURF,matchedOriginalSURF,'similarity');
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tform,'OutputView',outputView);
figure
imshowpair(original,recovered,'montage')