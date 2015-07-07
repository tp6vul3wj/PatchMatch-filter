function [ descps ] = ExtractAllDescps( im, paras )
%EXTRACTALLDESCP Summary of this function goes here
%   Detailed explanation goes here

% SIFT
disp('---SIFT---------------------');
% cellsize=3; gridspacing=1;
cellsize=paras.SIFT; gridspacing=1;
smooth_im=imfilter(im,fspecial('gaussian',7,1.),'same','replicate');
% descps.SIFT = mexDenseSIFT(smooth_im,cellsize,gridspacing);
descps.SIFT = im2single(mexDenseSIFT(smooth_im,cellsize,gridspacing));
smooth_im=im2single(rgb2gray(smooth_im));
[frame,desc]=vl_covdet(smooth_im,'Method','MultiscaleHessian','EstimateAffineShape',true); % ,'EstimateOrientation',true);
% figure, imshow(im);
% hold on;
for i=1:size(frame,2)
    x_pos=round(frame(1,i));
    y_pos=round(frame(2,i));
    descps.SIFT(y_pos,x_pos,:)=desc(:,i)';
%     plot(x_pos, y_pos, 'Color','r', 'Marker','o');
end
% hold off;

% GB
disp('---GB-----------------------');
descps.GB = getDenseGBfeatures(im, gridspacing,paras.GB);

% DAISY
disp('---DAISY--------------------');
descps.DAISY = getDaisyFeatures(im,paras.DAISY);

% LIOP
disp('---LIOP---------------------');
descps.LIOP = getDenseLIOP(im,paras.LIOP);

% % GSS
% disp('---GSS----------------------');
% descps.GSS=getDenseGSS(im);

end

