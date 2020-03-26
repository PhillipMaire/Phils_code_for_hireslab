function  hp = squareTransparent(x, y, Transparency1, varargin)
if nargin >=4
    b = varargin{1};% extend y by this amount to cover what you need to cover
    [hl, hp] = boundedline(x, repmat((range(y)+min(y))./2, 2, 1), (range(y)./2)+b);
    
else
    [hl, hp] = boundedline(x, repmat((range(y)+min(y))./2, 2, 1), range(y)./2);
end
hp.FaceAlpha = Transparency1;
delete(hl);
%% shaded error bars doesnt work either 

%{

% y1 = ylim;
% x1 = Twin{k};
% p = fill([x1(1), x1(end), x1(end), x1(1)], [y1(1), y1(1), y1(2), y1(2)], 'r');
% set(p, 'EdgeColor', 'none', 'FaceColor', FcolResPeriod)


%}