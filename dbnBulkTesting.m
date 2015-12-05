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
        pos = [params(1) params(2) 100 50 20];
        display(dbName);
        for j=1:50
            fprintf('%i',j);
            st1 = strcat(saveLoc,'dbn10050\');
           results(j) = dbnCost(pos,db,st1);
        end
        fprintf('\n');
        save(strcat(saveLoc,'dbn10050\resultsNN1'),'results');

        pos = [params(1) params(2) 100 30 20];
        for j=1:50
            fprintf('%i',j);
           results(j) = dbnCost(pos,db,strcat(saveLoc,'dbn1005030\'));
        end

        save(strcat(saveLoc,'dbn1005030\resultsNN2'),'results');
    end
    
% 

end
