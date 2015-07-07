function vis_gb_match(I1, pos1, I2, pos2, features1, features2, distsc, sample_points)

% function vis_gb_match(I1, pos1, I2, pos2, features1, features2,...
%   distsc, sample_points)
%
% Intercatively show the match of all points on the target to a specified point
% on the template.  Left click on a point on the template to see it's match
% in the target.  The color of points on the target indicate the quality of their
% match to the point clicked on the template.
%
% Note that this only uses the geometric blur descriptor no information about geometry
% or position is used...

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


ii1 = pos1(:,1);
jj1 = pos1(:,2);

ii2 = pos2(:,1);
jj2 = pos2(:,2);


subplot(2,1,1);
hold off
J = jet(1000);

drawnow
colormap(gray);

set(gcf,'doublebuffer','on');

while (1),
  mysubplot(2,2,1);
  hold off  
  imagesc(I1); axis image
  colormap(gray);
  hold on
  plot(jj1,ii1,'k.','markersize',20);
  plot(jj1,ii1,'w.','markersize',10);
  title('Template, left click a point');
  
  mysubplot(2,2,2);
  hold off  
  imagesc(I2); axis image
  hold on
  plot(jj2,ii2,'k.','markersize',20);
  plot(jj2,ii2,'w.','markersize',10);
  title('Target');
  
  fprintf('Left click a point (on the left image) to match. Right click to stop.\n');
  [x,y] = ginput(1);
  dists = sqrt(((ii1-y).^2) +((jj1-x).^2) );
  [md,mi]=min(dists);
  mi = mi(1);
  
  mysubplot(2,2,1);
  hold off  
  imagesc(I1); axis image
  hold on
  plot(jj1,ii1,'k.','markersize',20);
  plot(jj1,ii1,'w.','markersize',10);
  plot(jj1(mi),ii1(mi),'m*','markersize',20);
  title('Template, m* marks selected point, click to reset');
  
  mysubplot(2,2,3);
  hold off
  
  draw_descriptor(squeeze(features1(mi,:,:)),sample_points);
  
  [mmv,mmi] = min(distsc(mi,:));
  mmv = mmv(1);
  mmi = mmi(1);
  
  mysubplot(2,2,4);
  hold off
  draw_descriptor(squeeze(features2(mmi,:,:)),sample_points);
  
  
  mysubplot(2,2,2);
  hold off  
  title(sprintf('%4.2f',mmv));
  imagesc(I2); axis image
  hold on
  cols = jet(1000);
%  keyboard
  cmi = -distsc(mi,:);
  cmi=cmi-min(cmi);
  cmi=cmi/max(cmi);
  cmi=round(cmi*1000);
  cmi = max(1,cmi);
  cmi=min(1000,cmi);
  for ai=1:length(jj2),
    plot(jj2(ai),ii2(ai),'k.','markersize',20);
    plot(jj2(ai),ii2(ai),'w.','markersize',10,'color',cols(cmi(ai),:));
  end
  
  plot(jj2(mmi),ii2(mmi),'m*','markersize',20);
  title(sprintf('Target, m* marks best matching point\n using g.b. only'));
  drawnow
  colormap(gray);
  [x,y,b]=ginput(1);
  if (b==3),
    break;
  end  
end

