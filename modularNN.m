clear ; close all; clc;

addpath(genpath(cd));

%number of modules
k = 4;

listing = dir('0x*NN.mat');
sizeListing = size(listing,1);
list = ones(sizeListing)*100000000000000;
for i=1:sizeListing
   split = strsplit(listing(i).name,'x');
   try 
    list(i) = str2double(split(2));
   catch e
       display(strcat('found an error at ', listing(i).name));
   end
end

[s, sorted] = sort(list);

modNN = {};
sizes = ones(k,1)*100000000000000;

x = load('yearssn.txt');
db = x(:,2);

for i=1:k
    netname = listing(sorted(i)).name;
    net = load(netname);
    net = net.nn;
    netsave = strcat('net',num2str(i));
    save(netsave,'net');
    netsplit = strsplit(netname,'NN');   
    paramssplit = strsplit(netsplit{1},'x');
    delay = str2double(paramssplit(3));
    delta = str2double(paramssplit(4));
    
    num = size(db,1);
    numPrev = round(num*0.7);

    dbmod = db(numPrev:num,:);
    
    [modNN{i}.s, opt.in, opt.out] = sampleNNFromDB(net,dbmod,delay,delta);
    sizes(i) = size(modNN{i}.s,1);
end
% 
% 
% dnn1 = load('0.11073x14x1DNN.mat');
% dnn1 = dnn1.dnn;
% save('dnn1','dnn1');
% net1 = load('0.11073x14x1NET.mat');
% net1 = net1.net;
% save('net1','net1');
% 
% dnn2 = load('0.1896x2x2DNN.mat');
% dnn2 = dnn2.dnn;
% save('dnn2','dnn2');
% net2 = load('0.1896x2x2NET.mat');
% net2 = net2.net;
% save('net2','net2');
% 
% dnn3 = load('0.2025x2x3DNN.mat');
% dnn3 = dnn3.dnn;
% save('dnn3','dnn3');
% net3 = load('0.2025x2x3NET.mat');
% net3 = net3.net;
% save('net3','net3');
% 
% dnn4 = load('0.2094x8x5DNN.mat');
% dnn4 = dnn4.dnn;
% save('dnn4','dnn4');
% net4 = load('0.2094x8x5NET.mat');
% net4 = net4.net;
% save('net4','net4');

minSize = min(sizes);

opt.s1 = modNN{1}.s(1:minSize);
opt.s2 = modNN{2}.s(1:minSize);
opt.s3 = modNN{3}.s(1:minSize);
opt.s4 = modNN{4}.s(1:minSize);
opt.in = opt.in(1:minSize);
opt.out = opt.out(1:minSize);

dim = 4;
restrictions = zeros(dim,2);
for i = 1:dim
   restrictions(i,2) = 1; 
end

[errorOut,G] = pso([50 50 dim 1.49445 1.49445 0.729],restrictions,@fuzzyDensityCost,opt);

display(G);
display(errorOut);