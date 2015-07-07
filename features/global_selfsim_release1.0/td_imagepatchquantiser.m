% extract all patches from an image
% inputs image:     an image of size H*W
%        patchsize  a scalar
%        codebook: a codebook of appropriate size (L x D)
% outputs: 
%   a texton map of the image according to the given codebook
%
%   the image is zero padded for patch extraction at the boundary
% 
%  D = dimensionality of the patches
%  D = (2*patchsize+1)^2 * C
%  C = number of color layers in the image
%  L =  number of words in the vocabulary
%  output is a HxW matrix with values between 0 and L-1
  
