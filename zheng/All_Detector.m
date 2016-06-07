I = imread('cubism.jpg');
I= rgb2gray(I);
points = detectSURFFeatures(I);
figure
imshow(I); hold on;
plot(points.selectStrongest(10));

corners = detectFASTFeatures(I);
figure
imshow(I); hold on;
plot(corners.selectStrongest(50));

points = detectBRISKFeatures(I);
figure
imshow(I); hold on;
plot(points.selectStrongest(20));

regions = detectMSERFeatures(I);
figure; 
imshow(I); hold on;
plot(regions, 'showPixelList', true, 'showEllipses', false);

corners = detectMinEigenFeatures(I);
figure;
imshow(I); hold on;
plot(corners.selectStrongest(50));

corners = detectHarrisFeatures(I);
figure;
imshow(I); hold on;
plot(corners.selectStrongest(50));
