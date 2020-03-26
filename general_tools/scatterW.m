%%

function [h, h2] = scatterW(h)


[h2, FN] = copyPlot(h);

% if ~strcmpi(h.MarkerFaceColor, 'none')
h2.MarkerFaceColor = 'w';% always want the center to be white
h2.MarkerFaceAlpha = 1;
% end

if ~strcmpi(h.MarkerEdgeColor, 'none')
    h2.MarkerEdgeColor = 'w';
    h2.MarkerEdgeAlpha = 1;
end

[h3, FN] = copyPlot(h);

delete(h);
h = h3;