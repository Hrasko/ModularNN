clear ; close all; clc;

addpath(genpath(cd));
datas;

restrictions = [2 60;1 15;1 10; 10 200;10 100;10 100];

db = dolar_to_libra;

ensembleChoquetCost([24 7 3 169 71 20],db);

% [gBest,bestPos] = pso([50 50 6 1.49445 1.49445 0.729],restrictions,@ensembleChoquetCost,db);

display(gBest);
display(bestPos);