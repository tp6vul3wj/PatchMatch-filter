function [ matching ] = matchGBfeatures( feats1, feats2, dissimilarity, threshold_l, threshold_h )
%MATCHGBFEATURES Summary of this function goes here
%   Detailed explanation goes here
nfeats1 = size(feats1, 1);
nfeats2 = size(feats2, 1);

matching = zeros(nfeats1, 1);
for i = 1:nfeats1
    [value index] = min(dissimilarity(i, :));
    %fprintf(1, '%f\n', value);
    if value(1) > threshold_l && value(1) < threshold_h
        matching(i) = index(1);
    end
end
fprintf(1, '%d / %d\n', nnz(matching), nfeats1);
end

