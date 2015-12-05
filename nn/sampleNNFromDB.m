function [ output in out ] = sampleNNFromDB( net,db,delay,delta )
%SAMPLEDBN Summary of this function goes here
%   Detailed explanation goes here

%Creating the delay 
[nIN nOUT in out] = predictionConversion(db,delay,delta);

%normalization
[in maxIN minIN] = normM(in);
[out maxOUT minOUT] = normM(out);

output = net(in')';

end

