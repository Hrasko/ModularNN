function [h] = graphDBN(db,delay,delta)
    ensemble = load('ensemble.mat');
    net = load('netE.mat');
    ensemble = ensemble.ensemble;
    net = net.agNet;    

     s = ensembleSample(ensemble,ensemble{1}.inPrev);
%     agNet = feedforwardnet(nn3); 
%     agNet = configure(agNet,s,OUT');
%     agNet.trainParam.showWindow=0;
%     agNet = train(agNet,s,OUT');
%     s = ensembleSample(ensemble,INPrev);
%     outNet = agNet(s);
    outNet = net(s);
    
    %saving an image
    h = figure; 
    
    %original = denormM(ensemble{1}.outPrev,ensemble{1}.maxOUT,ensemble{1}.minOUT);
    %outNet = denormM(outNet,ensemble{1}.maxOUT,ensemble{1}.minOUT);
    original = ensemble{1}.outPrev;
    %plot(1:size(OUTTrain,1),original(1:size(OUTTrain,1)),'-',predOnly,original(predOnly),'r-',predOnly,outNet(predOnly),'g-');
    predOnly = 1:size(original);
    plot(predOnly,original,'r-',predOnly,outNet,'b--');
    legend('Comparison Data','NN Prediction');
    saveas(h,'bestPrediction','jpg');
    
    
    [nIN nOUT in out] = predictionConversion(db,round(delay),round(delta));

    %normalization
    [in maxIN minIN] = normM(in);
    [out maxOUT minOUT] = normM(out);
    
    full = [in out];

    % Size of the sampling
    num = size(full,1);

    %70% of the sampling
    num70 = round(num*0.7);
    
    % Separating the data in more useful matrix
    INFull = full(:,1:nIN);
    OUTFull = full(:,nIN+1:nIN+nOUT);
    INPrev = INFull(num70:num,:);
    OUTPrev = OUTFull(num70:num,:);
    
    
    s = ensembleSample(ensemble,INPrev);
    outNet = net(s);
    h2 = figure; 
    original = OUTPrev;
    predOnly = 1:size(original);
    plot(predOnly,original,'r-',predOnly,outNet,'b--');
    legend('Comparison Data','NN Prediction');
    saveas(h2,'bestPrediction2','jpg');
end