function [xopt, n_feval, best] = runNelder(cs)
    [ffunc,n,Lim] = loadfun();
    limInf = Lim(2,:);
    limSup = Lim(1,:);
    
    x=zeros(n+1,n);
    j=0;
    for i=1:n+1
        j=j+1;
        if j==n
            j=1;
        end
        x(i,:) = ceil(limInf(1,j) + rand(1,n)*(limSup(1,j)-limInf(1,j)));
    end
    %x = [0, 0; 1.2, 0; 0, .8];
    %x = round([0, 0; 1.2, 0; 0, .8]);
    %x = [-3 -3; 3 -3; 0 3];
    %x = [-2 -2; 2 -2; 0 2];
    %x = [-10 -10; 10 -10; 0 10];
    %x = [-5 -5; 5 -5; 0 5];
    
    %disp(x)
    %x = [...
    %    ceil(-10+rand(2,10)*(10-(-10))); ...
    %    randperm(n); ...
    %    randperm(n) ...
    %    ];
    [ xopt, n_feval, best ] = nelder_mead (x, ffunc, 0);
end