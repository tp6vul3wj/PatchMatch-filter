function [descriptors position] = getGBfeatures(I)

if (size(I,3)>1),  % convert the image to grayscale
  I = mean(I,3);
end

% compute channels using oriented edge energy
fbr = compute_channels_oe_nms(I);

% rs are the radii for sample points
rs =      [0 4 8 16 32 50];

% nthetas are the number of samples at each radii
nthetas = [1 8 8 10 12 12];

% alpha is the rate of increase for blur
alpha = 0.5;

% beta is the base blur amount
beta = 1;

% Number of descriptors to extract per image
ndescriptors = 300;

% repulsion radius for rejection sampling
rrep = 5;

% Actually extract Geometric Blur descriptors for each image
[descriptors, position] = get_descriptors(fbr,ndescriptors,rrep,alpha,beta,rs,nthetas);

%descriptors=[ descp(:,:,1) descp(:,:,2) descp(:,:,3) descp(:,:,4)]';