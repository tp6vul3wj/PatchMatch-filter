function [ci,cj] = find_interest_points( signal, desired, r )


% function [ci,cj] = find_interest_points( signal, desired, r )
%
% use rejection sampling to find interest points along edges
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


   rs = r*r;
  ci = [];
  cj = [];
  
  center_signal = 0;
  thresh = 0.1*max(max(signal));  % initial threshhold
  tcount = 1;
  while sum(center_signal(:))<(desired*2),
    center_signal = signal>=thresh;
    thresh = thresh*0.9;
    tcount = tcount+1;
    if (tcount>10),
      break
    end
  end

  
  
  % now we have at least 400 points in center_signal
  % do rejection sampling to geta spatially uniform sample
%  keyboard
  
  [rows,cols] = size(signal);
  
  [ci,cj]=find(center_signal);
  
  n = length(ci);
  rp = randperm(n);
  ci=ci(rp);
  cj=cj(rp);
  good = ones(n,1);
  vgood = zeros(n,1);
  ind = [1:n];
  for i=1:n,
    if (good(i)),
      close = (((ci-ci(i)).^2) + ((cj-cj(i)).^2))<rs;
      good = good.*(~close);
      vgood(i) = 1;
      good(i) = 1;
      if (sum(vgood)>=desired),
        break
      end
    end
  end
  
  ci = ci(vgood>0);
  cj = cj(vgood>0);
