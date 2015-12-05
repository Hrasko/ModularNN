function [ errorOut dev ] = amse( pred,prev )
%EQM Summary of this function goes here
%   Detailed explanation goes here
e1 = pred-prev;
err = power(e1,2);
[n N] = size(err);
errorOut = sum(err)/n;
dev = std(e1/n);

end

