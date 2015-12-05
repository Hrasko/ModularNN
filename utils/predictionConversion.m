function [ nIN nOUT in out] = predictionConversion( db,nIN,delta )
%PREDICTIONCONVERSION Summary of this function goes here
%   Detailed explanation goes here
nOUT = 1;

sizeDB = size(db,1);
n = sizeDB - (nIN*delta);

full = zeros(n,nIN+1);

for i=1:nIN+1
   t = 1 + (delta*(i-1));
   full(:,i) = db(t:n+t-1);
end
in = full(:,1:nIN);
out = full(:,nIN+1);

end

