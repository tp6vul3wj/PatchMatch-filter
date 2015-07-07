file_name1 = 'Faces_0022.jpg';
file_name2 = 'Faces_0245.jpg';

% image1 = imread([input_dir file_name1]);
% image2 = imread([input_dir file_name2]);
im1 = im2double(imread(file_name1));
im2 = im2double(imread(file_name2));

pca_basis = [];
sift_size = 4;

% extract SIFT
[sift1, bbox1] = ExtractSIFT(im1, pca_basis, sift_size);
[sift2, bbox2] = ExtractSIFT(im2, pca_basis, sift_size);
im1 = im1(bbox1(3):bbox1(4), bbox1(1):bbox1(2), :);
im2 = im2(bbox2(3):bbox2(4), bbox2(1):bbox2(2), :);

% Match
tic; 
[vx,vy] = DSPMatch(sift1, sift2); 
t_match = toc;

% Warping
warp21=warpImage(im2double(im2),vx,vy); % im2 --> im1

% figure,
% subplot(2,2,1);
% imshow(im1);
% title('image1');
% subplot(2,2,3);
% imshow(im2);
% title('image2');
% subplot(2,2,2);
% imshow(warp21);
% title('warp 2-->1');

figure; imshow(im1);
figure; imshow(im2);
figure; imshow(warp21);