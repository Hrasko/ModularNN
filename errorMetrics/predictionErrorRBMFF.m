function [ aqe dev ] = predictionErrorRBMFF( dnn,net,IN,OUT )
%PREDICTIONERROR Summary of this function goes here
%   Detailed explanation goes here
outDNN = v2h(dnn,IN);
out = net(outDNN')';
[aqe dev] = amse(OUT,out);

end

