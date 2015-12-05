function [ output ] = sampleDBN( input,dnn,net)
%SAMPLEDBN Summary of this function goes here
%   Detailed explanation goes here
outDNN = v2h(dnn,input);
output = net(outDNN')';

end

