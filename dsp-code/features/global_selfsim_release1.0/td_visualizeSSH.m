function td_visualizeSSH(ssh)

figure()

D1=size(ssh,1);
D2=size(ssh,2);


sp=1;
for i=1:D1
    for j=1:D2
        subplot(D1,D2,sp);
        
        imagesc(ssh(:,:,i,j));
        axis off
        sp=sp+1;
    end
end
