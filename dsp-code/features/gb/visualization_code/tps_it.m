function output_points = tps_it(c,X,input_points)

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


 N = size(X,1);
 M = size(input_points,1);
 
 D = ones(N,1)*sum(input_points'.^2) + sum(X'.^2)'*ones(1,M) - 2*X*input_points';
 MM = [D.*log(D+eps); input_points'; ones(1,M)];   
 output_points = c'*MM;
 
