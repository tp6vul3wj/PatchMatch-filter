function [seg_labels] = InitLabels( graph1, label_range )
%INITLABEL Summary of this function goes here
%   Detailed explanation goes here

seg_num=graph1.node_num;
seg_labels=zeros(seg_num,3);

label_num=size(label_range');

for s=1:seg_num
    if numel(graph1.nodes(s).center)==0
        continue;
    end
    center_pos=graph1.nodes(s).center;
    label=zeros(label_num);
    for l_i=1:2
        rand_loc=round((label_range(l_i)-1)*rand)+1;
        label(l_i)=rand_loc-center_pos(l_i);
    end
    label(3)=round((label_range(3)-1)*rand)+1;
%     label(3)=2;
    seg_labels(s,:)=label; % label=[dy dx feat_type];
end

end

