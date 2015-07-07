function [ descriptors,pos ] = get_dense_descriptors( I,k,fbr,alpha,beta,rs,nthetas )
%GET_DENSE_DESCRIPTORS Summary of this function goes here
%   Detailed explanation goes here

[height, width, ~] = size(I);

nheight = floor(height/k);
nwidth = floor(width/k);

% jj = zeros(nheight*nwidth, 1);  % col
% ii = zeros(nheight*nwidth, 1);  % row
% for i = 1:nheight
%     for j = 1:nwidth
%         jj(nheight*(j-1)+i)=k*j;
%         ii(nheight*(j-1)+i)=k*i;
%     end
% end

[ii, jj] = meshgrid(1:nheight, 1:nwidth);

ii = reshape(ii', 1, [])*k;
jj = reshape(jj', 1, [])*k;

% if (exist('M')==1),
%   [ii,jj] = find_interest_points( M.*max(fbr,[],3),ndescriptors,rrep); % get the center points for features
% else
%   [ii,jj] = find_interest_points( max(fbr,[],3),ndescriptors,rrep); % get the center points for features
% end

pos = [ii(:), jj(:)];
[descriptors sample_points]  = compute_gb(fbr,ii,jj,alpha,beta,rs,nthetas);
descriptors = normalize_descriptors(descriptors,rs,nthetas);

descriptors=[ descriptors(:,:,1) descriptors(:,:,2) descriptors(:,:,3) descriptors(:,:,4)];
descriptors = reshape(descriptors, nheight, nwidth, []);
end

