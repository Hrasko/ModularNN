function [ erro ] = eqm(yRede,yReal)

[n N] = size (yRede);
erro = sum((yReal-yRede).^2)/N;

end

