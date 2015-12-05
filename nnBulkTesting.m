clear ; close all; clc;

p = genpath(cd);
addpath(p);
strPath = strsplit(p,';');
for i=1:size(strPath,2)

    splitStrPath = strsplit(strPath{i},'\');
    
    if (size(splitStrPath,2) == 9 && strcmp(splitStrPath(7),'resultados'))
        dbName = splitStrPath{9};        
        saveLoc = strcat('resultados\3070\',dbName,'\');
        x = load(strcat(dbName,'db.txt'));
        params = load(strcat(dbName,'params.txt'));
        if size(x,2) > 1
            db = x(:,size(x,2));
        else
            db = x;
        end

        results = zeros(1,50);
        pos = [params(1) params(2) 100 0 20];
        display(dbName);
        for j=1:50
            fprintf('%i',j);
           results(j) = nnCost(pos,db,strcat(saveLoc,'nn100\'));
        end
        fprintf('\n');
        save(strcat(saveLoc,'nn100\resultsNN1'),'results');

        pos = [params(1) params(2) 100 50 20];
        for j=1:50
            fprintf('%i',j);
           results(j) = nnCost(pos,db,strcat(saveLoc,'nn10050\'));
        end

        save(strcat(saveLoc,'nn10050\resultsNN2'),'results');
    end
    
% 

end

dbnBulkTesting;
