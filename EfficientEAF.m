function [ updated_labels updated_costs ] = EfficientEAF( ori_labels, ori_costs,cand_labels,cur_node,descps1,descps2,descps_ratios,descps_NN1s_dist,paras)
%EFFICIENTEAF Summary of this function goes here
%   Detailed explanation goes here
%   [ref.] C. Rhemann, A. Hosni, M. Bleyer, C. Rother, and M. Gelautz. Fast
%   cost-volume filtering for visual correspondence and beyond. In CVPR, 2011.

subim_top=cur_node.subimage_range(1,1);
subim_down=cur_node.subimage_range(2,1);
subim_left=cur_node.subimage_range(1,2);
subim_right=cur_node.subimage_range(2,2);

% im2_h=size(descps2.im,1);
% im2_w=size(descps2.im,2);

subim_h=subim_down-subim_top+1;
subim_w=subim_right-subim_left+1;
label_num=size(cand_labels,1);

labelVol=ones(subim_h,subim_w,label_num);

% Create initial cost volume (Raw matching cost)
for l=1:label_num
    cur_label=cand_labels(l,:);
    labelVol(:,:,l)=CostVolume(cur_node, cur_label, descps1, descps2, descps_ratios,descps_NN1s_dist,paras);
end

% Smooth cost volume with guided filter


subim=descps1.im(subim_top:subim_down,subim_left:subim_right,:);
subim=double(subim)/255;
for l=1:label_num
    ori_cost=labelVol(:,:,l);
    new_cost=guidedfilter_color(subim,double(ori_cost),5,0.0001);
    labelVol(:,:,l)=new_cost;
end



% Winner take all label selection
[min_cost,selected_labels_ind] = min(labelVol,[],3);
selected_labels=cand_labels(selected_labels_ind,:);
selected_labels=reshape(selected_labels,subim_h,subim_w,3);

bb_top=cur_node.bounding_box(1,1);
bb_down=cur_node.bounding_box(2,1);
bb_left=cur_node.bounding_box(1,2);
bb_right=cur_node.bounding_box(2,2);

% bb_h=bb_down-bb_top+1;
% bb_w=bb_right-bb_left+1;

top_indx=1+bb_top-subim_top;
left_indx=1+bb_left-subim_left;

% Update label at every pixels in bounding box
updated_labels=ori_labels;
updated_costs=ori_costs;

for jj=bb_top:bb_down
    for ii=bb_left:bb_right
        if min_cost(top_indx+jj-bb_top,left_indx+ii-bb_left) < updated_costs(jj,ii)
            updated_labels(jj,ii,:)=selected_labels(top_indx+jj-bb_top,left_indx+ii-bb_left,:);
            updated_costs(jj,ii)=min_cost(top_indx+jj-bb_top,left_indx+ii-bb_left);
        end
    end
end
% updated_labels(bb_top:bb_down,bb_left:bb_right,:)=select_labels(top_indx:top_indx+bb_h-1,left_indx:left_indx+bb_w-1,:);

end
