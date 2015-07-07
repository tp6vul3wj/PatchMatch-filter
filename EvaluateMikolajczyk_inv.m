% close all
clear all
clc

class_name = 'wall';
file_name1 = '_1';
file_name2 = '_2';

DatasetsDir = [pwd '\datasets\VGG\' class_name '\'];
% ResultDir = [pwd '\Results\VGG\' class_name '_test\' file_name1(2:end) 'to' file_name2(2:end) '\'];
% ResultDir = [pwd '\Results\VGG\Original\' class_name '_test\' file_name1(2:end) 'to' file_name2(2:end) '\'];

ResultDir = [pwd '\Results\VGG\' class_name '_test\' file_name1(2:end) 'to' file_name2(2:end) '\'];
% ResultDir = [pwd '\Results\VGG\' class_name '_test\'];
% DistanceRatioRange = [0.001:0.001:0.3];
DistanceRatioRange = [0:5:100];

%% the ground truth
TMatrix = load([DatasetsDir 'H' file_name1(2:end) 'to' file_name2(2:end) 'p']) ;
% I1 = im2double(imread([DatasetsDir class_name file_name1 '.png']));
% I2 = im2double(imread([DatasetsDir class_name file_name2 '.png']));
I1 = im2double(imread([DatasetsDir 'img' file_name1(2:end) '.ppm']));
I2 = im2double(imread([DatasetsDir 'img' file_name2(2:end) '.ppm']));
[Height1,Width1,~] = size(I1);
[Height2,Width2,~] = size(I2);
NumPixel2 = Height2 * Width2;
Im2Loc = ones(Height2,Width2,3);
[Im2Loc(:,:,1),Im2Loc(:,:,2)] = meshgrid(1:Width2,1:Height2); % [XX,YY] = [Col, Row]
XLoc = Im2Loc(:,:,1);
YLoc = Im2Loc(:,:,2);
CorrespondLoc = TMatrix \ reshape(Im2Loc,[NumPixel2, 3])';
CorrespondXLoc = reshape(CorrespondLoc(1,:),[Height2,Width2]);
CorrespondYLoc = reshape(CorrespondLoc(2,:),[Height2,Width2]);
CorrespondWLoc = reshape(CorrespondLoc(3,:),[Height2,Width2]);
CorrespondXLoc = CorrespondXLoc ./ CorrespondWLoc;
CorrespondYLoc = CorrespondYLoc ./ CorrespondWLoc;
Mask = CorrespondXLoc >= 1 & CorrespondXLoc <= Width1 & CorrespondYLoc >= 1 & CorrespondYLoc <= Height1;

%% distance
ResultList = dir([ResultDir '*.mat']);
DistanceMap = cell(1,length(ResultList));
LegnendName = cell(1,length(ResultList));
for i = 1:length(ResultList)
    TempData = load([ResultDir ResultList(i).name],'vx','vy');
    [~,LegnendName{i},~] = fileparts(ResultList(i).name);
    ShiftX = (TempData.vx + XLoc);
    ShiftY = (TempData.vy + YLoc);
    DistanceMap{i} = sqrt((abs(ShiftX - CorrespondXLoc)).^2 + (abs(ShiftY - CorrespondYLoc)).^2);
end

% desc_map = zeros(Height1, Width1);
% all_dist = zeros(4,NumPixel2);
% for i = 1:4
%     all_dist(i,:) = reshape(DistanceMap{i},NumPixel2,[]);
% end
% [min_value indx] = min(all_dist);
% % min_value = reshape(min_value,Height2,Width2);
% indx = reshape(indx,Height2,Width2);
% desc_gray=mat2gray(indx,[1,4]);
% desc_X = gray2ind(desc_gray, 256);
% desc_im = ind2rgb(desc_X, jet(256));
% desc_im(:,:,1) = desc_im(:,:,1) .* Mask;
% desc_im(:,:,2) = desc_im(:,:,2) .* Mask;
% desc_im(:,:,3) = desc_im(:,:,3) .* Mask;
% figure, imshow(desc_im);
% 
% desc_selec = zeros(4,1);
% indx = indx .* Mask;
% for i = 1:4
%     tmp = indx==i;
%     desc_selec(i) = sum(tmp(:));
% end

%% plot
NumInBoundary = sum(Mask(:));
CorrectRatio = zeros(length(DistanceMap),length(DistanceRatioRange));
PlotType = {'-r+','-go','-b*','-cx','-mh'};
figure;
for i = 1:length(DistanceMap)
    for j = 1:length(DistanceRatioRange)
        TempMask = DistanceMap{i} < DistanceRatioRange(j) & Mask;
        CorrectRatio(i,j) = sum(TempMask(:)) / NumInBoundary;
    end
    plot(DistanceRatioRange,CorrectRatio(i,:),PlotType{i});
    hold on
end
legend(LegnendName, 'location','Best');
title([class_name ' (' file_name1(2:end) ' to ' file_name2(2:end) ')']);




% % close all
% clear all
% clc
% 
% class_name = 'leuven';
% file_name1 = '_1';
% file_name2 = '_6';
% 
% DatasetsDir = [pwd '\datasets\VGG\' class_name '\'];
% % ResultDir = [pwd '\Results\VGG\' class_name '_test\' file_name1(2:end) 'to' file_name2(2:end) '\'];
% ResultDir = [pwd '\Results\VGG\Original\' class_name '_test\' file_name1(2:end) 'to' file_name2(2:end) '\'];
% % ResultDir = [pwd '\Results\VGG\' class_name '_test\'];
% % DistanceRatioRange = [0.001:0.001:0.3];
% DistanceRatioRange = [0:5:100];
% 
% %% the ground truth
% TMatrix = load([DatasetsDir 'H' file_name1(2:end) 'to' file_name2(2:end) 'p']) ;
% % I1 = im2double(imread([DatasetsDir class_name file_name1 '.png']));
% % I2 = im2double(imread([DatasetsDir class_name file_name2 '.png']));
% I1 = im2double(imread([DatasetsDir 'img' file_name1(2:end) '.ppm']));
% I2 = im2double(imread([DatasetsDir 'img' file_name2(2:end) '.ppm']));
% [Height1,Width1,~] = size(I1);
% NumPixel1 = Height1 * Width1;
% [Height2,Width2,~] = size(I2);
% NumPixel2 = Height2 * Width2;
% 
% %% distance
% ResultList = dir([ResultDir '*.mat']);
% DistanceMap = cell(1,length(ResultList));
% LegnendName = cell(1,length(ResultList));
% for i = 1:length(ResultList)
%     TempData = load([ResultDir ResultList(i).name],'vx','vy');
%     [~,LegnendName{i},~] = fileparts(ResultList(i).name);
%         
%     [Im2XLoc Im2YLoc] = meshgrid(1:Width2,1:Height2);
%     CorrespondXLoc21 = Im2XLoc + TempData.vx;
%     CorrespondYLoc21 = Im2YLoc + TempData.vy;
%     Mask2 = CorrespondXLoc21>=1 & CorrespondXLoc21<=Width1 & CorrespondYLoc21>=1 & CorrespondYLoc21<=Height1;
%     CorrespondXLoc21=min(max(CorrespondXLoc21,1),Width1);
%     CorrespondYLoc21=min(max(CorrespondYLoc21,1),Height1);
%     
%     CorrespondLoc21 = ones(Height2,Width2,3);
%     CorrespondLoc21(:,:,1) = CorrespondXLoc21;
%     CorrespondLoc21(:,:,2) = CorrespondYLoc21;
%     
%     CorrespondLoc12 = TMatrix * reshape(CorrespondLoc21,[NumPixel2, 3])';
%     CorrespondXLoc12 = reshape(CorrespondLoc12(1,:),[Height2,Width2]);
%     CorrespondYLoc12 = reshape(CorrespondLoc12(2,:),[Height2,Width2]);
%     CorrespondWLoc12 = reshape(CorrespondLoc12(3,:),[Height2,Width2]);
%     CorrespondXLoc12 = CorrespondXLoc12 ./ CorrespondWLoc12;
%     CorrespondYLoc12 = CorrespondYLoc12 ./ CorrespondWLoc12;
%     Mask = CorrespondXLoc12>=1 & CorrespondXLoc12<=Width2 & CorrespondYLoc12>=1 & CorrespondYLoc12<=Height2;
%     
% %     DistanceMap{i} = sqrt((abs(CorrespondXLoc12 - Im2XLoc) / Width2).^2 + (abs(CorrespondYLoc12 - Im2YLoc) / Height2).^2);
%     DistanceMap{i} = sqrt((abs(CorrespondXLoc12 - Im2XLoc)).^2 + (abs(CorrespondYLoc12 - Im2YLoc)).^2);
% end
% %% plot
% NumInBoundary = sum(Mask2(:));
% CorrectRatio = zeros(length(DistanceMap),length(DistanceRatioRange));
% PlotType = {'-r+','-go','-b*','-cx','-mh'};
% figure;
% for i = 1:length(DistanceMap)
%     for j = 1:length(DistanceRatioRange)
%         TempMask = DistanceMap{i} < DistanceRatioRange(j) & Mask2 & Mask;
%         CorrectRatio(i,j) = sum(TempMask(:)) / NumInBoundary;
%     end
%     plot(DistanceRatioRange,CorrectRatio(i,:),PlotType{i});
%     hold on
% end
% legend(LegnendName, 'location','Best');
% title([class_name ' (' file_name1(2:end) ' to ' file_name2(2:end) ')']);