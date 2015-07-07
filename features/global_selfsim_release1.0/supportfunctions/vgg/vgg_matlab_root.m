%VGG_MATLAB_ROOT  Returns string with vgg_matlab root path.

function s = vgg_matlab_root
s = fileparts(which(mfilename));
return
