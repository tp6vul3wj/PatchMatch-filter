function [ candidates ] = GetCandidateLabels( nodes, label_map, node_indx )
%GETCANDIDATELABELS Summary of this function goes here
%   Detailed explanation goes here

%% Neighborhood Propagation
neighbors=nodes(node_indx).neighbors;
candidates=zeros(size(neighbors,1),3);
for i=1:size(neighbors,1)
    neighbor_node=nodes(neighbors(i));
    cand_pixel_indx=round((size(neighbor_node.pixels,1)-1)*rand)+1;
    cand_pos=neighbor_node.pixels(cand_pixel_indx,:);
    candidates(i,:)=label_map(cand_pos(1), cand_pos(2), :);
end


%% Random Search


end

