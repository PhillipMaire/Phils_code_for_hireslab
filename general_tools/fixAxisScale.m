%% fix shit axis scaling
%% fixAxisScale 
axis tight
tmpFig1808271922 = gcf;
% data_1808271922 = tmpFig1808271922.Children.Children;
% data_1808271922(1);

modFactor_1808271922 = 0.05;



set1_1808271922 = [tmpFig1808271922.CurrentAxes.XLim, tmpFig1808271922.CurrentAxes.YLim];
set2_1808271922 = set1_1808271922;

set1_1808271922 = set1_1808271922 + abs(set1_1808271922).*(modFactor_1808271922);
set2_1808271922 = set2_1808271922 - abs(set2_1808271922).*(modFactor_1808271922);

tmpFig1808271922.CurrentAxes.XLim = [set2_1808271922(1) set1_1808271922(2)];
tmpFig1808271922.CurrentAxes.YLim = [set2_1808271922(3) set1_1808271922(4)];


