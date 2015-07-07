function [FB,oris] = make_fb( nori, aspect, scale, half_support)

% Demo code for matching roughly based on the procedure
% described in:
%
% "Shape Matching and Object Recognition using Low Distortion Correspondence"
% A. C. Berg, T. L. Berg, J. Malik
% CVPR 2005
%
% code Copyright 2005 Alex Berg
%
% questions -> Alex Berg aberg@cs.berkeley.edu


support = 2*half_support + 1;
sigma = scale;
FB = zeros(support,support,nori);

[X,Y] = meshgrid([1:10*support+1],[1:10*support+1]);
X = X - mean(X(:));
Y = Y - mean(Y(:));
R = sqrt(X.^2 + (aspect*Y).^2);
G = (1/(10*sigma*sqrt(2*pi)))*exp(-(R.^2)/(2*100*sigma^2));
G = G/sum(G(:));
[dx,dy]=gradient(G);
a_Odd = dy;
a_Even = imag(hilbert(a_Odd));
a_Even = a_Even - mean(a_Even(:));
a_Even = a_Even / sum(abs(a_Even(:)));
a_Odd = a_Odd - mean(a_Odd(:));
a_Odd = a_Odd / sum(abs(a_Odd(:)));
a_Odd = imresize(a_Odd,[support,support],'bilinear');
a_Even = imresize(a_Even,[support,support],'bilinear');
sigma = scale;
for i=1:nori,
  theta = (i-1)*180/nori;
  oris(2*i) = theta;
  oris(2*i-1) = theta;
  F = imrotate(a_Odd,theta,'bilinear','crop');
%  F = imresize(imrotate(a_Odd,theta,'bilinear','crop'), [support,support],'bilinear',3);
  F = F - mean(F(:));
  F = F / sum(abs(F(:)));
  FB(:,:,2*i-1)=  F;

  F = imrotate(a_Even,theta,'bilinear','crop');
%  F = imresize(imrotate(a_Odd,theta,'bilinear','crop'), [support,support],'bilinear',3);
  F = F - mean(F(:));
  F = F / sum(abs(F(:)));
  FB(:,:,2*i)=  F;
end



function x = hilbert(xr)
%     Matlab's hilbert function, some don't have this

if ~isreal(xr)
  xr = real(xr);
end
[xr,nshifts] = shiftdim(xr);
n = size(xr,1);
x = fft(xr,n,1); 
h  = zeros(n,~isempty(x)); 
if n>0 & 2*fix(n/2)==n
  h([1 n/2+1]) = 1;
  h(2:n/2) = 2;
elseif n>0
  h(1) = 1;
  h(2:(n+1)/2) = 2;
end
x = ifft(x.*h(:,ones(1,size(x,2))));

x = shiftdim(x,-nshifts);

