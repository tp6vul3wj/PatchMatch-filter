function [ labels costs ] = PatchMatchFilter( graph1, graph2, descps1, descps2, feat_num, iter, paras )
%PATCHMATCHFILTER Summary of this function goes here
%   Detailed explanation goes here

% Initial descriptor ratio and NN1 for each pixel in image1 that correspond to image2
[ratios NN1s NN1s_dist]=DescriptorsNN(descps1,descps2, paras.K);
% load('SIFT_01_ab_descps_ratios_ann_100.mat'); % ratios
% load('SIFT_01_ab_descps_NN1s_ann_100.mat');   % NN1s
% load('SIFT_01_ab_descps_NN1s_dist_ann_100.mat');  % NN1s_dist

im2_h=graph2.im_h;
im2_w=graph2.im_w;

% Initial label assignment to each node
node_init_labels=InitLabels(graph1,[im2_h, im2_w, feat_num]);
cur_labels=zeros(graph1.im_h,graph1.im_w,3); % label(y,x)=[dy dx feat_type];
for n=1:graph1.node_num
    for p=1:size(graph1.nodes(n).pixels,1)
        pos=graph1.nodes(n).pixels(p,:);
        cur_labels(pos(1),pos(2),:)=node_init_labels(n,:);
    end
end
% DrawDescSelect(cur_labels,0,paras.alpha);
% clear flow;
% flow(:,:,1)=cur_labels(:,:,2);
% flow(:,:,2)=cur_labels(:,:,1);
% figure, imshow(flowToColor(flow));

cur_costs=InitCosts(node_init_labels,graph1,descps1,descps2,ratios,NN1s_dist,paras);
% keyboard;

% Process each segment in scan order iteratively
for i=1:iter
    fprintf(1,'iter: %d;\n',i);
    tic;
    for n=1:graph1.node_num
        cur_node=graph1.nodes(n);
        if numel(cur_node.center)==0
            continue;
        end
        
        % Neighborhood Propagation
        neighbors=cur_node.neighbors;
        candidates=zeros(size(neighbors,1),3);
        for k=1:size(neighbors,1)
            neighbor_node=graph1.nodes(neighbors(k));
            cand_pixel_indx=round((size(neighbor_node.pixels,1)-1)*rand)+1;
            cand_pos=neighbor_node.pixels(cand_pixel_indx,:);
            candidates(k,:)=cur_labels(cand_pos(1), cand_pos(2), :);
        end
        [cur_labels cur_costs]=EfficientEAF(cur_labels,cur_costs,candidates,cur_node,descps1,descps2,ratios,NN1s_dist,paras);
        % keyboard;

        % Random Search
        pixel_num=size(cur_node.pixels,1);
        ref_pixel_indx=round((pixel_num-1)*rand)+1;
        ref_pixel=cur_node.pixels(ref_pixel_indx,:);
        ref_label=cur_labels(ref_pixel(1),ref_pixel(2),:);
        
        searchHalfWin=max(im2_h,im2_w);
%         searchHalfWin=9;
        rand_iters=floor(log2(searchHalfWin));
        cand_num=rand_iters+1;
%         cand_num=rand_iters*4+1;
        candidates=zeros(cand_num,3);
        candidates(1,:)=ref_label;
        
        seg_center=cur_node.center;
        rand_alpha=1;
        for k=1:rand_iters
%         for k=1:4:rand_iters*4
            w_alpha_k=round(searchHalfWin*rand_alpha);
            
            ymin=max(1,seg_center(1)+ref_label(1)-w_alpha_k);
            ymax=min(im2_h,seg_center(1)+ref_label(1)+w_alpha_k);
            xmin=max(1,seg_center(2)+ref_label(2)-w_alpha_k);
            xmax=min(im2_w,seg_center(2)+ref_label(2)+w_alpha_k);
            
            rand_y=round(rand*(ymax-ymin)) + ymin;
            rand_x=round(rand*(xmax-xmin)) + xmin;
%             rand_d=ref_label(3);
            rand_d=round((feat_num-1)*rand)+1;
            candidates(k+1,:)=[rand_y-seg_center(1) rand_x-seg_center(2) rand_d];
%             candidates(k+1,:)=[rand_y-seg_center(1) rand_x-seg_center(2) 1];
%             candidates(k+2,:)=[rand_y-seg_center(1) rand_x-seg_center(2) 2];
%             candidates(k+3,:)=[rand_y-seg_center(1) rand_x-seg_center(2) 3];
%             candidates(k+4,:)=[rand_y-seg_center(1) rand_x-seg_center(2) 4];
            
            rand_alpha=rand_alpha*0.5;
        end
        [cur_labels cur_costs]=EfficientEAF(cur_labels,cur_costs,candidates,cur_node,descps1,descps2,ratios,NN1s_dist,paras);

    end
    toc;
%     desc_gray=mat2gray(cur_labels(:,:,3),[1,feat_num]);
%     desc_X = gray2ind(desc_gray, 256);
%     desc_im = ind2rgb(desc_X, jet(256));
%     figure, imshow(desc_im);
%     imwrite(desc_im,['Results\alpha_0.7_gamma1_1_gamma2_3\test\GB_04_a_desc_' num2str(i) '.png'],'png');
%     DrawDescSelect(cur_labels,i,paras.alpha);
%     clear flow;
%     flow(:,:,1)=cur_labels(:,:,2);
%     flow(:,:,2)=cur_labels(:,:,1);
%     figure, imshow(flowToColor(flow));
end

% Output labeling results
labels=cur_labels;
costs=cur_costs;

end