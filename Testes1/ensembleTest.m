clear;clc;
addpath(genpath(cd));
datas;

resultados = [];
best = 1000000;
bestDelay = 1;
bestDelta = 1;
counter = 0;
delay = 8;
delta = 3;
k = 3;
%for intervalo = 1:8
%     for atraso = intervalo+4:intervalo+10
      counter = counter+1;
        pos = [delay delta k];

maxInt = 50;
errors = 1:maxInt;
db = dlmread ('energy_aus.txt');

for iteraction = 1:maxInt
    
    [err ensemble net]=ensembleCost(pos,db);
    errors(iteraction) = err;
end

%if (resultados(counter) < best)
%   best = resultados(counter);
%   bestDelta = delta;
%   bestDelay = delay;
%end

%dlmwrite('resultados.txt',resultados);
dlmwrite('erros.txt',erros);


%     end
%end