function [h] = graphDBN(db,delay,delta)
    dnn = load('dnn.mat');
    net = load('net.mat');
    dnn = dnn.dnn;
    net = net.net;
    [nIN nOUT in out] = predictionConversion(db,round(delay),round(delta));
    [in maxIN minIN] = normM(in);
    [out maxOUT minOUT] = normM(out);
    
    full = [in out];
    unshuffled = full;
    
    
    
    % Size of the sampling
    num = size(full,1);

    %70% of the sampling
    num70 = round(num*0.7);
    
    
    INFull = full(:,1:nIN);
    INUnshuffled = unshuffled(:,1:nIN);
    OUTFull = full(:,nIN+1:nIN+nOUT);
    OUTUnshuffled = unshuffled(:,nIN+1:nIN+nOUT);

    INTrain = INFull(1:num70,:);
    OUTTrain = OUTFull(1:num70,:);
    INPrev = INFull(num70:num,:);
    OUTPrev = OUTFull(num70:num,:);

    IN = INTrain;
    OUT = OUTTrain;

    outDNN = v2h(dnn,INUnshuffled);
    % Result of the feedfowardnet given the result of the DBN
    outNet = net(outDNN')';

    %saving an image
    h = figure; 
    predOnly = size(OUTTrain,1):size(OUTFull,1);
    original = denormM(OUTUnshuffled,maxOUT,minOUT);
    outNet = denormM(outNet,maxOUT,minOUT);
    %plot(1:size(OUTTrain,1),original(1:size(OUTTrain,1)),'-',predOnly,original(predOnly),'r-',predOnly,outNet(predOnly),'g-');
    plot(predOnly,original(predOnly),'r-',predOnly,outNet(predOnly),'b--');
    legend('Comparison Data','NN Prediction');
    saveas(h,'bestPrediction','jpg');
end