function [features,sample_points] = compute_gb( signal, ii, jj, alpha, ...
                                            beta, rs, nthetas )

% function [features,sample_points] = new_gb( signal, ii, jj, alpha, beta, rs, nthetas )
%
% signal is a three dimensional array.  The third dimension indexes
% the channel, the first two dimensions are spatial.  ii,jj are
% indices for the feature centers, the geoemtric blur at x, is
% G_{\alpha*|x|+\beta}, rs are the radii of the sample points [r_1 r_2
% ... ]  nthetas are the number of sample points at each radii


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


sigmas = alpha*rs+beta;
nsigmas = length(sigmas);



[sample_points  sample_points_r sample_points_sigma_level]  = compute_sample_points(rs,nthetas);

[rows,cols,nc] = size(signal);

for channel=1:size(signal,3),
  for i= 1 : nsigmas,
    current_features = find(sample_points_sigma_level==i);
    current_sigma = sigmas(i);
    hs = ceil(current_sigma)*3;
    x = [-hs:hs];
    g = (1/sqrt(2*pi*current_sigma^2))*exp(-(x.^2)/(2*current_sigma^2));
    g = g/sum(g);
    bsx = conv2(signal(:,:,channel),flipud(fliplr(g)),'same');
    bs = conv2(bsx,flipud(fliplr(g')),'same');
    
    for j=1:length(current_features),
      sample_ii = round(ii+sample_points(current_features(j),2));
      sample_jj = round(jj+sample_points(current_features(j),1));
      oob = ((sample_ii<1)+(sample_jj<1)+(sample_ii>rows)+(sample_jj>cols))>0;
      sample_ii(oob)=1;
      sample_jj(oob)=1;
      features(:,current_features(j),channel) =  bs(sample_ii+(sample_jj-1)*rows);
      features(oob,current_features(j),channel) = 0;
    end
  end
end





