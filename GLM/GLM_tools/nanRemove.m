function [x2, y2, D] = nanRemove(x, y)
y = y(:);
[xNANS, ~] = find(isnan(x));
[yNANS, ~] = find(isnan(y));
D.nanRows = unique([xNANS(:); yNANS(:)]);

D.keepRows = setdiff(1:size(x, 1), D.nanRows);

x2 = x(D.keepRows, :);
y2 = y(D.keepRows, :);