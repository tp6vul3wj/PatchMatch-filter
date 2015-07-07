function [ graph ] = DSPBuildPyr( im, pyr_num )
%DSPMATCH Summary of this function goes here
%   Detailed explanation goes here

cur_node_num = 0;
pre_node_num = 0;

cell_num = 1;
for i = 1:pyr_num
    [pyr_seg, pyr_graph]=SegImgSLIC(im, cell_num, 0);
    
    for n=1:pyr_graph.node_num
        pyr_graph.nodes(n).neighbors = pyr_graph.nodes(n).neighbors+cur_node_num;
        cur_pixels_indx = sub2ind(size(im), pyr_graph.nodes(n).pixels(:,1), pyr_graph.nodes(n).pixels(:,2));
        for m=pre_node_num-1:-1:0
            pre_pixels = graph.nodes(cur_node_num-m).pixels;
            pre_pixels_indx = sub2ind(size(im), pre_pixels(:,1), pre_pixels(:,2));
            intersection = intersect(cur_pixels_indx,pre_pixels_indx);
            if (numel(intersection) ~= 0)
                graph.nodes(cur_node_num-m).neighbors = [graph.nodes(cur_node_num-m).neighbors' cur_node_num+n]';
                pyr_graph.nodes(n).neighbors = [pyr_graph.nodes(n).neighbors' cur_node_num-m]';
            end
        end
        mask_tmp = false(size(im,1),size(im,2));
        mask_tmp(cur_pixels_indx) = true;
        pyr_graph.nodes(n).mask = mask_tmp;
        pyr_graph.nodes(n).level = i;
        graph.nodes(cur_node_num+n) = pyr_graph.nodes(n);
    end
    
    cur_node_num = cur_node_num + pyr_graph.node_num;
    pre_node_num = pyr_graph.node_num;
    cell_num = cell_num * 4;
end
graph.node_num = cur_node_num;
graph.im_h = size(im,1);
graph.im_w = size(im,2);
end

