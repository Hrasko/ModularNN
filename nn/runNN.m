function [errorOut net] = runDBN(nn1,nn2,nIN,INTrain,OUTTrain,INPrev, OUTPrev)

%num = size(INTrain,1);

% DBN node information. 
% nn is the number of neurons in the feedfoward layer
%nodes = [nIN nn1 nn2];
    
    IN = INTrain;
    OUT = OUTTrain;
    
    %DBN initiation
    %dnn = randDBN( nodes, 'GBDBN' );
    %nrbm = numel(dnn.rbm);
    %opts.MaxIter = 1000;
    %opts.BatchSize = round(num/4);
    %opts.Verbose = false;
    %opts.StepRatio = 0.01;    
    %opts.DropOutRate = 0.5;
    %opts.Object = 'Square';

    %Training the DBN layers
    %dnn = pretrainDBN(dnn, IN, opts);
    
    %Sampling the DBN result
    %outDNN = v2h(dnn,IN);
    
    %FeedFoward trainign with Backpropagation
    if nn2 > 0
        net = feedforwardnet([nn1 nn2]);    
    else
        net = feedforwardnet(nn1);    
    end
    net = configure(net,IN',OUT');
    net.trainParam.showWindow=0;
    net = train(net,IN',OUT');
    
    [errorOut lixo] = predictionErrorNN (net,  INPrev', OUTPrev');    


end
