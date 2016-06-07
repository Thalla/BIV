I = imread('cubism.jpg');
I= rgb2gray(I);


corners = detectFASTFeatures(I);
figure
imshow(I); hold on;
plot(corners.selectStrongest(50));


corners = detectMinEigenFeatures(I);
figure;
imshow(I); hold on;
plot(corners.selectStrongest(50));

corners = detectHarrisFeatures(I);
figure;
imshow(I); hold on;
plot(corners.selectStrongest(50));