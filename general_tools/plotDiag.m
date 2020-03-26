function [out1] = plotDiag(varargin)
out1 = {};
if nargin >=1
    h = varargin{1};
else
    h = gcf;
end 

if nargin >=2
    
else
    plotLineNum = 1;
end

    if any(ismember(plotLineNum,1))
x1 = xlim;
y1 = ylim;
if strcmpi(h.CurrentAxes.XScale, 'log')
    x1(x1<0) = 0;
end
if strcmpi(h.CurrentAxes.YScale, 'log')
    y1(y1<0) = 0;
end
tmp1 = min(max([x1;y1]));
tmp2 = max(min([x1;y1]));
out1 = plot([tmp1 tmp2], [ tmp1 tmp2], '--k');
xlim(x1);
ylim(y1);
    elseif any(ismember(plotLineNum,2))
        
        
        
    elseif any(ismember(plotLineNum,3))
        
        plot([xlim', zeros(2, 1)], [zeros(2, 1), ylim'], 'k--')

    elseif any(ismember(plotLineNum,4))
        
    end