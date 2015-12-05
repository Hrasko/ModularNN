function erros = contErros(real, redeFull)
    rede = transform (redeFull);

    [m n] = size(real);
    dif = real - rede;   
    erros = 0;
    flag = 0;
    
    for j=1:n
        for i=1:m
            if dif(i,j) ~= 0
                flag = 1;
            end
        end
        if flag == 1
            erros = erros + 1;             
            j
        end
        flag = 0;
    end
end

