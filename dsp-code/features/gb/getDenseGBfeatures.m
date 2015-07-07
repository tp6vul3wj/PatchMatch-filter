function [ gb ] = getDenseGBfeatures( I, gridSize )
%GETDENSEGBFEATURES Summary of this function goes here
%   Detailed explanation goes here

if (size(I,3)>1),  % convert the image to grayscale
  I = mean(I,3);
end

% compute channels using oriented edge energy
fbr = compute_channels_oe_nms(I);

% rs are the radii for sample points
% rs =      [0 4 8 16 32 50];
rs =      [0 4 8 16 20 25];

% nthetas are the number of samples at each radii
% nthetas = [1 8 8 10 12 12];
nthetas = [1 8 8 10 12 16];

% alpha is the rate of increase for blur
alpha = 0.5;

% beta is the base blur amount
beta = 1;

[gb pos] = get_dense_descriptors( I,gridSize,fbr,alpha,beta,rs,nthetas );

end

