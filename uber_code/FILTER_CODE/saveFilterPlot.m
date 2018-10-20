%% saveFilterPlot

%% resize
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, .8, .8]);
%% save

plotNumStr = num2str(ceil(cellStep./(SP1.*SP2)));
totalPlotNumStr = num2str(ceil(length(U)./(SP1.*SP2)));

if saveON 
    filename = [saveDir, filesep, saveStringAddOn, ' ', 'Plot ' ,plotNumStr, 'of', totalPlotNumStr];
    saveas(gcf,filename,'png')
    savefig(filename)

end