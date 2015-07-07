function [ labelVol ] = CostVolume( cur_node, cur_label, descps1, descps2, descps_ratios,descps_NN1s_dist, paras )
%COSTVOLUME Summary of this function goes here
%   Detailed explanation goes here

% parameters setting
if isfield(paras,'alpha')
    alpha=paras.alpha;
else
    alpha=1;
end
if isfield(paras,'gamma1')
    gamma1=paras.gamma1;
else
    gamma1=1;
end
if isfield(paras,'gamma2')
    gamma2=paras.gamma2;
else
    gamma2=100;
end
if isfield(paras,'lambda')
    lambda=paras.lambda;
else
    lambda=0.0000000001;
end
if isfield(paras,'descps_type')
    descps_type=paras.descps_type;
else
    descps_type={'SIFT','GB','DAISY','LIOP'};
end

im2_h=size(descps2.im,1);
im2_w=size(descps2.im,2);

subim_top=cur_node.subimage_range(1,1);
subim_down=cur_node.subimage_range(2,1);
subim_left=cur_node.subimage_range(1,2);
subim_right=cur_node.subimage_range(2,2);

subim_h=subim_down-subim_top+1;
subim_w=subim_right-subim_left+1;
subim_mask=ones(subim_h,subim_w);

labelVol=ones(subim_h,subim_w);

u=cur_label(1);
v=cur_label(2);

if subim_top+u < 1
    tmp=1-(subim_top+u);
    if tmp > subim_h
        subim_mask(:,:)=0;
    else
        subim_mask(1:tmp,:)=0;
    end
    new_subim_top=1;
else
    new_subim_top=subim_top+u;
end
if subim_down+u > im2_h
    tmp=(subim_down+u)-im2_h;
    if tmp > subim_h
        subim_mask(:,:)=0;
    else
        subim_mask(end-tmp+1:end,:)=0;
    end
    new_subim_down=im2_h;
else
    new_subim_down=subim_down+u;
end
if subim_left+v < 1
    tmp=1-(subim_left+v);
    if tmp > subim_w
        subim_mask(:,:)=0;
    else
        subim_mask(:,1:tmp)=0;
    end
    new_subim_left=1;
else
    new_subim_left=subim_left+v;
end
if subim_right+v > im2_w
    tmp=(subim_right+v)-im2_w;
    if tmp > subim_w
        subim_mask(:,:)=0;
    else
        subim_mask(:,end-tmp+1:end)=0;
    end
    new_subim_right=im2_w;
else
    new_subim_right=subim_right+v;
end
[my mx]=ind2sub([subim_h, subim_w],find(subim_mask));

descp_type=descps_type{cur_label(3)};

% Truncated ratio of dist(p,NN1)/dist(p,NN2) for current descriptor
tmp=descps_ratios.(descp_type)(subim_top:subim_down,subim_left:subim_right);
c_desc=min(tmp, gamma1);

% Truncated ratio of dist(p,p')/dist(p,NN1) for current displacement
sub_desc1=double(descps1.(descp_type)(subim_top:subim_down,subim_left:subim_right,:));
sub_desc2=zeros(subim_h,subim_w,size(descps2.(descp_type),3));
tmp=descps2.(descp_type)(new_subim_top:new_subim_down,new_subim_left:new_subim_right,:);
tmp=permute(tmp,[3,1,2]);
tmp=reshape(tmp,size(descps2.(descp_type),3),[])';
for p=1:size(my)
    sub_desc2(my(p),mx(p),:)=tmp(p,:);
end

diff=sub_desc1-sub_desc2;
dist=sqrt(sum(diff.^2,3));

subim_NN1s_dist=descps_NN1s_dist.(descp_type)(subim_top:subim_down,subim_left:subim_right);
tmp_ratio=max(dist,lambda)./max(subim_NN1s_dist,lambda);
c_disp=min(tmp_ratio, gamma2);
c_disp(subim_mask==0)=gamma2;


datacost=c_desc+alpha*c_disp;
% datacost=c_desc.*c_disp;
% datacost=c_disp;
labelVol(:,:)=datacost;

end

