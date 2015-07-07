clc;
clear;
desp='comparison';
dir_ann = 'datasets\cal101\';
img ={'rooster',[27,7; 26,28; 46,43; 6,14; 36,31; 4,9; 16,2]};
%ResultDir = [pwd '\Results\VGG\' class_name '_test\' file_name1(2:end) 'to' file_name2(2:end) '\',desp,'\'];
%{
{{'Faces',336,114},{'Faces',22,245},{'Faces',1,2},{'Faces',19,33},...
     {'sunflower',41,2},{'sunflower',5,11},{'sunflower',57,59},...
     {'cup',56,28},{'cup',47,51},{'cup',39,40},...
     {'minaret',52,15},{'minaret',24,25},{'minaret',72,73},...
     {'rooster',27,7},{'rooster',26,28},{'rooster',46,43},...
     {'beaver',23,3},{'beaver',22,23},{'beaver',36,44},...
     {'schooner',30,59},{'schooner',12,13},{'schooner',16,19}};
%}
figure, 
PlotType = {'-r+','-go','-b*','-cx','-mh','-ko','-y*','-m*','-r*','-b+',...
    '-ro','-g*','-y+','-bo','-co','-mo','-g+','-k+','-m+','-k*'};

category = img{1};
file_num= img{2};
for img_num=1:length(file_num)
   %img = str_img{img_num};
   ind1o =  img{2}(img_num,1);
   ind2o =  img{2}(img_num,2);
   fileDir = [pwd '\Results\CAL\' category '\',num2str(ind2o) 'to' num2str(ind1o) '\comparison\'];
   ResultList = dir([fileDir '*.mat']);
    
   input_dir = ['datasets\cal101\101_ObjectCategories\',category,'\'];
   if ind1o<10
       ind1 = ['000',num2str(ind1o)]; 
    elseif ind1o<100
       ind1 = ['00',num2str(ind1o)]; 
    else
       ind1 = ['0',num2str(ind1o)]; 
    end
    
    if ind2o<10
       ind2 = ['000',num2str(ind2o)]; 
    elseif ind2o<100
       ind2 = ['00',num2str(ind2o)]; 
    else
       ind2 = ['0',num2str(ind2o)]; 
    end
    
    image_1=imread([input_dir,'image_',ind1,'.jpg']);
    image_2=imread([input_dir,'image_',ind2,'.jpg']);
    
    for i = 1:length(ResultList)
       load([fileDir ResultList(i).name]);
       warp21=warpImage(im2double(image_2),vx,vy);
       figure('visible','on'),
       subplot(2,4,1), imshow(image_1); title(['Image1 (' num2str(ind1o),')']);
       subplot(2,4,2), imshow(image_2); title(['Image2 (' num2str(ind2o),')']);
       subplot(2,4,3), imshow(warp21); title(['Warp']);
       desc_gray=mat2gray(desc_map,[1,4]);
       desc_X = gray2ind(desc_gray, 256);
       desc_im = ind2rgb(desc_X, jet(256));
       subplot(2,4,4), imshow(desc_im); title(['Descriptor']);
       
       fileDirAnn = [dir_ann,'Annotations_img/',category,'/']; 
       load([fileDirAnn,ind1,'.mat']);
       ann1 = double(IN);
       [m1,n1,~] = size(image_1);
       ann1 = imresize(ann1,[m1,n1]);
       load([fileDirAnn,ind2,'.mat']);
       ann2 = double(IN);
       [m2,n2,~] = size(image_2);
       ann2 = imresize(ann2,[m2,n2]);
       
       subplot(2,4,5), imshow(ann1); title(['Image1']);
       subplot(2,4,6), imshow(ann2); title(['Image2']);
       warp21=warpImage(ann2,vx,vy);
       subplot(2,4,7), imshow(warp21); title('Warp');
       k=ann1*0;
       k(ann1~=warp21)=1;
       k(ann1==warp21)=0;
       acc = warp21==ann1;
       acc = sum(sum(acc))/(size(acc,1)*size(acc,2))*100;
       ann_iou=(ann1+warp21)>0;
       union = sum(sum(ann_iou));
       inter = sum(sum(ann1&warp21));
       iou = (inter/union)*100;

       subplot(2,4,8), imshow(k); title({['Accueacy = ',num2str(acc),' %'],['IOU = ',num2str(iou),' %']}); 
       axis off; 
       axis image;
   
       Result.acc(i) = acc;
       Result.iou(i) = iou;
    end
    %plot(Result.acc,PlotType{img_num});
    %hold on;
    %hold on; plot(Result.iou,'-g*')
   %title([category '\',num2str(ind2o) 'to' num2str(ind1o)]);
   %LegnendName{img_num} = [category '\',num2str(ind2o) 'to' num2str(ind1o)];  
end

%legend(LegnendName, 'location','Best');
