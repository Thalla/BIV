I = imread('cubism.jpg');
I= rgb2gray(I);

corners = detectHarrisFeatures(I,'FilterSize', 5);
figure;
imshow(I); hold on;
plot(corners.selectStrongest(50));

corners = detectHarrisFeatures(I,'FilterSize', 13);
figure;
imshow(I); hold on;
plot(corners.selectStrongest(50));

corners = detectHarrisFeatures(I,'FilterSize', 117);
figure;
imshow(I); hold on;
plot(corners.selectStrongest(50));