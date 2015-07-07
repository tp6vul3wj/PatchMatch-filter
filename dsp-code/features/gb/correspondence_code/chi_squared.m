function dist = chi_squared( x, c )
%CHI_SQUARED Summary of this function goes here
%   Detailed explanation goes here
[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
end

dist = zeros(ndata, ncentres);
for i = 1 : ndata
    for j = 1 : ncentres
        tmp = sum((x(i, :)-c(j, :)).^2 ./ (x(i, :)+c(j, :)+0.000001));
        dist(i, j) = tmp/2;
    end
end

end

