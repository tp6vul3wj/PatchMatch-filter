function [sample_points sample_points_r sample_points_sigma_level] ...
    = compute_sample_points(rs,nthetas);

% function [sample_points sample_points_r
% sample_points_sigma_level]  = compute_sample_points(rs,nthetas);
%
% compute the locations of the GB sample point relative to the
% center of the descriptor



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





    count = 0;
    for i=1:length(rs),
      thetas = ( [1:nthetas(i)]/nthetas(i) ) *2*pi;
      sample_points(count+1:count+nthetas(i),1) = rs(i)*cos(thetas)';
      sample_points(count+1:count+nthetas(i),2) = rs(i)*sin(thetas)';
      sample_points_sigma_level(count+1:count+nthetas(i)) = i;
      count = count + nthetas(i);
    end
    sample_points_r = rs(sample_points_sigma_level);
    
    
    sample_points_1 = sample_points(:,1);
    sample_points_2 = sample_points(:,2);
