function [ vx,vy,match_cost ] = DSPMatch_SDSP( sift1, sift2, init_flow )
%% DSPMatch: Deformable spatial pyramid matching
% Match features (e.g., SIFTs) between two images
%
% Input:
% sift1: features from image1: h1 x w1 x n matrix
% (h1: image1's height, w1: image1' width, n: feature dimension)
% sift1: features from image2: h2 x w2 x n matrix
% (h2: image2's height, w2: image2' width, n: feature dimension)
%
% Output:
% vx (h1 x w1 matrix): x-translation of pixels in image1 to their corresponding pixels in image2 (x2 = x1 + vx)
% vy (h1 x w1 matrix): y-translation of pixels in image1 to their corresponding pixels in image2 (y2 = y1 + vy)
% match_cost (h1 x w1 matrix) = |sift1(y1,x1) - sift2(y2,x2)|
%
% Citation:
% Deformable Spatial Pyramid Matching for Fast Dense
% Correspondences, Jaechul Kim, Ce Liu, Fei Sha, and Kristen Grauman.
% CVPR 2013
%
% Author:
% Jaechul Kim, jaechul@cs.utexas.edu
 
 
[h1, w1, ~] = size(sift1);
[h2, w2, ~] = size(sift2);

%% Grid-layer
% parameters
n_init_target_feat = 2500;
init_grid_size = floor(sqrt(h1*w1/n_init_target_feat) + 0.5);
params.grid_size = init_grid_size;
params.n_tree_level = 3;
params.truncate_const = 500;

%% Pixel-layer
init_flow = reshape(init_flow,w1*h1,2)';

in_disp = zeros(2, w1*h1, 'int32');
in_disp(1,:) = init_flow(2,:);  % vx
in_disp(2,:) = init_flow(1,:);   % vy

% pixel match: two-level coarse-to-fine search for speed-up
% pxm_params.truncate_const = params.truncate_const;
% pxm_params.search_grid_size = 4;
% sx = 20;
% sy = 20;
% pxm_params.search_radius = floor([sx, sy]);
% pxm_params.deform_coeff = 2.5;
% out_disp = PixelMatchMex(sift1, sift2, in_disp, pxm_params);
pxm_params.truncate_const = params.truncate_const;
pxm_params.search_grid_size = 16;
sx = 40;
sy = 40;
pxm_params.search_radius = floor([sx, sy]);
pxm_params.deform_coeff = 2.5;
out_disp = PixelMatchMex(sift1, sift2, in_disp, pxm_params);

pxm_params.search_grid_size = 4;
sx = 20;
sy = 20;
pxm_params.search_radius = floor([sx, sy]);
pxm_params.deform_coeff = 2.5;
out_disp = PixelMatchMex(sift1, sift2, out_disp, pxm_params);

pxm_params.search_grid_size = 1;
sx = 4;
sy = 4;
pxm_params.search_radius = floor([sx, sy]);
pxm_params.deform_coeff = 2.5;
[out_disp, match_cost] = PixelMatchMex(sift1, sift2, out_disp, pxm_params);

% output
vx = reshape(out_disp(1,:), [h1, w1]);
vy = reshape(out_disp(2,:), [h1, w1]);
vx = double(vx);
vy = double(vy);
match_cost = reshape(match_cost, [h1, w1]);

end

