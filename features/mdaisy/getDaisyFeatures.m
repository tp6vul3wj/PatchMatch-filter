function [ daisy ] = getDaisyFeatures( im,para )
%GETDAISYFEATURES Summary of this function goes here
%   Detailed explanation goes here

dzy = compute_daisy(im,para);
feat = reshape(dzy.descs', dzy.DS, dzy.w, dzy.h);
daisy = permute(feat, [3, 2, 1]);

end

