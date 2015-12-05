function [ X_norm mu sigma] = normM( X )
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here

%(x-min)/max - min
% x * (max-min) + min
%n = m;

% for i=1:size(m,2)
%     aux = m(:,i);
%     mini = min(aux);
%     maxi = max(aux);
%     n(:,i) = (aux-mini)./(maxi - mini);
%     y = n(:,i) .* (maxi-mini) + mini;
%     n(:,i) = y;
% end
X_norm = X;
mu = zeros(1, size(X, 2));
sigma = zeros(1, size(X, 2));

for i = 1:size(X,2)
    mu(i) = mean(X(:,i));
    X_norm(:,i) = X_norm(:,i) - mu(i);
    sigma(i) = std(X_norm(:,i));
    X_norm(:,i) = X_norm(:,i) / sigma(i);
end