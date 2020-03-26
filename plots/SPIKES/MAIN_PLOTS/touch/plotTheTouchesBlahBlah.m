%%
% close all
smoothBy = 10;
subplotMakerNumber = 1; subplotMaker
set(0,'defaultAxesFontSize',10)
for cellStep = 1:length(U)
  
    subplotMakerNumber = 2; subplotMaker
    
    
    toPlotRet = toPlotAllTouch(cellStep, :, 2);
    toPlotRet(isnan(toPlotRet)) = 0;
    toPlotRet = smooth(toPlotRet, smoothBy);
    retPlot = plot(plotRange,toPlotRet, 'r');
    hold on
    retPlot.Color = [retPlot.Color, 1];
    
    
    toPlotPro = toPlotAllTouch(cellStep, :, 1);
    toPlotPro(isnan(toPlotPro)) = 0;
    toPlotPro = smooth(toPlotPro, smoothBy);
    proPlot = plot(plotRange,toPlotPro, 'b');
    proPlot.Color = [proPlot.Color, 1];
    
    axis tight
    xlim([plotRange(1) plotRange(end)])
    xlim([-100 100])
    %     keyboard
    tmpAXIS = gca;
        tmpAXIS.YLim(1) = 0 ;
        
end

 keyboard
saveLoc = ['C:\Users\maire\Documents\PLOTS\TOUCHES\'];

generalName = ['BOTH_30smooth_blockPoles'] ;
mkdir(saveLoc)

%
save([saveLoc, generalName, 'VAR'], 'allTouchRet', 'allTouchPro', 'toPlotRet', 'toPlotPro')
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);

filename =  [saveLoc, generalName];
saveas(gcf,filename,'png')
savefig(filename)
