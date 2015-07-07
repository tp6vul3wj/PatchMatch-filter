function [ gb ] = getDenseGBfeatures( I, gridSize,para )
%GETDENSEGBFEATURES Summary of this function goes here
%   Detailed explanation goes here

if (size(I,3)>1),  % convert the image to grayscale
  I = mean(I,3);
end

% compute channels using oriented edge energy
fbr = compute_channels_oe_nms(I);

rs_all =      [0 4 8 16 20 24 32 35 40];
nthetas_all = [1 8 8 10 12 12 16 16 20];

rs = rs_all(1:para);
nthetas = nthetas_all(1:para);

% alpha is the rate of increase for blur
alpha = 0.5;

% beta is the base blur amount
beta = 1;

[gb pos] = get_dense_descriptors( I,gridSize,fbr,alpha,beta,rs,nthetas );

end

