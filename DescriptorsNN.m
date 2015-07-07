function [ ratios NN1s NN1s_dist ] = DescriptorsNN( descps1,descps2, K, descp_type )
%DESCRIPTORSNN Summary of this function goes here
%   Detailed explanation goes here
% [height,width,dim]=size(descps1.SIFT);


for i=1:length(descp_type)
    tic;
    [ratios.(descp_type{i}), NN1s.(descp_type{i}), NN1s_dist.(descp_type{i})]=descpknn(double(descps1.(descp_type{i})),double(descps2.(descp_type{i})), K);
    toc;
end

%{
tic;
[ratios.SIFT, NN1s.SIFT, NN1s_dist.SIFT]=descpknn(double(descps1.SIFT),double(descps2.SIFT), K);
toc;

tic;
[ratios.GB, NN1s.GB, NN1s_dist.GB]=descpknn(double(descps1.GB),double(descps2.GB), K);
toc;

tic;
[ratios.DAISY, NN1s.DAISY, NN1s_dist.DAISY]=descpknn(double(descps1.DAISY),double(descps2.DAISY), K);
toc;

tic;
[ratios.LIOP, NN1s.LIOP, NN1s_dist.LIOP]=descpknn(double(descps1.LIOP),double(descps2.LIOP), K);
toc;

%}
end

function [ratio NN1 NN1_dist] = descpknn( descp1, descp2, K )
    lambda=0.0000001;
    
    [height1,width1,dim]=size(descp1);
    descp1=permute(descp1,[3,1,2]);
    descp1=reshape(descp1,dim,[]);
    
    [height2,width2,dim]=size(descp2);
    descp2=permute(descp2,[3,1,2]);
    descp2=reshape(descp2,dim,[]);
    
    kdtree = vl_kdtreebuild(descp2) ;
    [index, distance] = vl_kdtreequery(kdtree, descp2, descp1, 'NumNeighbors', 20, 'MaxComparisons', 100) ;
    distance=sqrt(distance);
%     mean2to5=sum(distance(2:3,:),1)/2;
%     ratio=max(distance(1,:),lambda)./max(mean2to5,lambda);
%     keyboard;
   %ratio=max(distance(1,:),lambda)./max(distance(2,:),lambda);

%     ra = 900;
    ra = K*sqrt(height2*width2);
    ratio = zeros(1,size(distance,2));
    dis_all = zeros(1,size(distance,2));
    for i=1:size(distance,2)
        ratio_single =-1;
        dis_single = -1;
        dis = zeros(1,20);
        for j=2:20
           index_cur = index(1,i);
           index_tar = index(j,i);
           [i1,j1] = ind2sub([height2,width2], index_cur);
           [i2,j2] = ind2sub([height2,width2], index_tar);
           if i2>i1
               tmp = i2;
               i2=i1;
               i1=tmp;
           end
           if j2>j1
               tmp = j2;
               j2=j1;
               j1=tmp;
           end
           
           dis(j) = (i1-i2)^2+(j1-j2)^2;
           if dis(j)>ra
              ratio_single = max(distance(1,i),lambda)./max(distance(j,i),lambda);
              dis_single = dis(j);
              break; 
           end
        end

        if ratio_single == -1
            [ind ,pos] = max(dis);
            ratio_single = max(distance(1,i),lambda)./max(distance(pos,i),lambda);
            dis_single = dis(pos);
        end

        ratio(i) =  ratio_single;
        dis_all(i) =  dis_single;
    end


    ratio=reshape(ratio,height1,width1);
    
    nn1_indx=reshape(index(1,:),height1,width1);
    [NN1(:,:,1), NN1(:,:,2)]=ind2sub([height2, width2],nn1_indx);
    
    NN1_dist=reshape(distance(1,:),height1,width1);
    
%     [height1,width1,dim]=size(descp1);
%     
%     descp1=permute(descp1,[3,1,2]);
%     descp1=reshape(descp1,dim,[])';
%     
%     [height2,width2,dim]=size(descp2);
%     descp2=permute(descp2,[3,1,2]);
%     descp2=reshape(descp2,dim,[])';
%     
%     keyboard;
%     
%     [indx,dist]=knnsearch(descp2,descp1,'k',2);
%     
% 	ratio=max(dist(:,1),lambda)./max(dist(:,2),lambda);
%     % ratio(isnan(ratio))=1;
%     ratio=reshape(ratio,height1,width1);
%     
%     nn1_indx=reshape(indx(:,1),height1,width1);
%     [NN1(:,:,1), NN1(:,:,2)]=ind2sub([height2, width2],nn1_indx);
%     
%     NN1_dist=reshape(dist(:,1),height1,width1);
end

