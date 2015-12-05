function [nIN nOUT] = shuffle(in,out)
    tam = length(in);
    pos = randperm(tam);

    for i=1:tam
        nIN(:,i) = in(:,pos(i));
        nOUT(:,i) = out(:,pos(i));
    end
end

