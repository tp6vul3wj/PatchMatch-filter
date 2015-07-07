function [ segments, graph ] = SegImgSLIC( image, superpixel_num, extend_pixels )
%SEGIMGSLIC Summary of this function goes here
%   Detailed explanation goes here

disp('----------------------------')
% Parameters setting
image = im2single(image);
[height,width,~] = size(image);
image_size=height*width;
regionSize = sqrt(image_size/superpixel_num);
if regionSize < 21
    regionSize = 21;
end
regularizer = 0.5;

% SLIC superpixels
segments = zeros(size(image, 1), size(image, 2));
segments(:,:) = vl_slic(image, regionSize, regularizer, 'verbose');
segments=segments+1;    % Let the number of labels start from 1

graph.im_h=height;
graph.im_w=width;
graph.node_num=max(segments(:));
for n=1:graph.node_num
    [ny,nx]=find(segments==n);
    max_x=max(nx); min_x=min(nx);
    max_y=max(ny); min_y=min(ny);
    
    nodes(n).pixels=[ny nx];
    nodes(n).center=[round((min_y+max_y)/2) round((min_x+max_x)/2)];
    nodes(n).bounding_box=[min_y min_x; max_y max_x];
    
    if min_y-extend_pixels < 1
        min_y=1;
    else
        min_y=min_y-extend_pixels;
    end
    if min_x-extend_pixels < 1
        min_x=1;
    else
        min_x=min_x-extend_pixels;
    end
    if max_y+extend_pixels > height
        max_y=height;
    else
        max_y=max_y+extend_pixels;
    end
    if max_x+extend_pixels > width
        max_x=width;
    else
        max_x=max_x+extend_pixels;
    end
    nodes(n).subimage_range=[min_y min_x; max_y max_x];
    
    nodes(n).neighbors=[];
    neighbor_indx=[-1 0; 1 0; 0 -1; 0 1];
    for i=1:size(neighbor_indx,1)
        y=ny+neighbor_indx(i,1);
        x=nx+neighbor_indx(i,2);
        out_indx=unique(find((y<=0)|(y>height)|(x<=0)|(x>width)));
        y(out_indx)=[]; x(out_indx)=[];
        yx=sub2ind(size(segments),y,x);
        neighbors=unique(segments(yx));
        nodes(n).neighbors=vertcat(nodes(n).neighbors,neighbors);
    end
    nodes(n).neighbors=unique(nodes(n).neighbors);
    not_neighbor=find(nodes(n).neighbors==n);
    nodes(n).neighbors(not_neighbor)=[];
end
graph.nodes=nodes;

% For display: overlay segmentation
[sx,sy]=vl_grad(double(segments(:,:)), 'type', 'forward');
s = find(sx | sy);
imp = image;
imp([s s+numel(image(:,:,1)) s+2*numel(image(:,:,1))]) = 0;
%figure; imshow(imp);

% imwrite(imp,'SLIC.jpg','jpg');

end

