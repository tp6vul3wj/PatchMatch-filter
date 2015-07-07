clc;
close all;
clear all;

class_name = 'wall';
file_name1 = '_2';
file_name2 = '_1';

input_dir = ['datasets\VGG\' class_name '\'];
% output_dir = ['Results\VGG\' class_name '_test\' file_name2(2:end) 'to' file_name1(2:end) '\'];
output_dir = 'Results\VGG\';

% I1 = im2double(imread([input_dir class_name file_name1 '.png']));
% I2 = im2double(imread([input_dir class_name file_name2 '.png']));
I1 = im2double(imread([input_dir 'img' file_name1(2:end) '.ppm']));
I2 = im2double(imread([input_dir 'img' file_name2(2:end) '.ppm']));

%% the ground truth
TMatrix = load([input_dir 'H' file_name2(2:end) 'to' file_name1(2:end) 'p']) ;
% inv_TMatrix = inv(TMatrix);

[Height1,Width1,~] = size(I1);
[Height2,Width2,~] = size(I2);
NumPixel1 = Height1 * Width1;

Im1Loc = ones(Height1,Width1,3);
[Im1Loc(:,:,1),Im1Loc(:,:,2)] = meshgrid(1:Width1,1:Height1); % [XX,YY] = [Col, Row]
XLoc = Im1Loc(:,:,1);
YLoc = Im1Loc(:,:,2);
CorrespondLoc = TMatrix \ reshape(Im1Loc,[NumPixel1, 3])';
CorrespondXLoc = reshape(CorrespondLoc(1,:),[Height1,Width1]);
CorrespondYLoc = reshape(CorrespondLoc(2,:),[Height1,Width1]);
CorrespondWLoc = reshape(CorrespondLoc(3,:),[Height1,Width1]);
CorrespondXLoc = CorrespondXLoc ./ CorrespondWLoc;
CorrespondYLoc = CorrespondYLoc ./ CorrespondWLoc;

Mask = CorrespondXLoc >= 1 & CorrespondXLoc <= Width2 & CorrespondYLoc >= 1 & CorrespondYLoc <= Height2;
CorrespondXLoc = min(max(CorrespondXLoc,1),Width2);
CorrespondYLoc = min(max(CorrespondYLoc,1),Height2);


%% Preprocessing
if size(I1,3)<3
    new_im=uint8(zeros(size(I1,1),size(I1,2),3));
    new_im(:,:,1)=I1;
    new_im(:,:,2)=I1;
    new_im(:,:,3)=I1;
    I1=new_im;
end
if size(I2,3)<3
    new_im=uint8(zeros(size(I2,1),size(I2,2),3));
    new_im(:,:,1)=I2;
    new_im(:,:,2)=I2;
    new_im(:,:,3)=I2;
    I2=new_im;
end

% Extract features
Descriptors1 = ExtractAllDescps(I1);
Descriptors2 = ExtractAllDescps(I2);

[ratios NN1s NN1s_dist]=DescriptorsNN(Descriptors1,Descriptors2);

%% Calculate data cost for each descriptors
% parameters setting
alpha=0.7;    % weighted value
gamma1=1;   % <= 1
gamma2=3;   % >= 1
lambda=0.0000000001;    % avoid to be divided by zero
descs_type={'SIFT','GB','DAISY','LIOP'};
feat_num = size(descs_type,2);

DescriptorSelect = zeros(Height1,Width1);
for xx = 1:Width1
    for yy = 1:Height1        
        min_cost = 1000;
        CorrespondLoc = round([CorrespondYLoc(yy) CorrespondXLoc(xx)]);
        for dd = 1:feat_num
            desc_type = descs_type{dd};
            
            % Truncated ratio of dist(p,NN1)/dist(p,NN2) for current descriptor
            tmp = ratios.(desc_type)(yy,xx);
            c_desc = min(tmp, gamma1);
            
            % Truncated ratio of dist(p,p')/dist(p,NN1) for current displacement
            desc1 = double(Descriptors1.(desc_type)(yy,xx,:));
            desc2 = double(Descriptors2.(desc_type)(CorrespondLoc(1),CorrespondLoc(2),:));
            diff = desc2 - desc1;
            dist = sqrt(sum(diff.^2,3));
            p_NN1s_dist = NN1s_dist.(desc_type)(yy,xx);
            tmp_ratio = max(dist,lambda)./max(p_NN1s_dist,lambda);
            c_disp = min(tmp_ratio, gamma2);
            
            cur_cost = c_desc+alpha*c_disp;
            
            if cur_cost < min_cost
                min_cost = cur_cost;
                DescriptorSelect(yy,xx) = dd;
            end
        end
    end
end

DescriptorSelect = DescriptorSelect .* Mask;

desc_gray=mat2gray(DescriptorSelect,[0,feat_num]);
desc_X = gray2ind(desc_gray, 256);
desc_im = ind2rgb(desc_X, jet(256));
figure, imshow(desc_im);

imwrite(desc_im,[output_dir class_name '_' file_name1(2:end) 'to' file_name2(2:end) '_GTdesc.png'],'png');

