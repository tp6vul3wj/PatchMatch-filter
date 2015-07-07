function [RRR,H,c,x,ind_i,ind_j] = compute_correspondence_wrapper(descriptors1,...
                                     descriptors2,pos1,pos2,selected1,...
                                     alpha,niters,nmp,noutliers,id1,id2,w1,r1,w2,r2)

% [RRR,H,c,x,ind_i,ind_j] = compute_correspondence_wrapper(descriptors1,descriptors2,pos1,pos2,selected1,alpha,niters,noutliers,id1,id2)
%
% descriptors are the gb feature descriptors
% pos are the positions of the features
% selected1 are a subset of descriptors1 to use 
% alpha is a parameter for combining distortion and matching terms in the objective function
% niters is the number of iterations for gradient descent
% noutliers is the number of outliers to allow in the optimization
% id identifies the feature type for each feature



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



  if islogical(selected1),
    selected1 = find(selected1);
  end


  
%  keyboard
  good_inds = uniform_sample(pos1(selected1,:),nmp);
  
%  rp = randperm(length(selected1));
%  selected1 = selected1(rp);
%  selected1 = selected1(1:min(length(selected1),nmp));
  selected1 = good_inds;
  
  subset_ps = pos1(selected1,:);

  MODEL.ii = subset_ps(:,1);
  MODEL.jj = subset_ps(:,2);
  MODEL.features = descriptors1(selected1,:,:);
  id1 = id1(selected1);
  maxiters = 5;

  reg = 1;
  nmatches = 50;
  PROBE.ii = pos2(:,1);
  PROBE.jj = pos2(:,2);
  PROBE.features = descriptors2;
  ssd = 0;

  p0 = [MODEL.jj(:) MODEL.ii(:)];
  
  d0 = permute(MODEL.features,[2 3 1]);            
  d0 = reshape(d0,[size(d0,1)*size(d0,2),size(d0,3)])';

  p1 = [PROBE.jj(:) PROBE.ii(:)];
    
  d1 = permute(PROBE.features,[2 3 1]);            
  d1 = reshape(d1,[size(d1,1)*size(d1,2),size(d1,3)])';


%  keyboard;
%  [H,c,ind_i,ind_j,spA] = setup_costs_mex_2(p0,p1,d0,d1,ssd,10000000000,0, nmatches,1,1);
%  keyboard
  [H,c,ind_i,ind_j,spA] = setup_costs_adjusted_both(p0,p1,d0,d1,ssd, 10000000000,0,nmatches,1,w1,r1,w2,r2,id1,id2);

  c(c==0)=-1;
%  c = c.^31;
    
  ind_i = ind_i + 1;
  ind_j = ind_j + 1;
  
  H= real(H);
  
  Aeq = [];
  beq = [];
  
%  c = -c.^10;
  
%  [x] = minass_climb_new_interface(H,alpha*c,spA,noutliers,500,0);
%keyboard

% if exist('evv')&&(evv == 1),
%  [x,q] =  minass_climb_new_interface_q(H,alpha*c,spA,noutliers,500,0);
% elseif exist('evv')&&(evv == 2),
  [x,q] = minass_climb_new_interface_q_debug_out_fast(H,alpha*c,spA,noutliers,niters,0);
% else
%   [x,q] = minass_climb_new_interface_q_debug_out(H,alpha*c,spA,noutliers,niters,0);
% end

%[x,q] =
%minass_climb_new_interface_q(H,alpha*c,spA,noutliers,500,0);

%[x,q] = minass_climb_new_interface_q(H,alpha*c,spA,noutliers,0,0);
noutliers


  
  inds = find(x>0.99);
  contrib = sum(H(inds,inds));
%  figure(7)
%  clf
%  plot(contrib);
  [dummy, contrib_order]=sort(-contrib);
  nextra_outliers = 0;
  x(inds(contrib_order(1:nextra_outliers)))=0;
  x(spA(ind_i(inds(contrib_order(1:nextra_outliers))),2)+1)=1;

  xmin=x;
  match = zeros(length(MODEL.ii),2);
  for i=1:max(ind_i),
    has_is = (ind_i ==i);
    cj = find((xmin.*has_is)>0.99);
    if length(cj)~=1,
      fprintf('error in constraint %d.\n',i);
      keyboard
    else
      match(i,1)=selected1(ind_i(cj));
      match(i,2) = ind_j(cj);
      distortion(i) = H(cj,:)*xmin;
      if match(i)>size(p1,1),
        match(i,2)=0;
      end
      
    end
  end
 
  
  ind_i = selected1(ind_i);
  
  RRR.match = match;
  inds = find(x>0.99);
  contrib = sum(H(inds,inds));
  RRR.score_g = contrib;
  RRR.score_m = alpha*sum(c(inds));
