function [] = DrawDescSelect( labels, iter, alpha )
%DRAWDESCSELECT Summary of this function goes here
%   Detailed explanation goes here

[h w ~]=size(labels);
label_im=zeros(h,w,3);
for j=1:h
    for i=1:w
        desc_type=labels(j,i,3);
        label_im(j,i,desc_type)=1;
    end
end
figure, imshow(label_im);
% imwrite(label_im,['GB_04_iter_' num2str(iter) '_' num2str(alpha) '.png'],'png');
% imwrite(label_im,['iter_' num2str(iter) '.jpg'],'jpg');

end

