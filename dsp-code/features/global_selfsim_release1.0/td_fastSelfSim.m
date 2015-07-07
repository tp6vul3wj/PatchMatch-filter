classdef td_fastSelfSim
    properties

        % cluster centers
        CX=zeros(0,0);
        
        % number of cluster centers
        numberClusters=1000;
        
        % extraction size for the patches is 2*scale+1;
        scale=5;
        
        D1=10;
        D2=10;
        
        % how to get clusters
        %
        % clusteringMethod = 0  - normal way: use all patches from all images
        % clusteringMethod = 1  - use clusteringPatchesNumber patches only for clustering (randomly selected)
        % clusteringMethod = 2  - no clustering, just use clusteringPatchesNumber patches as cluster centres
        clusteringMethod=0;
        
        clusteringPatchesNumber=-1;
    end
    
    methods
        function obj=td_fastSelfSim()
        end
            
        % pixels is a cell array of images
        % the patches from all pixels in these images are being extracted 
        % and fed into kmeans to obtain a set of clusters
        function obj=getClustersFromPixels(obj,pixels)
            S=obj.scale;
            S2=obj.scale*2+1;
            
            if obj.clusteringMethod==0 || obj.clusteringMethod==1 || obj.clusteringMethod==2
                tocluster=[];
                for n=1:length(pixels)
                    f=pixels{n};
                    patches=td_imagepatcher(f,S);
                    tocluster=[tocluster , patches];
                    fprintf(1,'\n');
                end
                
                if obj.clusteringMethod==1
                    fprintf(1,'Reducing the number of patches to be clustered to %i\n',obj.clusteringPatchesNumber);
                    tocluster=tocluster(:,randi(size(tocluster,2),[1,obj.clusteringPatchesNumber]));
                end
            
                if obj.clusteringMethod==1 || obj.clusteringMethod==0
                    fprintf(1,'Starting kmeans to obtain %i clusters\n',obj.numberClusters);
                    obj.CX=vgg_kmeans(tocluster,obj.numberClusters);
                end
                
                if obj.clusteringMethod==2
                    fprintf(1,'Selecting %i random patches as cluster centres\n',obj.numberClusters);
                    obj.CX=tocluster(:,randi(size(tocluster,2),[1, obj.numberClusters]));
                end
            else
                error('unknown clustering method');
            end
            
        end

        
        function ssm=quantise(obj,I)
            % maytbe this can be sped up using convolutions
            ssm=td_imagepatchquantiser(I,obj.scale, obj.CX);
            
            % for debugging, we also have the direct implementation
            % ssm must be equal to ssm2
            %             patches=td_imagepatcher(I, obj.scale);
            %             ssm2=zeros(size(I,1),size(I,2));
            %             for y=1:size(I,1)
            %                 for x=1:size(I,2)
            %                     diff=obj.CX-repmat(patches(:,(y-1)*size(I,2)+x),[1 size(obj.CX,2)]);
            %                     diff=diff.*diff;
            %                     diff=sum(diff);
            %                     [a ix]=min(diff);
            %                     ssm2(y,x)=ix;
            %                 end
            %             end
        end
        

        % call this function with 
        % obj                  = td_fastSelfSim object with prototypes computed
        % M                    = prototype assignment map
        % xmin,ymin,xmax,ymax  = specification of a bounding box (scalar integers). If not specified: entire image
        function SSH=getOneSSH(obj,M,xmin,ymin,xmax,ymax)
        
            %%% TODO... here not yet ready
            
            if nargin==6
                % if coordinates were specified crop the prototype assignment map to the coordinates
                M=M(ymin:ymax,xmin:xmax);
            end
            
            if nargin==2 || nargin==6
                [H W]=size(M);
                stepsH=linspace(1,H+1,obj.D1+1); 
                stepsW=linspace(1,W+1,obj.D2+1);
%                 stepsH=linspace(1,H+1,H+1); 
%                 stepsW=linspace(1,W+1,W+1);
                winsize=(stepsH(2)-stepsH(1))*(stepsW(2)-stepsW(1));
                SSH=zeros(obj.D1,obj.D2,obj.D1,obj.D2);
%                 SSH=zeros(obj.D1,obj.D2,H,W);
                for idx=unique(rowvec(M))
                    ssm=(M==idx);
                    ssmm=td_mapToSize(ssm,obj.D1,obj.D2);
                    [rows cols]=find(ssm);
                    for n=1:length(rows)
                        r=rows(n); c=cols(n);
                        in=find(stepsH>r,1,'first')-1;
                        jn=find(stepsW>c,1,'first')-1;
                        SSH(:,:,in,jn)=SSH(:,:,in,jn)+ssmm;
                    end
                end
    
                SSH=SSH/numel(M);
            else
                error('either specify all coordinates of the bounding box or none')
            end
        end
        
        
        % call this function with
        % obj                  = td_fastSelfSim object with prototypes computed
        % M                    = prototype assignment map
        % xmin,ymin,xmax,ymax  = specification of n bounding box (vectors of length n).
        function SSHs=getManySSH(obj,M,xmin,ymin,xmax,ymax)
            if nargin ~= 6
                error('need to specify all parameters')
            end
            
            H=size(M,1);
            W=size(M,2);
            
            M=M+1;
            words=unique(rowvec(M));

            % get binary correlation surfaces for every word
            ssms=zeros(H,W,length(words));
            for w=words
                ssms(:,:,w)=(M==w);
            end
            
            % create the full resolution SS tensor
            SST=zeros(H,W,H,W);
            for j=1:H
                for i=1:W
                    w=M(j,i);
                    SST(:,:,j,i)=SST(:,:,j,i)+ssms(:,:,w);
                end
            end
            
            % get the integral structure
            SST=cumsum(SST,4);  % four individual cumsums is much faster than cumsum(cumsum(cumsum(cumsum(SSH,4),3),2),1)
            SST=cumsum(SST,3);  % due to temporal objects or something else with memory handling
            SST=cumsum(SST,2);
            SST=cumsum(SST,1);
            
            SSHs=cell(1,length(xmin));
            for n=1:length(xmin)
                bb=[xmin(n) ymin(n) xmax(n) ymax(n)];
                SSHs{n}=td_ssMxGetDescriptor(SST,obj.D1, obj.D2, bb);
            end
        end
            
    end
end
