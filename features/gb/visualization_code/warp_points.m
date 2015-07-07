function [T,coeffs] = warp_points(P, D, r, towarp, coeffs)
% function O = warp_image(I, P, D)
% Warp the image I into the image O so that the points P in image I are at D in image O



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


  if (~exist('coeffs')),
    coeffs = get_tps_coeffs(P,D,r);
  end
  if (~exist('towarp')),
    T = tps_it(coeffs,P,P);
  else
    T = tps_it(coeffs,P,towarp);
  end
  
    
