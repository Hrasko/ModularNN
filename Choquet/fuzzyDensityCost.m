function [ errorOut ] = fuzzyDensityCost( G, opt )
%FUZZYDENSITYCOST Summary of this function goes here
%   Detailed explanation goes here

s = [opt.s1 opt.s2 opt.s3 opt.s4];
try
    outNet = agregaEntradas (G',s);
    %error = opt.out - outNet';
    errorOut = amse(outNet',opt.out);
    %errorOut = sum(error.^2);
catch e
    errorOut = 1000000000;
end
end

