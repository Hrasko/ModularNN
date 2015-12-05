% Função que calcula o erro quadrático médio

function erro = eqm(yRede,yReal)

[n N] = size (yRede);
erro = sum((yReal-yRede).^2)/N;

end

