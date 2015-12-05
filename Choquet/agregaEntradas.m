%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: André Pacheco
% Email: pacheco.comp@gmail.com
% Essa função agrega as entradas de acordo com a integral de choquet
% desejada
% 
% Entrada: 
%   G - vetor de com as densidades fuzzy
%   IN - uma matriz tridimensional contendo todas as entradas
%
% Saída:
%   OUT - vetor de agregação
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function OUT = agregaEntradas(G,IN)
    [m n] = size(IN);
    OUT = zeros(1,m);
    
    for i=1:m

        choq = choquet_integral (IN(i,:),G);
        OUT(i) = choq.valor;

    end

end

