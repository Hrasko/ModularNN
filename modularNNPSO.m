clear ; close all; clc;

addpath(genpath(cd));

restrictions = [2 30;1 10];

x = load('competition.txt');
db = x(:,2);

[gBest,bestPos] = pso([50 50 2 1.49445 1.49445 0.729],restrictions,@dbnCost,db);

display(gBest);
display(bestPos);