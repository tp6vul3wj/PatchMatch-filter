function [ gss ] = getDenseGSS( im )
%GETDENSEGSS Summary of this function goes here
%   Detailed explanation goes here
im=im2double(im);

SSH_D1=5;
SSH_D2=5;

if SSH_D1>SSH_D2
    border=floor(SSH_D1/2);  % PatchResolution
else
    border=floor(SSH_D2/2);  % PatchResolution
end

im_h=size(im,1);
im_w=size(im,2);
gss=zeros(im_h,im_w,(SSH_D1*SSH_D2)^2);

if im_h>im_w
    grid_size=ceil(im_h/200);
else
    grid_size=ceil(im_w/200);
end

% [x y]=meshgrid(1:floor(im_w/grid_size),1:floor(im_h/grid_size));
x=(1:ceil(im_w/grid_size))*grid_size;
y=(1:ceil(im_h/grid_size))*grid_size;

for i=grid_size-1:-1:0
    indx_x=x-i;
    in_range_num=nnz(indx_x<=im_w);
    indx_x=indx_x(1:in_range_num);
    for j=grid_size-1:-1:0
        indx_y=y-j;
        in_range_num=nnz(indx_y<=im_h);
        indx_y=indx_y(1:in_range_num);
        
        subimage=im(indx_y,indx_x,:);
        
        subim_h=size(subimage,1);
        subim_w=size(subimage,2);
        
        I=fill_border(subimage, border);

        H=size(I,1);
        W=size(I,2);

        % instantiate self-similarity object and define settings
        SS=td_fastSelfSim;

        SS.numberClusters=400;    % number of clusters for the patch prototype codebook
        SS.clusteringMethod=1;    % random subsampling of the patches to be clustered
        SS.clusteringPatchesNumber=20000;  % number of patches to be clustered
        SS.D1=SSH_D1;                 % size D_1 of the self similarity hypercubes
        SS.D2=SSH_D2;                 % size D_2 of the self similarity hypercubes

        % get an image specific dictionary
        SS=SS.getClustersFromPixels({I});

        % now compute the prototype assignment map and visualize it
        M=SS.quantise(I);
        % imagesc(M);


        [xmin, ymin] = meshgrid(1:W-2*border, 1:H-2*border);
        xmin = reshape(xmin', 1, []);
        ymin = reshape(ymin', 1, []);
        [xmax, ymax] = meshgrid(1+2*border:W, 1+2*border:H);
        xmax = reshape(xmax', 1, []);
        ymax = reshape(ymax', 1, []);

        % compute many "non-normalized" SSHs
        SSHs=SS.getManySSH(M,xmin,ymin,xmax,ymax);
        tic;
        for h=1:subim_h
            for w=1:subim_w
                ssh=SSHs{w+(h-1)*subim_w};
                sp=1;
                for si=1:SS.D1
                    for sj=1:SS.D2
                        gss(indx_y(h),indx_x(w),1+(sp-1)*SS.D1*SS.D2:sp*SS.D1*SS.D2)=reshape(ssh(:,:,si,sj),1,[]);
                        sp=sp+1;
                    end
                end
            end
        end
        toc;
    end
end

end

% count=0;
% for i=1:300
%     for j=1:225
%         tmp=sum(gss(i,j,:)==0);
%         if tmp==625
%             count=count+1;
%         end
%     end
% end

