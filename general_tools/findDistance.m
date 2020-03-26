%{

X = BLpoints;
Y = WSKpoints;
D = findDistance(X, Y) 

%}

function [D] = findDistance(X, Y)
D = nan(size(Y, 1), size(X, 1));
for k = 1:size(X, 1)
    D(:, k)  = sqrt((Y(:, 1)-X(k, 1)).^2 + (Y(:, 2)-X(k, 2)).^2);
end
end