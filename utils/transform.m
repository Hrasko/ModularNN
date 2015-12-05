function Vout = transform(Vin)
    [m n] = size(Vin);
    Vout = zeros (m,n);
    maior = 0;
    
    for j=1:n              
       for i=1:m
            if (Vin(i,j) >= maior)
                maior = Vin(i,j);
                pos = i;
            end
       end
       Vout(pos,j) = 1;
       maior = 0;
    end
    

end

