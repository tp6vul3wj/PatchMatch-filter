function [ out_node_costs ] = DSPCalculateCost( in_node,label_space,descps1,descps2,descs_ratios,descs_NN1s_dist,paras )
%DSPCALCULATECOST Summary of this function goes here
%   Detailed explanation goes here

% parameters setting
if isfield(paras,'alpha')
    alpha=paras.alpha;
else
    alpha=1;
end
if isfield(paras,'gamma1')
    gamma1=paras.gamma1;
else
    gamma1=1;
end
if isfield(paras,'gamma2')
    gamma2=paras.gamma2;
else
    gamma2=100;
end
if isfield(paras,'lambda')
    lambda=paras.lambda;
else
    lambda=0.0000000001;
end
if isfield(paras,'descps_type')
    descps_type=paras.descps_type;
else
    descps_type={'SIFT','GB','DAISY','LIOP'};
end

feat_num = size(descps_type,2);

im1_h=size(descps1.im,1);
im1_w=size(descps1.im,2);
im1_pixel_num = im1_h*im1_w;
im2_h=size(descps2.im,1);
im2_w=size(descps2.im,2);
im2_pixel_num = im2_h*im2_w;

pixels_num = size(in_node.pixels,1);
pixels_pos = in_node.pixels;
pixels_indx = pixels_pos(:,1) + (pixels_pos(:,2)-1)*size(descps1.im,1);
mask1 = false(im1_h,im1_w);
mask1(pixels_indx) = true;
mask1_1D = reshape(mask1,im1_pixel_num,[]);

for d=1:feat_num
    descp_type = descps_type{d};
    
    % Truncated ratio of dist(p,NN1)/dist(p,NN2) for current descriptor
    tmp = descs_ratios.(descp_type) .* mask1;
    avg_ratios = sum(tmp(:)) / pixels_num;
    c_desc.(descp_type) = min(avg_ratios, gamma1);

    % Truncated ratio of dist(p,p')/dist(p,NN1) for current displacement
    tmp = descs_NN1s_dist.(descp_type) .* mask1;
    avg_NN1s_dist.(descp_type) = sum(tmp(:)) / pixels_num;
    
    % descp1_tmp = reshape(descps1.(descp_type),im1_pixel_num,[]);
    tmp = double(descps1.(descp_type)(mask1_1D,:));
    avg_desc1.(descp_type) = sum(tmp,1) / pixels_num;
end

label_num = size(label_space,2);
sub_label_num = label_num/feat_num;
out_node_costs = zeros(label_num,1);
for l = 1:sub_label_num
    cur_label = label_space(:,l);
    
    u = cur_label(1);
    v = cur_label(2);
    
    p_primes_pos_tmp(:,1) = pixels_pos(:,1) + u;
    p_primes_pos_tmp(:,2) = pixels_pos(:,2) + v;
    p_primes_mask = p_primes_pos_tmp(:,1) >= 1 & p_primes_pos_tmp(:,1) <= im2_h & p_primes_pos_tmp(:,2) >= 1 & p_primes_pos_tmp(:,2) <= im2_w;
    p_primes_pos = p_primes_pos_tmp(p_primes_mask,:);
    p_primes_indx = p_primes_pos(:,1) + (p_primes_pos(:,2)-1)*size(descps2.im,1);
    p_primes_num = size(p_primes_pos,1);
    mask2 = false(im2_h,im2_w);
    mask2(p_primes_indx) = true;
    mask2_1D = reshape(mask2,im2_pixel_num,[]);

    if p_primes_num <= pixels_num/2
        for d = 1:feat_num
            l_indx = sub_label_num*(d-1)+l;
            out_node_costs(l_indx) = 10;
        end
        continue;
    end

    for d = 1:feat_num
        descp_type = descps_type{d};
		
        tmp = double(descps2.(descp_type)(mask2_1D,:));
        avg_desc2 = sum(tmp,1) / p_primes_num;

        diff=avg_desc1.(descp_type)-avg_desc2;
        dist=sqrt(sum(diff.^2,2));

        tmp_ratio=max(dist,lambda)./max(avg_NN1s_dist.(descp_type),lambda);
        c_disp=min(tmp_ratio, gamma2);

        l_indx = sub_label_num*(d-1)+l;
        out_node_costs(l_indx) = c_desc.(descp_type)+alpha*c_disp;
    end
end

% out_cost = 0;
end

