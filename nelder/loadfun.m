%loadfun
% load optimizations problems with constraint
% 
% Output:
%
% ffunc : function handle for objetive function
% hfunc : function handle for constraint (equality)
% bh:   : parameter for satisfaction level (equality constraint)
% n     : dimension of problem
% Lim   : bounds of optimization problem [limInf; limSup]
%
% Input:
%
% cs    : number of optimizations problem in switch case
%
% Reference:
%   1~4: Una extension del m�todo de Nelder Mead a problemas de optimizaci�n no
%   lineales enteros mixtos
%       Ebert Brea
%
%   5~6: Nelder, J.A., Mead, R., A simplex method for function minimization, The
%   Computer Journal, vol. 13, p. 308
%
function [ffunc,n,Lim] = loadfun()
    ffunc = @ensembleCost;    
    n=6;
    limInf = 2*ones(1,n);
    limSup = 100*ones(1,n);
    Lim = [limInf; limSup];
end