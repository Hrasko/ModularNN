function [ aqe dev ] = predictionErrorNN( net,IN,OUT )
%PREDICTIONERROR Summary of this function goes here
%   Detailed explanation goes here
out = net(IN);
[aqe dev] = amse(OUT,out);

end

