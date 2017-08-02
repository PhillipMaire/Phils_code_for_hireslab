%Outputs linearized version of o along with a plot of behavior

function [selectedB]=behav_smoothBehaviorWindow(o,swin)
%o = all behavioral sessions from one mouse from behav_processBehaviorv2

if nargin < 2
    swin = 100; %default smoothing window = 100
end 

perfthresh = .75; %threshold for performance

linearize=cat(1,o.trialResults); %linearize all behavioral sessions
uno=find(linearize(:,7)==1);selected=(linearize(uno,:)); %select only trials that are within trimmed areas
tmp = size(linearize);

    figure(5);clf;plot(smooth(selected(:,4),swin,'moving'));
    hold on; plot(smooth(linearize(:,2),swin),'-','color',[.5 .5 .5]) %plots distribution of go trials presented 
    hold on; plot(find(linearize(:,9)==1)*[1 1],[0 1],'b:')%plot the session markers 
    hold on; plot([0 tmp(1)],[perfthresh perfthresh],'k:')
    hold on; set(gca,'ylim',[0 1],'xlim',[0 tmp(1)])
    ylabel('Behavioral Accuracy')
    xlabel('Total Number of Trials')

    figure(6);clf;plot(smooth(selected(:,6),swin,'moving'));
    hold on; plot(smooth(linearize(:,2),swin),'-','color',[.5 .5 .5]) %plots distribution of go trials presented 
    hold on; plot(find(linearize(:,9)==1)*[1 1],[0 3],'k:')%plot the session markers 
    hold on; set(gca,'ylim',[0 3],'xlim',[0 tmp(1)])
    ylabel('DPrime')
    xlabel('Total Number of Trials')




selectedB = selected;