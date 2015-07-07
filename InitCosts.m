function [ cost_map ] = InitCosts( init_labels, graph, descps1, descps2, descps_ratios,descps_NN1s_dist, paras )
%INITCOSTS Summary of this function goes here
%   Detailed explanation goes here

% alpha=1;    % weighted value
% gamma1=1;   % <= 1
% gamma2=100;   % >= 1
% lambda=0.0000000001;    % avoid to be divided by zero
% descps_type={'SIFT','GB','DAISY','LIOP','GSS'};

im1_h=graph.im_h;
im1_w=graph.im_w;

% im2_h=size(descps2.im,1);
% im2_w=size(descps2.im,2);

cost_map=ones(im1_h,im1_w)*(-1);

for n=1:graph.node_num
    cur_node=graph.nodes(n);
    if numel(cur_node.center)==0
        continue;
    end
    cur_label=init_labels(n,:);
    
    labelVol=CostVolume(cur_node, cur_label, descps1, descps2, descps_ratios,descps_NN1s_dist,paras);
    
    % Smooth cost volume with guided filter
    subim_top=cur_node.subimage_range(1,1);
    subim_down=cur_node.subimage_range(2,1);
    subim_left=cur_node.subimage_range(1,2);
    subim_right=cur_node.subimage_range(2,2);

    subim=descps1.im(subim_top:subim_down,subim_left:subim_right,:);
    subim=double(subim)/255;
    ori_cost=labelVol(:,:);
    new_cost=guidedfilter_color(subim,double(ori_cost),5,0.0001);
    labelVol(:,:)=new_cost;
    
    for p=1:size(cur_node.pixels,1)
        pos=cur_node.pixels(p,:);
        subim_pos=pos-[subim_top subim_left]+1;
        cost_map(pos(1),pos(2))=labelVol(subim_pos(1), subim_pos(2));
    end
end

end
