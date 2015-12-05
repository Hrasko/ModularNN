function [errorOut dnn net]=dbnCost(pos,dbin,saveloc)
    
    delay = round(pos(1));
    delta = round(pos(2));
    
    nn1 = round(pos(3));
    nn2 = round(pos(4));

num = size(dbin,1);
numPrev = round(num*0.3);

dbPrev = dbin(numPrev:num,:);
db = dbin(1:numPrev,:);

%Creating the delay 
[nIN nOUT in out] = predictionConversion(db,delay,delta);
[nINPrev nOUTPrev inPrev outPrev] = predictionConversion(dbPrev,delay,delta);

%normalization
[in maxIN minIN] = normM(in);
[out maxOUT minOUT] = normM(out);

%normalization
[inPrev maxIN minIN] = normM(inPrev);
[outPrev maxOUT minOUT] = normM(outPrev);

% Matrix with all database. This is used for shuffleing
full = [in out];
fullPrev = [inPrev outPrev];

% Size of the sampling
num = size(full,1);
numPrev = size(fullPrev,1);

minDB = size(dbPrev,1);

%if num <= minDB
%    errorOut = 10000000;
%   return;
%end

%if num <= numPrev
%    errorOut = 10000000;
%    dnn = 0;
%    net = 0;
%   return;
%end
   
%if numPrev <= 0
%    errorOut = 10000000;
%    dnn = 0;
%    net = 0;
%   return;
%end


%shuffle
idx = randperm(num);
full = full(idx,:);

% Separating the data in more useful matrix
INTrain = full(:,1:nIN);
%INUnshuffled = unshuffled(:,1:nIN);
OUTTrain = full(:,nIN+1:nIN+nOUT);
INPrev = fullPrev(:,1:nIN);
OUTPrev = fullPrev(:,nIN+1:nIN+nOUT);

% run and save the data   
[errorOut dnn net] = runDBN(nn1,nn2,nIN,INTrain,OUTTrain,INPrev, OUTPrev);

nome1 = strcat(num2str(errorOut),'x',num2str(delay),'x',num2str(delta),'DNN.mat');
save(strcat(saveloc,nome1),'dnn');
nome2 = strcat(num2str(errorOut),'x',num2str(delay),'x',num2str(delta),'NET.mat');
save(strcat(saveloc,nome2),'net');

end