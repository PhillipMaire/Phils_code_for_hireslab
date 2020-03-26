function [N,edges,bin, betweenEdgesTMP] =  histAuto(x, varargin)
[N,edges,bin] = histcounts(x(:), 'BinMethod', 'fd');
betweenEdgesTMP = (edges(1:end-1)+(diff(edges)./2))';
if nargin >=2 && strcmpi('off', varargin{1})
else
    bar(betweenEdgesTMP, N)
end
