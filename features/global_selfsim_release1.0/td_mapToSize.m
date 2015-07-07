function outmap=td_mapToSize(inmap, s1, s2)

H=size(inmap,1);
W=size(inmap,2);


C=zeros(H+1, W+1); C(2:end, 2:end)=cumsum(cumsum(inmap,1),2);

stepsH=linspace(1,H+1,s1+1); stepsW=linspace(1,W+1,s2+1);

winsize=(stepsH(2)-stepsH(1))*(stepsW(2)-stepsW(1));

outmap=zeros(s1,s2);
for in=1:s1
    for jn=1:s2
        outmap(in,jn)=C(ceil(stepsH(in+1)), ceil(stepsW(jn+1))) ...
            -C(ceil(stepsH(in+1)),floor(stepsW(jn))) ...
            -C(floor(stepsH(in)),ceil(stepsW(jn+1))) ...
            +C(floor(stepsH(in)),floor(stepsW(jn)));
    end
end

%outmap=outmap/winsize;
