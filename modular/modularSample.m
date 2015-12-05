function [ sampled ] = modularSample( modularNN,INSample )
%MODULARSAMPLE Summary of this function goes here
%   Detailed explanation goes here

n = numel(modularNN);

sampled = zeros(n,size(INSample,1));

for i = 1:n
    %dnn = load(strcat(ensemble.name,'x',num2str(i),'dnn.mat'));
    %dnn = dnn.dnn;
    %net = load(strcat(ensemble.name,'x',num2str(i),'net.mat'));
    %net = net.net;
    
    delay = modularNN{i}.delay;
    delta = modularNN{i}.delta;
    
    [nIN nOUT in out] = predictionConversion(INSample,delay,delta);

    %normalization
    [in maxIN minIN] = normM(in);
    
    x = v2h(modularNN{i}.dnn,in);
    sampled(i,:) = modularNN{i}.net(x');
end

end

