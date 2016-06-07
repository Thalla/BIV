original = imread('panda.jpg');
scale = 1.3;
J = imresize(original,scale);
theta = 31;
distorted = imrotate(J,theta);
original= rgb2gray(original);
distorted=rgb2gray(distorted);
ptsOriginalBRISK  = detectBRISKFeatures(original, 'MinContrast', 0.01);
ptsDistortedBRISK = detectBRISKFeatures(distorted, 'MinContrast', 0.01);
[featuresOriginalFREAK,  validPtsOriginalBRISK]  = extractFeatures(original,  ptsOriginalBRISK);
[featuresDistortedFREAK, validPtsDistortedBRISK] = extractFeatures(distorted, ptsDistortedBRISK);
indexPairsBRISK = matchFeatures(featuresOriginalFREAK, featuresDistortedFREAK, 'MatchThreshold', 40, 'MaxRatio', 0.8);
matchedOriginalBRISK  = validPtsOriginalBRISK(indexPairsBRISK(:,1));
matchedDistortedBRISK = validPtsDistortedBRISK(indexPairsBRISK(:,2));
figure
showMatchedFeatures(original, distorted, matchedOriginalBRISK, matchedDistortedBRISK)
title('Putative matches using BRISK & FREAK')
legend('ptsOriginalBRISK','ptsDistortedBRISK')

[tform, inlierDistorted,inlierOriginal] = estimateGeometricTransform(matchedDistortedBRISK,matchedOriginalBRISK,'similarity');
outputView = imref2d(size(original));
recovered  = imwarp(distorted,tform,'OutputView',outputView);
figure
imshowpair(original,recovered,'montage')

