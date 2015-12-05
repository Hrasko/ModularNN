function [ X ] = denormM( X_norm,mu,sigma )
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here

%(x-min)/max - min
% x * (max-min) + min
% d = n;
% dif = maxi-mini;
% for i=1:size(n,2)
%     y = n(:,i);
%     d(:,i) = (y .* dif) + mini;
% end

X = X_norm;

for i = 1:size(X_norm,2)
    X(:,i) = X_norm(:,i) * sigma(i);
    X(:,i) = X(:,i) + mu(i);    
end