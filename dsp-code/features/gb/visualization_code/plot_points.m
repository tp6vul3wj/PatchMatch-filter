function plot_points(cind, x,y,ms_big,ms)




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


colors = ['r.';'b.';'g.';'c.';'m.';'y.'];

          
colorpoints = 1;
          
cinds = randperm(1000);
cinds = [1:1000];


for lcv=1:length(x),
  %              dind = cinds(lcv);                            
  dind = cinds(cind(lcv));                            
  dind = mod(dind,6)+1;
  plot(x(lcv),y(lcv),'k.','markersize',ms_big);
  plot(x(lcv),y(lcv),colors(dind,:),'markersize',ms);
end


