function draw_descriptor(features,sample_points)

% function draw_descriptor(features,sample_points)
%
% draw a geoemtric blur descriptor descriptor



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

J = jet(1000);


if (size(features,1)==1),
  features = permute(features,[2 1]);
end


  ni = ceil(sqrt(size(features,2)));
  maxv = max(max(features(:,:)));
  minv = min(min(features(:,:)));
  col_ind = squeeze(min(1000,max(1,round(1000*((features(:,:)- ...
                                                minv)./(maxv-minv))))));
  if (size(col_ind,1)==1),
    col_ind = col_ind(:);
  end
  
  for c=1:size(features,2),
    cx = mod(c-1,ni)*(1.6*max(sample_points(:))+10) +  max(sample_points(:));
    cy = floor((c-1)/ni)*(1.6*max(sample_points(:))+10) +  max(sample_points(:));
    for i=size(sample_points,1):-1:1,
      plot(cx+0.7*sample_points(i,1),cy-0.7*sample_points(i,2),'.','color',J(col_ind(i,c),:),'markersize',40);
      hold on
    end
  end
  axis equal 
  axis tight
  axis off
  drawnow


