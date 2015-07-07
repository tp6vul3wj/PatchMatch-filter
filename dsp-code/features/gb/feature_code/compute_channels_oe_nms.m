function fbr = compute_channels_oe_nms(I)

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



I = im2double(I);


% Make sure the image is in fact grayscale
if (3==size(I,3)),
  img = rgb2gray(I);
else
  img = I;
end


% construct oriented edge filters usin Gaussian quadrature
[FB, O]= make_fb(4,3,4,15);
FB = FB(:,:,1:2:end);
O = O(1:2:end);


for i=1:size(FB,3),
  %compute oriented edge response
  fbr(:,:,i) = abs(conv2(img,flipud(fliplr(FB(:,:,i))),'same'));
  % smooth edge response
  fbr(:,:,i) = conv2(fbr(:,:,i),fspecial('gaussian',15,2),'same');
  % us non-max supression to obtain a sparse signal
  fbr(:,:,i) = nonmax(fbr(:,:,i),-O(i)*2*pi/360);
end

% zero out edge effects
fbr(1:3,:,:)=0;
fbr(end-2:end,:,:)=0;
fbr(:,1:3,:)=0;
fbr(:,end-2:end,:)=0;


