function [errorOut dnn net] = runDBN(nn1,nn2,nIN,INTrain,OUTTrain,INPrev, OUTPrev)

num = size(INTrain,1);

% DBN node information. 
% nn is the number of neurons in the feedfoward layer
if nn2 == 30
    nodes = [nIN nn1 nn1/2 nn2];
else
    nodes = [nIN nn1 nn2];
end
    
    IN = INTrain;
    OUT = OUTTrain;
    
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
    dnn = pretrainDBN(dnn, IN, opts);
    
    %Sampling the DBN result
    outDNN = v2h(dnn,IN);
    
    %FeedFoward trainign with Backpropagation
    net = feedforwardnet(nn2);    
    net = configure(net,outDNN',OUT');
    net.trainParam.showWindow=0;
    net = train(net,outDNN',OUT');
    
    [errorOut lixo] = predictionErrorRBMFF (dnn,net, INPrev, OUTPrev);    


end
