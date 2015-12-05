% Utilização: Entrada
%	dim = dimensão do problema
% 	nPop = tamanho da população
% 	nIter = numero de iterações
%
%	Saída:
%   melhor = o melhor resultado da minimização
%	pos_ = vetor n dimensional com as posições para o melhor resultado
%	todos_melhores = histórico com o melhor de todas as iterações
%
%	A função objetivo deve ser editada no outro arquivo que está nesta mesma pasta
%   com nome FuncaoObjetivo_1.m


function [melhor pos todos_melhores] = DE_1 (dim,nPop,nInt,IN)
	CR = 0.85;
    
    
	melhor = 1;
    pos = 0;
    todos_melhores = 0;
	%populacao = randi([0 10],nPop,dim);
    populacao = rand(nPop,dim+1);
	%todos_melhores = zeros(nInt,1);	
    
    if nInt > 1	
        for i=1:nInt	
            F = 0.5+0.3*randn();
            populacao_m = mutacao (populacao,dim,nPop,F);		
            populacao_r = recombinacao (populacao,populacao_m,nPop,dim,CR);
            populacao = selecao (populacao,populacao_r,nPop,dim,IN);
            [melhor pos] = melhores (populacao,nPop,dim);
            todos_melhores (i) = melhor;
            info = [i melhor]
            
        end %for
    else
        erro = nInt;
        i = 1;
        while melhor > erro
            F = 0.5+0.3*randn();
            populacao_m = mutacao (populacao,dim,nPop,F);		
            populacao_r = recombinacao (populacao,populacao_m,nPop,dim,CR);
            populacao = selecao (populacao,populacao_r,nPop,dim,IN);
            [melhor pos] = melhores (populacao,nPop,dim);
            todos_melhores (i) = melhor;
            info = [i melhor]
            
            i = i + 1;
            
            if i >= 8000
               break;
            end
            
        end
        
    end%for
	
    
    
	%plot(todos_melhores);
end %function

function [melhor pos] = melhores (populacao,nPop,dim)
	melhor = 99999; %inicializacao
	pos = 0;
	
	for i=1:nPop
		%m = simula (populacao(i,:));		
        %populacao(i,4) = fun��o de fitness pra economizar
		
		if (populacao(i,dim+1)<melhor)
			melhor = populacao(i,dim+1);
			pos = populacao(i,:);
		end%if		
	end %for
end %melhores

function populacao_g = selecao (populacao,populacao_r,nPop,dim,IN)
	pen = 1;
	populacao_g = zeros (nPop,dim+1);
	for i=1:nPop
        
		errom = fitness (populacao(i,1:dim),IN);		
		erromr = fitness (populacao_r(i,1:dim),IN);
		
		if (errom <= erromr)
			populacao_g(i,:) = populacao(i,:);
            populacao_g(i,dim+1) = errom;
		else
			populacao_g(i,:) = populacao_r(i,:);
            populacao_g(i,dim+1) = erromr;
		end%if
	end %for	
end %selecao



function populacao2 = recombinacao (populacao,populacao_m,nPop,dim,CR)
	populacao2 = zeros (nPop,dim+1);
	for i=1:nPop
		prob = rand();
		Irand = randi([1 dim]);
		if (prob <= CR | i == Irand)
			populacao2(i,:) = populacao_m(i,:);
		elseif (prob > CR & i ~= Irand) 		
			populacao2(i,:) = populacao(i,:);
		end%if
	end %for i	
end %recombinacao

function populacao2 = mutacao (populacao,dim,nPop,F)
	populacao2 = zeros (nPop,dim+1);
	for i=1:nPop	
		nAlet1 = randi([1 nPop]);
		nAlet2 = randi([1 nPop]);	
		for j=1:dim
			populacao2(i,j) = (populacao(i,j) + F*(populacao(nAlet1,j) - populacao(nAlet2,j)));
			% rever isso aqui
			if (populacao2(i,j) < 0 || populacao2(i,j) > 1)
				populacao2(i,j) = rand();
			end%if	
		end %for
	end %end i
end %mutacao




