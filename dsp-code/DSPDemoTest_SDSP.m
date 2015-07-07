inputDir = 'datasets\';
outputDir = 'output\VGG12\SDSP\alpha_gamma\';
mkdir(outputDir);

className = 'VGG_wall';
fileName1 = '_b';
fileName2 = '_a';
outputName = [className '_' fileName2(end) 'to' fileName1(end) '_'];
load(['datasets\S-DSP_Flow\' className(5:end) '_1to2_S-DSP(SIFT)+PMF(SGDL) alpha=0.1 gamma=0.25_SDSP_label.mat']);


im1 = im2double(imread([inputDir className fileName1 '.ppm']));
im2 = im2double(imread([inputDir className fileName2 '.ppm']));

pca_basis = [];
sift_size = 12;

% extract SIFT
[sift1, bbox1] = ExtractSIFT_WithPadding(im1, pca_basis, sift_size);
[sift2, bbox2] = ExtractSIFT_WithPadding(im2, pca_basis, sift_size);
% im1 = im1(bbox1(3):bbox1(4), bbox1(1):bbox1(2), :);
% im2 = im2(bbox2(3):bbox2(4), bbox2(1):bbox2(2), :);
% anno1 = anno1(bbox1(3):bbox1(4), bbox1(1):bbox1(2), :);
% anno2 = anno2(bbox2(3):bbox2(4), bbox2(1):bbox2(2), :);

init_flow = dsp_label_result(:,:,1:2);
% Match
tic; 
[vx,vy, tmp] = DSPMatch_SDSP(sift1, sift2, init_flow); 
% t_match = toc;
toc;

% Evaluation
% [seg, acc] = TransferLabelAndEvaluateAccuracy(anno1, anno2, vx, vy);
% acc.time = t_match;

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