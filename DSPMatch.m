function [ label_map ] = DSPMatch( descps1, descps2, paras )
%DSPMATCH Summary of this function goes here
%   Detailed explanation goes here
%   By graph cut

if isfield(paras,'descps_type')
    descs_type=paras.descps_type;
else
    descs_type={'SIFT','GB','DAISY','LIOP'};
end

if isfield(paras,'dsp_alpha')
    alpha=paras.dsp_alpha;
else
    alpha = 0.1;  % 0.05
end

if isfield(paras,'dsp_gamma')
    gamma=paras.dsp_gamma;
else
    gamma = 0.25;   % 0.25
end

im2_h = size(descps2.im,1);
im2_w = size(descps2.im,2);
feat_num = size(descs_type,2);

% Resize large image
fprintf(1,'[S-DSP] Resize Image: ');
tic;
minification = 1;
magnification = 1;
while max(im2_h, im2_w) > 300
    minification = minification/2;
    magnification = magnification*2;
    im2_h = im2_h/2;
    im2_w = im2_w/2;
end

if minification ~= 1
    sub_descs1.im = imresize(imfilter(descps1.im,fspecial('gaussian',5,0.67),'same','replicate'),minification,'bicubic');
    sub_descs2.im = imresize(imfilter(descps2.im,fspecial('gaussian',5,0.67),'same','replicate'),minification,'bicubic');
    for d = 1:size(descs_type,2)
        descp_type = descs_type{d};
        sub_descs1.(descp_type) = imresize(imfilter(descps1.(descp_type),fspecial('gaussian',5,0.67),'same','replicate'),minification,'bicubic');
        sub_descs2.(descp_type) = imresize(imfilter(descps2.(descp_type),fspecial('gaussian',5,0.67),'same','replicate'),minification,'bicubic');
    end
else
    sub_descs1.im = descps1.im;
    sub_descs2.im = descps2.im;
    for d = 1:size(descs_type,2)
        descp_type = descs_type{d};
        sub_descs1.(descp_type) = descps1.(descp_type);
        sub_descs2.(descp_type) = descps2.(descp_type);
    end
end
toc;

im1_h = size(sub_descs1.im,1);
im1_w = size(sub_descs1.im,2);
im1_pixel_num=im1_h*im1_w;
im2_h = size(sub_descs2.im,1);
im2_w = size(sub_descs2.im,2);
im2_pixel_num=im2_h*im2_w;

pyr_num = 3;
pyr_graph = DSPBuildPyr(sub_descs1.im, pyr_num);

node_num = pyr_graph.node_num;

n_init_target_feat = 2500;
init_grid_size = max(floor(sqrt(im2_h*im2_w/n_init_target_feat) + 0.5),1);
sx = max(im1_w, im2_w);
sy = max(im1_h, im2_h);
sr = [ceil(sy/2), ceil(sx/2)];  % search radius

u_state = ceil((2*sr(1)+1)/init_grid_size);
v_state = ceil((2*sr(2)+1)/init_grid_size);
[u v d] = meshgrid(-sr(1):init_grid_size:sr(1), -sr(2):init_grid_size:sr(2), 1:feat_num);
u=reshape(u,1,[]);
v=reshape(v,1,[]);
d=reshape(d,1,[]);
label_space = [u;v;d];
label_num = size(label_space,2);

K = 2;
[ratios NN1s NN1s_dist]=DescriptorsNN(sub_descs1,sub_descs2,K,descs_type);

for d = 1:size(descs_type,2)
    descp_type = descs_type{d};
    sub_descs1.(descp_type) = reshape(sub_descs1.(descp_type),im1_pixel_num,[]);
    sub_descs2.(descp_type) = reshape(sub_descs2.(descp_type),im2_pixel_num,[]);
end

% DataCost
node_costs = zeros(u_state*v_state*feat_num,node_num);
fprintf(1,'Calculate node cost for each label\n');
t0 = clock;
for n = 1:node_num
    fprintf(1,'****** node %d: ', n);
    tic;
    cur_node = pyr_graph.nodes(n);
    node_costs(:,n) = DSPCalculateCost(cur_node,label_space,sub_descs1,sub_descs2,ratios,NN1s_dist,paras);
    toc;
end
fprintf(1,'**** total: %f\n', etime(clock,t0));
% load('node_costs.mat');
% node_costs = node_costs(2:end, :);

% SmoothnessCost
% Sc = ones(label_num)-eye(label_num);
norm_value = sqrt(sum((2*sr).^2));
Sc = zeros(label_num);
for l = 1:label_num
    u_tmp = (label_space(1,l)-label_space(1,:)).^2;
    v_tmp = (label_space(2,l)-label_space(2,:)).^2;
    uADDv = min(sqrt(u_tmp+v_tmp)/norm_value,gamma);
    Sc(l,:) = uADDv;
    Sc(:,l) = uADDv;
end

% SparseSmoothness
SparseSc = zeros(node_num);
for n = 1:node_num
    cur_node = pyr_graph.nodes(n);
    SparseSc(n,cur_node.neighbors)=1;
    SparseSc(cur_node.neighbors,n)=1;
end
SparseSc = sparse(SparseSc);

fprintf(1,'Graph Cuts: ');
tic;
[~,segclass] = min(node_costs,[],1);
segclass = segclass - 1;
[L, E ,Eafter] = GCMex(segclass, single(node_costs), SparseSc, single(alpha*Sc),0);
L = L + 1;
toc;

% Assign final label to each pixel
node_label = zeros(node_num, 3);    % [u, v, l]
for n = 1:node_num
    node_label(n,:) = label_space(:,L(n));
end
sub_label_map = zeros(im1_pixel_num,3);
for n = node_num:-1:1
    cur_node = pyr_graph.nodes(n);
    if cur_node.level ~= pyr_num
        break;
    end
    mask = cur_node.mask;
    sub_label_map(mask,1) = node_label(n,1);
    sub_label_map(mask,2) = node_label(n,2);
    sub_label_map(mask,3) = node_label(n,3);
end
sub_label_map = reshape(sub_label_map,im1_h,im1_w,3);

ori_im1_h = size(descps1.im,1);
ori_im1_w = size(descps1.im,2);
ori_im2_h = size(descps2.im,1);
ori_im2_w = size(descps2.im,2);
[sub_xx,sub_yy]=meshgrid(1:im1_w,1:im1_h);
sub_xx=round((sub_xx-1)*(im2_w-1)/(im1_w-1)+1-sub_xx);
sub_yy=round((sub_yy-1)*(im2_h-1)/(im1_h-1)+1-sub_yy);
[ori_xx,ori_yy]=meshgrid(1:ori_im1_w,1:ori_im1_h);
ori_xx=round((ori_xx-1)*(ori_im2_w-1)/(ori_im1_w-1)+1-ori_xx);
ori_yy=round((ori_yy-1)*(ori_im2_h-1)/(ori_im1_h-1)+1-ori_yy);

label_map = zeros(ori_im1_h,ori_im1_w,3);

label_map(:,:,1)=round(ori_yy+imresize(sub_label_map(:,:,1)-sub_yy,[ori_im1_h,ori_im1_w],'nearest')*magnification);
label_map(:,:,2)=round(ori_xx+imresize(sub_label_map(:,:,2)-sub_xx,[ori_im1_h,ori_im1_w],'nearest')*magnification);
label_map(:,:,3)=round(imresize(sub_label_map(:,:,3),[ori_im1_h,ori_im1_w],'nearest'));

% keyboard;
end