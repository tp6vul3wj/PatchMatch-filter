function features = normalize_descriptors(features,rs,nthetas);

% function features = normalize_descriptors(features,rs,nthetas);
%
% normlize the gb descriptors... this can be done based on sample
% variation using a population of gb descriptors, but here we 
% simply normalize each sample by the sqrt of the radius


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






  if (size(features,1)>0),    
    
    [sample_points  sample_points_r]  = compute_sample_points(rs,nthetas);
    
    
    
    nm = 1./(sqrt(sample_points_r)+(sample_points_r==0));
    
    features = features./repmat(nm,[size(features,1) 1 size(features,3)]);

    
    nm = sum(features.^2,3);
    nm = sum(nm,2);
    nm = sqrt(nm);
    nm(nm<0.001)=1;
    features = features./repmat(nm,[1 size(features,2) size(features,3) ]);
  end


