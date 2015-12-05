% Pode ser passado como parâmetro vários vetores de dados e o nome do 
% arquivo (obrigatório), sendo que o último parâmetro sempre deverá ser
% o nome do arquivo a ser escrito

% escreve (vetor1,...,vetorn,nomeArq)

function escreve(varargin)
    nParam = nargin;
    nVecs = nParam-1;
    nomeArq = varargin{nParam};    
    % abrindo o arquivo
    arq = fopen (nomeArq,'w');
    
    for i=1:nVecs
        vec = varargin{i};
        [linha coluna] = size (vec);
        fprintf (arq,'Escrevendo os dados do parametro_%d que é um array [%d %d]:\n',i,linha,coluna);
        
        for m=1:linha
            for n=1:coluna
                fprintf (arq,'%f ',vec(m,n));
            end% for n
            fprintf (arq,'\n');
        end %for m
        fprintf (arq,'################################################################\n\n');   
    end %for i       

    %fechando o arquivo
    fclose(arq);    
end %escreve

