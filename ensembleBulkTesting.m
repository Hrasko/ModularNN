clear ; close all; clc;

addpath(genpath(cd));

db = load('energy_aus.txt');
%db = x(:,3);


results = zeros(7,50);
for i=4:10
    pos = [9 11 i 100 50 20];
    for j=1:50
        results(i,j) = ensembleCost(pos,db);
    end
end

save('results.txt','results');


