function [outim scaleby]=td_imrescalemaxsize(inim, maxSizeY, maxSizeX)
% scale the image to be at most maxsizeY x maxsizeX
%   - if the image is smaller: don't do anything
%   - if only one maxsize parameter is given, the other is the same

if nargin<3
    maxSizeX=maxSizeY;
end

[H W Z]=size(inim);
outim=inim;

scaleby=1;
if H>maxSizeY || W>maxSizeX
    scaleby=min(maxSizeX/W, maxSizeY/H);
    outim=imresize(inim,scaleby,'bilinear');
end





