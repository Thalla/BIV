original = imread('cameraman.tif');
scale=1.3;
J=imresize(original,scale);
theta=31;
distorted=imrotate(J,theta);
imshow(distorted);
original= rgb2gray(original);
distorted=rgb2gray(distorted);

ptsOriginal  = detectSURFFeatures( original);
ptsDistorted  = detectSURFFeatures( distorted);

[featuresOriginal,validPtsOriginal]  = extractFeatures(original,ptsOriginal);
[featuresDistorted,validPtsDistorted] = extractFeatures(distorted,ptsDistorted);

indexPairs = matchFeatures(featuresOriginal,featuresDistorted);

matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));
figure
showMatchedFeatures(original,distorted,matchedOriginal,matchedDistorted)



