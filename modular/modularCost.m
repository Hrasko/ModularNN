function [errorOut, modularNN, net]=modularCost(pos,db)
k = pos(1);
nn3 = pos(2);

modularNN = {};
%ensemble.delay = delay;
%ensemble.delta = delta;
%ensemble.k = k;
%ensemble.name = DataHash(strcat(num2str(delay),'x',num2str(delta),'x',num2str(k),'x',num2str(nn1),'x',num2str(nn2),'x',num2str(nn3)));

c = kmeans(db,k);



for i = 1:k
    
    fprintf('initializing dbn n %i \n',i);
    aux = c == i;

    n = sum(aux);
    auxIN = ones(n,size(db,2));

    index = 1;
    for j = 1:size(OUT,1)
      if aux(j) > 0
          auxIN(index,:) = IN(j,:);
          index = index + 1;
      end
    end
    
    restrictions = [2 60; 10 200;10 100];
    
    [gBest, bestFit] = pso([50 50 4 1.49445 1.49445 0.729],restrictions,@dbnCost,auxIN);
    delay = gBest(1);
    delta = 1;
    nn1 = gBest(2);
    nn2 = gBest(3);

    %Creating the delay 
    [nIN nOUT in out] = predictionConversion(auxIN,delay,delta);

    %normalization
    [in maxIN minIN] = normM(in);
    [out maxOUT minOUT] = normM(out);

    % Matrix with all database. This is used for shuffleing
    full = [in out];

    % Size of the sampling
    num = size(full,1);

    %70% of the sampling
    num70 = round(num*0.7);
    
    minDB = size(auxIN,1)*0.1;
    if num <= minDB
        errorOut = 10000000;
       return;
    end

    if (num-num70) <= minDB
        errorOut = 10000000;
       return;
    end
    
    % Separating the data in more useful matrix
    INFull = full(:,1:nIN);
    %INUnshuffled = unshuffled(:,1:nIN);
    OUTFull = full(:,nIN+1:nIN+nOUT);
    INPrev = INFull(num70:num,:);
    OUTPrev = OUTFull(num70:num,:);
    
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
    
    if (size(IN,1) < k)
       errorOut = 10000000;
       return;
    end

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
    
    modularNN{i}.dnn = dnn;
    modularNN{i}.net = net;
    modularNN{i}.in = IN;
    modularNN{i}.out = OUT;
    modularNN{i}.maxIN = maxIN;
    modularNN{i}.maxOUT = maxOUT;
    modularNN{i}.minIN = minIN;
    modularNN{i}.minOUT = minOUT;
    modularNN{i}.inPrev = INPrev;
    modularNN{i}.outPrev = OUTPrev;
    modularNN{i}.delay = delay;
    modularNN{i}.delta = delta;
    
    %save(strcat(ensemble.name,'x',num2str(i),'dnn.mat'),'dnn');
    %save(strcat(ensemble.name,'x',num2str(i),'net.mat'),'net');
end

fprintf('training aggregator \n');
s = modularSample(modularNN,IN);
agNet = feedforwardnet(nn3); 
agNet = configure(agNet,s,OUT');
agNet.trainParam.showWindow=0;
agNet = train(agNet,s,OUT');
s = modularSample(modularNN,INPrev);
outNet = agNet(s);
error = OUTPrev - outNet';

errorOut = sum(error.^2);

fprintf('error: %f \n',errorOut);

myname = strcat(num2str(errorOut),'x',num2str(delay),'x',num2str(delta),'x',num2str(k),'x',num2str(nn1),'x',num2str(nn2),'x',num2str(nn3));

save(strcat(myname,'xmodularNN.mat'),'modularNN');
save(strcat(myname,'xagNet.mat'),'agNet');

end