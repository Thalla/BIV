I = imread('cubism.jpg');
I= rgb2gray(I);
corners = detectFASTFeatures(I, 'MinQuality', 0.1);
figure
imshow(I); hold on;
plot(corners.selectStrongest(50));

corners = detectFASTFeatures(I, 'ROI', [1,1,100,100]);
figure
imshow(I); hold on;
plot(corners.selectStrongest(50));

corners = detectFASTFeatures(I, 'MinContrast', 0.5);
figure
imshow(I); hold on;
plot(corners.selectStrongest(50));