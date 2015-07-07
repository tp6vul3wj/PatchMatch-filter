function dists = comp_features( f1 , f2 )

% function dists = comp_features( f1 , f2 )
% 
% compares gb features that have already been normalized 
% by computing their pairwise inner product
%


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



  
  f1 = permute(f1,[2 3 1]);            
  f1 = reshape(f1,[size(f1,1)*size(f1,2),size(f1,3)])';
  
  f2 = permute(f2,[2 3 1]);            
  f2 = reshape(f2,[size(f2,1)*size(f2,2),size(f2,3)]);
  
  dists = f1*f2;
  
