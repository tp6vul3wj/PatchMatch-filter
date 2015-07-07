close all;
clear all;

% for CAL
%{
load('rand_img.mat')
category_all = {'airplanes','chair','crayfish', 'cup', ...
          'dalmatian', 'dolphin', 'helicopter', 'flamingo', 'minaret', ...
          'panda', 'rooster', 'schooner', 'snoopy', 'soccer_ball', ...
          'sunflower'};
%}

%{
{'airplanes',[2,3; 14,15; 25,28; 43,48; 70,75; 92,96; 12,56; 124,159; 314,361; 652,746]}
{'beaver',[4,3; 22,23; 35,36; 1,15; 34,44; 4,34; 34,35; 27,28; 5,17; 13,19]}
{'cup',[15,14; 47,56; 25,33; 27,30; 47,52; 16,15; 21,25; 57,48; 39,40; 56,28]}
{'schooner',[13,19; 27,29; 30,59; 12,13; 16,19; 36,48; 44,52; 55,41; 52,49; 30,24]};
{'snoopy',[16,17; 10,14; 4,9; 8,7; 27,25; 35,21; 15,1; 26,27; 24,11; 7,25]};
{'sunflower',[5,11; 57,59; 41,2; 28,34; 32,31; 73,74; 26,34; 23,36; 21,22; 7,5]}
{'butterfly',[8,3; 27,30; 35,32; 31,49; 1,58; 66,67; 73,81; 3,15; 61,86; 16,19]}
{'minaret',[24,25; 8,16; 20,25; 44,45; 50,55; 51,42; 33,32; 72,73; 75,69; 60,70]};
{'rooster',[27,7; 26,28; 46,43; 6,14; 22,29; 36,31; 47,29; 44,39; 4,9; 16,2]};
{'lamp',[13,12; 25,28; 56,60; 13,23; 36,53; 49,52; 17,5; 60,52; 23,20; 44,6]};
{'dalmatian',[1,2; 14,26; 39,40; 46,48; 59,51; 14,7; 35,28; 46,44; 38,29; 28,16]};
{'helicopter',[6,4; 24,23; 34,28; 37,43; 42,49; 60,53; 68,71; 87,65; 82,53; 51,45]};
{'ketch',[103,111; 83,79; 80,55; 35,56; 11,5; 17,20; 56,51; 53,45; 99,102; 62,61]};
{'water_lilly',[1,16; 35,1; 26,27; 10,18; 11,16; 8,10; 15,19; 32,33; 2,5; 13,14]};
{'umbrella',[9,7; 25,22; 31,33; 60,73; 43,69; 45,61; 37,26; 26,40; 52,63; 50,54]};
{'ferry',[19,33; 40,41; 11,42; 58,67; 50,40; 33,44; 19,40; 48,31; 27,39; 4,14]};
{'flamingo',[7,6; 28,27; 10,28; 54,32; 67,62; 59,43; 56,51; 1,51; 9,45; 11,22]};
{'chair',[1,23; 24,29; 46,49; 36,37; 35,39; 16,9; 45,27; 31,33; 2,61; 14,4]};
{'panda',[3,4; 9,14; 11,31; 22,29; 29,30; 36,11; 7,13; 23,29; 4,10; 31,32]};
{'crayfish',[7,2; 16,31; 29,17; 43,40; 69,43; 47,57; 64,58; 16,14; 54,39; 59,47]};

%}
class_name_all =  {{'helicopter',[6,4; 24,23; 34,28; 37,43; 42,49; 60,53; 68,71; 87,65; 82,53; 51,45]};
{'ketch',[103,111; 83,79; 80,55; 35,56; 11,5; 17,20; 56,51; 53,45; 99,102; 62,61]}};

%class_name_all = {{'rooster',27,7},{'rooster',26,28},{'rooster',46,43},...
%     {'beaver',23,3}};

%{
     {{'rooster',27,7},{'rooster',26,28},{'rooster',46,43},...
     {'beaver',23,3},{'beaver',22,23},{'beaver',36,44},...
     {'schooner',30,59},{'schooner',12,13},{'schooner',16,19}...
     {'sunflower',41,2},{'sunflower',5,11},{'sunflower',57,59},...
     {'cup',56,28},{'cup',47,51},{'cup',39,40},...
     {'minaret',52,15},{'minaret',24,25},{'minaret',72,73}};
     %}
% LMO
%category_all = {'mountain', 'street', 'tallbuilding'};%, 'coast_sun', 'highway','highway_car', 'insidecity', 'mountain', 'street', 'tallbuilding'};

% for VGG
%class_name_all = {'boat'};
%file_name1_all = {'_2'};%{'_2','_3','_4','_5','_6'};

fusion=1; %1:SGDL, 0:single descriptor
dataset='CAL'; %'LMO','VGG', 'CAL'

sift = [5 8 10 12 15 18 20]; 
gb = [3 4 5 6 7 8 9];
daisy = [10 15 20 25 30 35 40];
liop = [10 15 20 25 30 35 40];

for num_class=1:length(class_name_all)
    for img_num = 1:size(class_name_all{num_class}{2},1)  % for CAL: 1:10; for VGG 1:5; for LMO 1:9
        for p_d = 3
            if strcmp(dataset,'CAL')
                %class_name = {category_all{class},rand_all.(category_all{class})(2*img_num-1),rand_all.(category_all{class})(2*img_num)};
                class_name = class_name_all{num_class};
                category = class_name{1};
                ind1 =  class_name{2}(img_num,1);
                ind2 =  class_name{2}(img_num,2);
                name = [category,num2str(ind2),'to',num2str(ind1)];
                input_dir = ['datasets\cal101\101_ObjectCategories\',category,'\'];
                output_dir = ['Results\CAL\',category,'\',num2str(ind2),'to',num2str(ind1),'\'];
                mkdir(output_dir);

                output_dir = ['Results\CAL\',category,'\',num2str(ind2),'to',num2str(ind1), '\'];
                output_dir2 = ['Results\CAL\',category,'\',num2str(ind2),'to',num2str(ind1), '\other\'];
                output_dir3 = [input_dir name, '\supportR' num2str(10*(p_d+1)) '\'];
                mkdir(output_dir);
                mkdir(output_dir2);
                mkdir(output_dir3);
                
                if ind1<10
                   ind1 = ['000',num2str(ind1)]; 
                elseif ind1<100
                   ind1 = ['00',num2str(ind1)]; 
                else
                   ind1 = ['0',num2str(ind1)]; 
                end
                if ind2<10
                   ind2 = ['000',num2str(ind2)]; 
                elseif ind2<100
                   ind2 = ['00',num2str(ind2)]; 
                else
                   ind2 = ['0',num2str(ind2)]; 
                end

                im1=imread([input_dir,'image_',ind1,'.jpg']);
                im2=imread([input_dir,'image_',ind2,'.jpg']);
                
            elseif strcmp(dataset,'VGG')
                class_name =class_name_all{num_class};
                file_name1 = file_name1_all{img_num};
                file_name2 = '_1';

                input_dir = ['datasets\VGG\' class_name '\'];
                im1=imread([input_dir 'img' file_name1(end) '.ppm']);
                im2=imread([input_dir 'img' file_name2(end) '.ppm']);
                name = [class_name,' ',file_name2(2:end) 'to' file_name1(2:end)];
                output_dir = ['Results\VGG\' class_name '_test\' file_name2(2:end) 'to' file_name1(2:end) '\supportR' num2str(10*(p_d+1)) '\'];
                output_dir2 = ['Results\VGG\' class_name '_test\' file_name2(2:end) 'to' file_name1(2:end) '\supportR' num2str(10*(p_d+1)) '\other\'];
                output_dir3 = [input_dir name, '\supportR' num2str(10*(p_d+1)) '\'];
                
                mkdir(output_dir);
                mkdir(output_dir2);
                mkdir(output_dir3);

                %im1 = imresize(imfilter(im1,fspecial('gaussian',5,0.67),'same','replicate'),0.5,'bicubic');
                %im2 = imresize(imfilter(im2,fspecial('gaussian',5,0.67),'same','replicate'),0.5,'bicubic');
            end


            %% preprocessing
            if size(im1,3)<3
                new_im=uint8(zeros(size(im1,1),size(im1,2),3));
                new_im(:,:,1)=im1;
                new_im(:,:,2)=im1;
                new_im(:,:,3)=im1;
                im1=new_im;
            end
            if size(im2,3)<3
                new_im=uint8(zeros(size(im2,1),size(im2,2),3));
                new_im(:,:,1)=im2;
                new_im(:,:,2)=im2;
                new_im(:,:,3)=im2;
                im2=new_im;
            end

            % Set parameters
            K = 500;    % number of superpixels for one image
            r = 12;  % r-pixel for extended subimage

            % tic;
            [im1_seg, im1_graph]=SegImgSLIC(im1, K, r);
            [im2_seg, im2_graph]=SegImgSLIC(im2, K, r);
            % toc;

            % Extract features
            paras_d.SIFT = sift(p_d); 
            paras_d.GB = gb(p_d);
            paras_d.DAISY = daisy(p_d);
            paras_d.LIOP = liop(p_d);
            %descps1=ExtractAllDescps(im1,paras_d);
            %descps2=ExtractAllDescps(im2,paras_d);
            % load('SIFT_01_a_descps.mat');
            % load('SIFT_01_b_descps.mat');
            %save([output_dir  'descp.mat'],'descps1', 'descps2','-v7.3');
            
            if exist([output_dir3 'descp.mat'],'file');
                load([output_dir3 'descp.mat']);
            else
                descps1=ExtractAllDescps(im1,paras_d);
                descps2=ExtractAllDescps(im2,paras_d);
                %save([output_dir3  'descp.mat'],'descps1', 'descps2','-v7.3');
            end

            descps1.im=im1;
            descps2.im=im2;

            im1=im2double(im1);
            im2=im2double(im2);

            %% patchmatch filter algorithm
            % Set parameters
            feature_num=4;
            iter_times=20;
            % alphas=[0.25 0.5 0.75 1 1.25 1.5]';
            % alphas=0.7;
            % winsizes=[149 99 49 39 15]';
            % gamma2s=[1 2 3 4 5 6 7 8 9 10 20 30 40]';
            dsp_gammas=[0.75];%0.25; %
            dsp_alphas=[0.2];%0.1; %
            % gamma1s=[0.5 0.6 0.7 0.8 0.9 1]';
            % gamma1s=1;

            % label_result=mexPatchMatchFilter(im1_graph,im2_graph);
            Descps_type = {'SIFT','GB','DAISY','LIOP'};%{'SIFT','GB','DAISY','LIOP'};

            for i=1:length(dsp_gammas)
                    for j=1:length(dsp_alphas)
                        
                        if fusion==1
                            out_filename=['SGDL_alpha=',num2str(dsp_alphas(j)),',gamma=',num2str(dsp_gammas(i)), ',R=' num2str(10*(p_d+1))];%Descps_type{desp};%
                            % parameters setting
                            paras.dsp_alpha=dsp_alphas(j);
                            paras.dsp_gamma=dsp_gammas(i);
                            paras.alpha=0.7;    % weighted value
                            paras.gamma1=1;   % <= 1
                            paras.gamma2=3;   % >= 1
                            paras.lambda=0.0000000001;    % avoid to be divided by zero
                            paras.descps_type = Descps_type;%{Descps_type{desp}};%
                            paras.K=2;
                            
                            
                            if exist([output_dir2 out_filename '_label.mat'],'file');
                                load([output_dir2 out_filename '_label.mat']);
                            else
                                [dsp_label_result] = DSPMatch(descps1,descps2,paras);
                                vy=dsp_label_result(:,:,1);
                                vx=dsp_label_result(:,:,2);
                                warp21=warpImage(im2,vx,vy);
                                figure, imshow(warp21);
                                save([output_dir2 out_filename '_label.mat'],'dsp_label_result');
                                imwrite(warp21,[output_dir2 out_filename '_warp.png'],'png');
                            end

                            [label_result cost_result it]=DSP_PatchMatchFilter(im1_graph,im2_graph,descps1,descps2,dsp_label_result,feature_num,iter_times,paras, output_dir, out_filename);
                            vy=label_result(:,:,1);
                            vx=label_result(:,:,2);
                            desc_map=label_result(:,:,3);
                            cost=cost_result;
                            
                            mkdir([output_dir 'comparison\']);
                            save([output_dir 'comparison\' out_filename  '-iter=' num2str(it) '.mat'],'vx','vy','desc_map','paras','cost');
                            
                        else
                            for desp = 1:length(Descps_type)
                                out_filename=[Descps_type{desp} '_alpha=',num2str(dsp_alphas(j)),',gamma=',num2str(dsp_gammas(i))];%Descps_type{desp};%
                                % parameters setting
                                paras.dsp_alpha=dsp_alphas(j);
                                paras.dsp_gamma=dsp_gammas(i);
                                paras.alpha=0.7;    % weighted value
                                paras.gamma1=1;   % <= 1
                                paras.gamma2=3;   % >= 1
                                paras.lambda=0.0000000001;    % avoid to be divided by zero
                                paras.descps_type = {Descps_type{desp}};
                                paras.K=2;


                                
                                    [dsp_label_result] = DSPMatch(descps1,descps2,paras);
                                    vy=dsp_label_result(:,:,1);
                                    vx=dsp_label_result(:,:,2);
                                    warp21=warpImage(im2,vx,vy);
                                    figure, imshow(warp21);
                                    save([output_dir2 out_filename '_label.mat'],'dsp_label_result');
                                    imwrite(warp21,[output_dir2 out_filename '_warp.png'],'png');
                                

                                [label_result cost_result it time_all]=DSP_PatchMatchFilter(im1_graph,im2_graph,descps1,descps2,dsp_label_result,feature_num,iter_times,paras, output_dir, out_filename);
                                vy=label_result(:,:,1);
                                vx=label_result(:,:,2);
                                desc_map=label_result(:,:,3);
                                cost=cost_result;

                                mkdir([output_dir 'comparison\']);
                                save([output_dir 'comparison\' out_filename  '-iter=' num2str(it) '.mat'],'vx','vy','desc_map','paras','cost','time_all');
                                
                            end
                        end
                    end
            end
        end
    end
end