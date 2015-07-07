inputDir = 'datasets\';
outputDir = 'output\VGG12\diff patch\';
mkdir(outputDir);

className = 'VGG_graf';
fileName1 = '_b';
fileName2 = '_a';
outputName = [className '_' fileName2(end) 'to' fileName1(end) '_'];


im1 = im2double(imread([inputDir className fileName1 '.ppm']));
im2 = im2double(imread([inputDir className fileName2 '.ppm']));

pca_basis = [];
sift_size = 15;

% extract SIFT
[sift1, bbox1] = ExtractSIFT_WithPadding(im1, pca_basis, sift_size);
[sift2, bbox2] = ExtractSIFT_WithPadding(im2, pca_basis, sift_size);
% im1 = im1(bbox1(3):bbox1(4), bbox1(1):bbox1(2), :);
% im2 = im2(bbox2(3):bbox2(4), bbox2(1):bbox2(2), :);
% anno1 = anno1(bbox1(3):bbox1(4), bbox1(1):bbox1(2), :);
% anno2 = anno2(bbox2(3):bbox2(4), bbox2(1):bbox2(2), :);

% Match
tic; 
[vx,vy, tmp, grid_flow] = DSPMatch(sift1, sift2); 
% t_match = toc;
toc;

% Evaluation
% [seg, acc] = TransferLabelAndEvaluateAccuracy(anno1, anno2, vx, vy);
% acc.time = t_match;

grid_vx = grid_flow(:,:,2);
grid_vy = grid_flow(:,:,1);
grid_warp21 = warpImage(im2double(im2),grid_vx,grid_vy);
imwrite(grid_warp21, [outputDir outputName 'grid_warp.png'], 'png');

[im_h, im_w, ~] = size(grid_flow);
dsp_label_result = zeros(im_h,im_w,3);
dsp_label_result(:,:,1:2) = grid_flow;
dsp_label_result(:,:,3) = 1;
save([outputDir outputName '_label.mat'],'dsp_label_result');

% Warping
warp21=warpImage(im2double(im2),vx,vy); % im2 --> im1
imwrite(warp21, [outputDir outputName 'warp.png'], 'png');

save([outputDir outputName 'disp.mat'],'vx','vy');

% disp('----------------------------')
% disp('label transfer accuracy')
% disp(acc)
% 
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
% imwrite(warp21, 'test.jpg', 'jpg');
% subplot(2,2,4);
% imshow(seg);
% title('label transfer 2-->1');