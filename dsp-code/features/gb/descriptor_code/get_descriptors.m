function [descriptors,pos] = get_descriptors(fbr,ndescriptors,rrep,alpha,beta,rs,nthetas,M)

% function [descriptors,pos] = get_descriptors(fbr,ndescriptors,rrep,alpha,beta,rs,nthetas,M)
%

% Demo code for matching roughly based on the procedure
% described in:
%
% "Shape Matching and Object Recognition using Low Distortion Correspondence"
% A. C. Berg, T. L. Berg, J. Malik
% CVPR 2005
%
% code Copyright 2005 Alex Berg
%
% questions -> Alex Berg aberg@cs.berkeley.edu



if (exist('M')==1),
  [ii,jj] = find_interest_points( M.*max(fbr,[],3),ndescriptors,rrep); % get the center points for features
else
  [ii,jj] = find_interest_points( max(fbr,[],3),ndescriptors,rrep); % get the center points for features
end



pos = [ii(:), jj(:)];

[descriptors sample_points]  = compute_gb(fbr,ii,jj,alpha,beta,rs,nthetas);

descriptors = normalize_descriptors(descriptors,rs,nthetas);


