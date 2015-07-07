function [ LIOP ] = getDenseLIOP( im )
%GETDENSELIOP Summary of this function goes here
%   Detailed explanation goes here
if size(im,3)>1
    im=rgb2gray(im);
end
im=imfilter(im,fspecial('gaussian',7,1.2),'same','replicate');
im=single(im);

height=size(im,1);
width=size(im,2);
feat_size=144;  % NumNeighbours=4; NumSpatialBins=6; feat_size=(N!*B);
LIOP=zeros(height,width,feat_size);

border=25;  % PatchResolution
border_twice=2*border;
im_border=fill_border(im, border);
im_border=single(im_border);

tic;
for hh=1:height
    for ww=1:width
        patch=im_border(hh:hh+border_twice,ww:ww+border_twice);
        desc=vl_liop(patch);
        LIOP(hh,ww,:)=desc;
    end
end
toc;

% figure;imshow(uint8(im));
end

