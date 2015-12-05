clear ; close all; clc;

restrictions = [2 60;1 15;2 10; 10 200;10 100;10 100];

x = load('ibex35.txt');
db = x(:,3);

[gBest,bestPos] = pso([50 50 6 1.49445 1.49445 0.729],restrictions,@ensembleCost,db);

display(gBest);
display(bestPos);