function [errorOut, ensemble, net]=ensembleCost(pos,db)
   % db = load('energy_aus.txt');
    delay = round(pos(1));
    delta = round(pos(2));
    k = round(pos(3));
    nn1 = round(pos(4));
    nn2 = round(pos(5));
    nn3 = round(pos(6));
    
fprintf('testing %i delta %i k %i nn %i,%i,%i\n',delay,delta,k,nn1,nn2,nn3);

%Creating the delay 
[nIN nOUT in out] = predictionConversion(db,delay,delta);

%normalization
[in maxIN minIN] = normM(in);
[out maxOUT minOUT] = normM(out);

% Matrix with all database. This is used for shuffleing
full = [in out];

% Size of the sampling
num = size(full,1);

%70% of the sampling
num70 = round(num*0.7);

ensemble = {};
%ensemble.delay = delay;
%ensemble.delta = delta;
%ensemble.k = k;
%ensemble.name = DataHash(strcat(num2str(delay),'x',num2str(delta),'x',num2str(k),'x',num2str(nn1),'x',num2str(nn2),'x',num2str(nn3)));
minDB = size(db,1)*0.1;
if num <= minDB
    errorOut = 10000000;
   return;
end
   
if (num-num70) <= minDB
    errorOut = 10000000;
   return;
end

%shuffle
idx = randperm(num);
full = full(idx,:);

% Separating the data in more useful matrix
INFull = full(:,1:nIN);
%INUnshuffled = unshuffled(:,1:nIN);
OUTFull = full(:,nIN+1:nIN+nOUT);
%OUTUnshuffled = unshuffled(:,nIN+1:nIN+nOUT);
IN = INFull(1:num70,:);
OUT = OUTFull(1:num70,:);
INPrev = INFull(num70:num,:);
OUTPrev = OUTFull(num70:num,:);


fprintf('preparing clusters delay %i delta %i k %i nn %i,%i,%i\n',delay,delta,k,nn1,nn2,nn3);

if (size(IN,1) < k)
    errorOut = 10000000;
   return;
end

c = kmeans(IN,k);

for i = 1:k
   fprintf('initializing dbn n %i \n',i);
   aux = c == i;

   n = sum(aux);
   auxIN = ones(n,size(IN,2));
   auxOUT = ones(n,size(OUT,2));

   index = 1;
   for j = 1:size(OUT,1)
      if aux(j) > 0
          auxIN(index,:) = IN(j,:);
          auxOUT(index,:) = OUT(j,:);
          index = index + 1;
      end
   end   
   
   num = size(IN,1);

    % DBN node information. 
    % nn is the number of neurons in the feedfoward layer
    nodes = [nIN nn1 nn2];
        
    %DBN initiation
    dnn = randDBN( nodes, 'GBDBN' );
    %nrbm = numel(dnn.rbm);
    opts.MaxIter = 1000;
    opts.BatchSize = round(num/4);
    opts.Verbose = false;
    opts.StepRatio = 0.01;    
    opts.DropOutRate = 0.5;
    opts.Object = 'Square';

    %Training the DBN layers
    dnn = pretrainDBN(dnn, auxIN, opts);
    
    %Sampling the DBN result
    outDNN = v2h(dnn,auxIN);
    
    %FeedFoward trainign with Backpropagation
    net = feedforwardnet(nn2);    
    net = configure(net,outDNN',auxOUT');
    net.trainParam.showWindow=0;
    net = train(net,outDNN',auxOUT');
    ensemble{i}.dnn = dnn;
    ensemble{i}.net = net;
    if i==1
        ensemble{i}.in = IN;
        ensemble{i}.out = OUT;
        ensemble{i}.maxIN = maxIN;
        ensemble{i}.maxOUT = maxOUT;
        ensemble{i}.minIN = minIN;
        ensemble{i}.minOUT = minOUT;
        ensemble{i}.inPrev = INPrev;
        ensemble{i}.outPrev = OUTPrev;
    end
    %save(strcat(ensemble.name,'x',num2str(i),'dnn.mat'),'dnn');
    %save(strcat(ensemble.name,'x',num2str(i),'net.mat'),'net');
end

fprintf('training aggregator \n');
s = ensembleSample(ensemble,IN);
agNet = feedforwardnet(nn3); 
agNet = configure(agNet,s,OUT');
agNet.trainParam.showWindow=0;
agNet = train(agNet,s,OUT');
s = ensembleSample(ensemble,INPrev);
outNet = agNet(s);

errorOut = amse(OUTPrev, outNet');

fprintf('error: %f \n',errorOut);

myname = strcat(num2str(errorOut),'x',num2str(delay),'x',num2str(delta),'x',num2str(k),'x',num2str(nn1),'x',num2str(nn2),'x',num2str(nn3));

save(strcat(myname,'xEnsemble.mat'),'ensemble');
save(strcat(myname,'xagNet.mat'),'agNet');

end