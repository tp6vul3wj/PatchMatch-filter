function [c,E]=get_tps_coeffs(X,Y,varargin);
% [c,E]=get_tps_coeffs(X,Y,beta=0);
% c are the coefficients for use with [output_points]=tps_it(c,X,input_points);
% if you do not use regularization (ie beta=0) then Y = tps_it(get_tps_coeffs(X,Y),X,X);
%

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




if (0==length(varargin))
  beta = 0;
else
  beta = varargin{1};
end


  
N=size(X,1);

if N~=size(Y,1);
   error('number of point in X and Y should be equal...')
end

r = ones(N,1)*sum(X'.^2) + sum(X'.^2)'*ones(1,N) - 2*X*X'; 
%LD=r.*log(r+eye(N))+beta*eye(N);
LD=r.*log(r+(r<eps))+beta*eye(N);
M = [ LD, X, ones(N,1) ; X' zeros(2,3)  ; ones(1,N) 0 0 0 ];

c = M'\[Y; zeros(3,2)];

if nargout>2
   % compute bending energy (w/o regularization)
   Q=c(1:N,:)'*(r.*log(r+eye(N)))*c(1:N,:);
   E=mean(diag(Q));
end



