original = imread('panda.jpg');
scale = 1.3;
J = imresize(original,scale);
theta = 31;
distorted = imrotate(J,theta);
original= rgb2gray(original);
distorted=rgb2gray(distorted);
ptsOriginalBRISK  = detectBRISKFeatures(original, 'MinContrast', 0.01);
ptsDistortedBRISK = detectBRISKFeatures(distorted, 'MinContrast', 0.01);

ptsOriginalSURF  = detectSURFFeatures(original);
ptsDistortedSURF = detectSURFFeatures(distorted);
[featuresOriginalFREAK,  validPtsOriginalBRISK]  = extractFeatures(original,  ptsOriginalBRISK);
[featuresDistortedFREAK, validPtsDistortedBRISK] = extractFeatures(distorted, ptsDistortedBRISK);

[featuresOriginalSURF,  validPtsOriginalSURF]  = extractFeatures(original,  ptsOriginalSURF);
[featuresDistortedSURF, validPtsDistortedSURF] = extractFeatures(distorted, ptsDistortedSURF);
indexPairsBRISK = matchFeatures(featuresOriginalFREAK, featuresDistortedFREAK, 'MatchThreshold', 40, 'MaxRatio', 0.8);

indexPairsSURF = matchFeatures(featuresOriginalSURF, featuresDistortedSURF);
matchedOriginalBRISK  = validPtsOriginalBRISK(indexPairsBRISK(:,1));
matchedDistortedBRISK = validPtsDistortedBRISK(indexPairsBRISK(:,2));

matchedOriginalSURF  = validPtsOriginalSURF(indexPairsSURF(:,1));
matchedDistortedSURF = validPtsDistortedSURF(indexPairsSURF(:,2));
matchedOriginalXY  = [matchedOriginalSURF.Location; matchedOriginalBRISK.Location];
matchedDistortedXY = [matchedDistortedSURF.Location; matchedDistortedBRISK.Location];
[tformTotal,inlierDistortedXY,inlierOriginalXY] = estimateGeometricTransform(matchedDistortedXY,matchedOriginalXY,'similarity');
figure
showMatchedFeatures(original,distorted,inlierOriginalXY,inlierDistortedXY)
title('Matching points using SURF and BRISK (inliers only)')
legend('ptsOriginal','ptsDistorted')

outputView = imref2d(size(original));
recovered  = imwarp(distorted,tformTotal,'OutputView',outputView);

figure;
imshowpair(original,recovered,'montage')