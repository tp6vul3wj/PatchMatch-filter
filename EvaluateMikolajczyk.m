% close all
clear all
clc

class_name = 'boat';
file_name1 = '_1';
file_name2 = '_2';

DatasetsDir = [pwd '\datasets\VGG\' class_name '\'];
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
NumPixel1 = Height1 * Width1;
[Height2,Width2,~] = size(I2);
Im1Loc = ones(Height1,Width1,3);
[Im1Loc(:,:,1),Im1Loc(:,:,2)] = meshgrid(1:Width1,1:Height1); % [XX,YY] = [Col, Row]
XLoc = Im1Loc(:,:,1);
YLoc = Im1Loc(:,:,2);
CorrespondLoc = TMatrix * reshape(Im1Loc,[NumPixel1, 3])';
CorrespondXLoc = reshape(CorrespondLoc(1,:),[Height1,Width1]);
CorrespondYLoc = reshape(CorrespondLoc(2,:),[Height1,Width1]);
CorrespondWLoc = reshape(CorrespondLoc(3,:),[Height1,Width1]);
CorrespondXLoc = CorrespondXLoc ./ CorrespondWLoc;
CorrespondYLoc = CorrespondYLoc ./ CorrespondWLoc;
Mask = CorrespondXLoc >= 1 & CorrespondXLoc <= Width2 & CorrespondYLoc >= 1 & CorrespondYLoc <= Height2;

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
%% plot
NumInBoundary = sum(Mask(:));
CorrectRatio = zeros(length(DistanceMap),length(DistanceRatioRange));
PlotType = {'-r+','-go','-b*','-cx','-mh', '-ys'};
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






