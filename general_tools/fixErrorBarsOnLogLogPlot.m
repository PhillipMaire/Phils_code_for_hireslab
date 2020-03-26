function fixErrorBarsOnLogLogPlot(e2)
% log scale where error bars go negative are not plotted as you would expect. This just pushes those
% error bars to the limits of the plot to give a better idea of the actual data
e1={};
x1 = xlim;
y1 = ylim;
if ~iscell(e2)
    e1{1} = e2;
else
    e1 = e2;
end

for k = 1:length(e1)
    e = e1{k};
    
    
    e.YNegativeDelta(e.YNegativeDelta+ e.YData <0) = -(e.YData(e.YNegativeDelta+ e.YData <0))+y1(1);
    e.XNegativeDelta(e.XNegativeDelta+ e.XData <0) = -(e.XData(e.XNegativeDelta + e.XData <0))+x1(1);
    
    %     (-(e.XData(e.XNegativeDelta + e.XData <0))-x1)+e.XData(e.XNegativeDelta + e.XData <0)
end
xlim(x1);
ylim(y1);
