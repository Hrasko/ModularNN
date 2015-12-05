%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: André Pacheco
% Email: pacheco.comp@gmail.com
% Essa função calcula a integral de Choquet com respeito a medida fuzzy de
% sugeno. Portanto, é necessário conhecer as densidades fuzzy
% 
% Entrada: 
%   F - dados (f(x)): vetor (1xn)
%   G - desidade fuzzy (g): vetor (1xn)
%
% Saída:
%   choquet - Struct com os seguintes atributos
%       choquet.F = valores de F ordenados
%       choquet.G = valores de G referentes ao F já ordenado
%       choquet.lambdas = todos os valores de lambda encontrados
%       choquet.lambda = valor de lambda encolhido dentre os encontrados
%       choquet.A = valores das medidas fuzzy encontradas para o conjunto
%       choquet.valor = a integral de choquet calculada
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function choquet = choquet_integral(F,G)
    [nF mF] = size(F);
    [nG mG] = size(G);
    
    % Verificando se o padrão de entrada esta correto
    if (nF ~= nG)
        error ('O numero de colunas de F deve ser o mesmo de G');
    end
    %F = F';
    %G = G';
    % Ordenando o vetor F mas salvando os indices para vincular com g's
    [choquet.F indices] = sort(F);
    choquet.G = G;
    choquet = formatG (choquet, indices);
    
    % Calculando todos os lambdas para as densidades fuzzy em questão
    choquet.lambdas = calcLambdas (choquet);
    choquet = getLambda (choquet);
    choquet = getChoquetValue (choquet);
        
    
end % choquet_integral

% função que vai ajustar G de acordo com a ordenação de F ou seja, manter
% os as densidades fuzzy relacionadas com os ratings mesmo apos a ordenação
function choquet = formatG (choquet, indices)
    n = size(choquet.G,2);
    Gold = choquet.G;
    Gnew = zeros(1,n);
    
    for i=1:n
        Gnew(i) = Gold(indices(i));
    end % for
    
    choquet.G = Gnew;
end % formatG

% função que calcula o  produtorio a fim de descobrir os valores de lambda
function lambdas = calcLambdas (choquet)
    n = size(choquet.G,2);
    syms x a y;
        
    for i=1:n
        if i == 1
            x = (choquet.G(i)*a + 1);          
        else
            x = x * (choquet.G(i)*a + 1);          
        end % if        
    end % for
    
    y = x - 1;
    syms a;
    y = y - a;    
    
    %sym2poly (y)    
    lambdas = roots (sym2poly (y))';
    
end % calcLambda

% Função que une a medida fuzzy de dois conjuntos
function uniao = gAUB (gA,gB,lambda)
    uniao = gA + gB + (lambda*gA*gB);
end % gAUB

% Essa função calcula o lambda utilizando o DE
function lambdas = calcLambdasDE (choquet)
    n = size(choquet.G,2);    
    opt.tipo = 1;
    opt.intervalInit = [-10 10];
    result = DEvolution (n*10,n,opt);
    
    lambdas = result.bestInd.value;    
end %calcLambdasDE


% Função que preenche todos os g(Ai)
function GAs = calcGAs (choquet,lambda)
    n = size(choquet.G,2);    
    GAs = zeros (1,n);
    GAs(n) = choquet.G(n);
    n = n - 1;
        
    while (n >= 1)
        GAs(n) = gAUB(GAs(n+1),choquet.G(n),lambda);
        n = n - 1;
    end % while
end % calcGAs

% Função que calcula de fato a integral de choquet
function choquet = getChoquetValue (choquet)
    n = size(choquet.G,2);
    
    % Primeira iteração é fora pra não estourar os limites do vetor
    valor = choquet.F(1) * choquet.A(1);
    
    for i=2:n
        valor = valor + (choquet.F(i)-choquet.F(i-1))*choquet.A(i);
    end %for
    
    choquet.valor = valor;
    
end % calcChoquet

function choquet = getLambda (choquet)
    nL = size(choquet.lambdas,2);
    flag = 0;
    
    for i=1:nL
        lamb = choquet.lambdas(i);
        if (lamb < -1 || (lamb >= 0 && lamb <= 0.0001))
            flag = 1;                        
        end % if
        
        if (flag == 0)            
            GAs = calcGAs (choquet,lamb);
            n = size(GAs,2);
            
            if (GAs(1) ~= 1)
                flag = 1;
            end % if
            
            for k=2:n
                if (GAs(k) >= 1)
                    flag = 1;
                end % if
            end % for           
        end % if     
        
        if (flag == 0)
            break;
        end % if
        
        flag = 0;
        
    end % for
    
    choquet.lambda = lamb;
    choquet.A = GAs;
    
end % getLambda



