% extract all patches from an image
% inputs image:     an image of size H*W
%        patchsize  a scalar
% outputs: all patches of size (2*patchsize+1)^2 *C 
%   the output array is of dimension  (2*patchsize+1)^2 *C  * N
%   where N=H*W is the total number of patches, C is the number of color layers
% 
%   the image is zero padded for patch extraction at the boundary
