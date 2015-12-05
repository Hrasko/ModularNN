function [sampled]=ensembleSample(ensemble,INSample)
    

n = numel(ensemble);

sampled = zeros(n,size(INSample,1));

for i = 1:n
    %dnn = load(strcat(ensemble.name,'x',num2str(i),'dnn.mat'));
    %dnn = dnn.dnn;
    %net = load(strcat(ensemble.name,'x',num2str(i),'net.mat'));
    %net = net.net;
    x = v2h(ensemble{i}.dnn,INSample);
    sampled(i,:) = ensemble{i}.net(x');
end

end