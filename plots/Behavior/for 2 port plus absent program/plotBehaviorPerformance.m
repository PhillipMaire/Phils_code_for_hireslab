

%This script should be run after processBatchBehaviorFMR.
%GET PLOTTED


swin = 50 ; %Sliding Window
perfthresh = .85 ; %Performance threshold
l=cat(1,o.trialResults); %Linearize. 

%%%Added these so that changing the numbers manually wouldn't have to occur
%%%anywhere. Just don't clear anything from the previous script. 
for i = 1:numberOfMice
    clear var2
    clear endSessionTrial
    endSessionTrial(1)=0;

figHandle = strcat('h',num2str(i));
figHandle =figure(i);
clf
figName = strcat(uniqueMouseNames{i}, ' Behavioral Performance');
set(figHandle,'name',figName,'numbertitle','off');


if i == 1
l1 = l(find(l(:,17)<=endInd(i)),:);
var2 = 1:endInd(i);
else
l1 = l(find(l(:,17)<=endInd(i) & l(:,17)>endInd(i-1)),:);
var2 = endInd(i-1)+1:endInd(i);
end

for ii = var2
    kk = ii - var2(1)+1;
endSessionTrial(kk) = length(l(find(l(:,17)==ii),:))+endSessionTrial(end);
end
endSessionTrial = endSessionTrial(1:end);

hSubPlot1=subplot(2,1,1);
title('Percent Correct Trials');
hold on

hSubPlot1Position = get(hSubPlot1, 'position');
hSubPlot1Position(1) = hSubPlot1Position(1) - 0.05;
set(hSubPlot1, 'position',hSubPlot1Position);

plot(smooth(l1(:,7)+l1(:,8),swin),'-', 'color', 'k')%all correct
plot(smooth(l1(:,9),swin),'-','color', 'r')%all R correct
plot(smooth(l1(:,11),swin),'-','color', 'b')%all L correct
% plot(smooth(l1(:,7),swin),':','color', 'g')%all L&R correct
plot(smooth(l1(:,8),swin),'-','color', 'g')%all absent correct
plot(smooth(l1(:,5),swin),'-','color', 'm')%all absent correct

for ii = 1:length(var2)
plot([endSessionTrial(ii) endSessionTrial(ii)],[0 1],':','color', [0.5 0.5 0.5])
end

% Leg1=legend({'All','L&R','Abs'},'FontSize',8,'position', [.94,.948,.001,.001]);
Leg1=legend({'All','R','L','Abs','miss'},'FontSize',8,'position', [.92,.842,.001,.001]);
set(gca,'ylim',[0 1],'xlim',[0 inf])
set(gca,'YTick', 0:.25:1);


hSubPlot2=subplot(2,1,2);
title('Percent of Trial Types');
hold on

hSubPlot2Position = get(hSubPlot2, 'position');
hSubPlot2Position(1) = hSubPlot2Position(1) - 0.05;
set(hSubPlot2, 'position',hSubPlot2Position);

plot(smooth(l1(:,2),swin),'-','color', 'r')%all right trials
plot(smooth(l1(:,3),swin),'-','color', 'b')%all left trials
plot(smooth(l1(:,4),swin),'-','color', 'g')%all absent trials

for ii = 1:length(var2)
plot([endSessionTrial(ii) endSessionTrial(ii)],[0 1],':','color', [0.5 0.5 0.5])
end

Leg2=legend({'R','L','Abs'},'FontSize',8,'position', [.92,.842/2,.001,.001]);
set(gca,'ylim',[0 1],'xlim',[0 inf])
set(gca,'YTick', 0:.25:1);

%%%%%%used to set the width of the legend lines but is no uyses unless we
%%%%%%can move the test as well
%linesInPlot = findobj('type','line'); % linesInPlot(2) is the handle to that line
% legLines = [2 4 6 11 13 15];
% for ii = legLines
% set(linesInPlot(ii),'XData',[0.1231 0.4]) % so that new length < 0.5*previous
% end


%2 4 6
clear l1
end

% 1 'Trial number', 
% 2 'R_trials', 
% 3 'L_trials', 
% 4 'Abs_trials', 
% 5 'L_or_R_miss',...
% 6 'All_incorrect', 
% 7 'L_or_R_hit', 
% 8 'Abs_corrRej', 
% 9 'R_hits', 
% 10'R_incorr',...
% 11'L_hits', 
% 12'L_incorr', 
% 13'Abs_corrRej', 
% 14'Abs_incorr'
% 15......
% 16......going to be Dprime when ready
% 17'session number'

