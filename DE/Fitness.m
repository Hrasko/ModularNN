% Fun��o que avalia a fitness da popula��o do DE

function fit = Fitness(G,IN)
      
    OUT = agregaEntradas (G,IN.C);    
    fit = contErros(IN.result, OUT);
    
end

