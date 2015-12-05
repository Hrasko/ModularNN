clear;clc;

datas;

resultados = [];
best = 1000000;
bestDelay = 1;
bestDelta = 1;
contador = 0;
intervalo = 8;
atraso = 3;
%for intervalo = 1:8
%     for atraso = intervalo+4:intervalo+10
      contador = contador+1;
        pos = [intervalo atraso];

maxInt = 1;
erros = 1:maxInt;
db = dlmread ('energy_aus.txt');
for iteraction = 1:maxInt
    
    [erros(iteraction) dnn net]=dbnCost(pos,db);
    
end

eb = 0;%sum(erroBaseInteira)/size(erroBaseInteira,2);
ep = sum(erros);%/size(erroBasePrev,2);

resultados(contador) = (eb+ep);

if (resultados(contador) < best)
   best = eb+ep;
   bestDelta = intervalo;
   bestDelay = atraso;
end

dlmwrite('resultados.txt',resultados);
dlmwrite('erros.txt',erros);


%     end
%end
