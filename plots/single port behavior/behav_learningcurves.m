function behav_learningcurves(mousel,param,varargin)


%% Plotting Raw Behavioral Data - This will provide the curves for each individual mouse. 
if nargin<1
    error('1st var behav sessions from owrapper, 2nd var = 4 for accuracy, 6 for dprime, Optional 3rd var for smooth window.')
end
if nargin<2
    error('input 4 for accuracy or 6 for dprime as second parameter')
end
if nargin>2
    swin=varargin{1};
else
    swin = 150;
end

perfthresh=.8;

%% Plot first behavioral plot so the for statement will plot the rest on same
%axis
figure(param);clf;plot(smooth(mousel{1}(:,param),swin,'moving'),'color',[.5 .5 .5]);

for k=2:length(mousel)
    if k ~=5
        hold on;plot(smooth(mousel{k}(:,param),swin,'moving'),'color',[.5 .5 .5]); % plot accuracy
        
        if param == 4 
            hold on; plot([0 max(cellfun('size', mousel, 1))],[perfthresh perfthresh],'k:')
            hold on; plot([0 max(cellfun('size', mousel, 1))],[.5 .5],'k')
            set(gca,'ylim',[0 1],'xlim',[0 max(cellfun('size', mousel, 1))])  
        elseif param == 6
            set(gca,'ylim',[0 4],'xlim',[0 max(cellfun('size', mousel, 1))]) 
        end
        %Plot dashed lined for go trial distribution
        %hold on; plot(smooth(mousel{k}(:,2),swin),'-','color',[.5 .5 .5])
        %Plotting trial markers
        %hold on; plot(find(mousel{k}(:,9)==1)*[1 1],[0 1],'b:')
    end
end

%% Plot average of mouse behavioral curves
avg=nan(numel(mousel),max(cellfun('size', mousel, 1)));%create nan

for L = 1:length(mousel)
    if L ~=5 %elim mouse 5 since we did reversal on it
    rows=size(mousel{L});
    avg(L,1:rows(1)) = mousel{L}(1:rows(1),param);
    end
end
avgall = nanmean(avg); %find average excluding nans

if param == 6
    for m=1:length(mousel)
        rows=size(mousel{m});
        for n=1:rows(1)
            if mousel{m}(n,6)== NaN
                mousel{m}(n,6)=nanmean([mousel{m}(n-1,6):mousel{m}(n+1,6)]);
            end
        end
    end
end


cibin=zeros(2,length(avg)); %doing 95% ci of each bin 
    for i=1:length(avg);
        [phat, pci] = binofit(nansum(avg(:,i)),numel(avg(:,i))-sum(isnan(avg(:,i))));
        cibin([2 1],i) = pci;
    end
cibin(cibin<0) = 0;

plot(smooth(avgall,swin,'moving'),'color','r');
%hold on; plot(smooth(cibin(1,:),swin,'moving'),':k');   
%hold on; plot(smooth(cibin(2,:),swin,'moving'),':k'); 
hold on; set(gca,'xtick',[0:1000:5000],'xlim',[0 5000],'ylim',[.25 1],'ytick',[0.25:.25:1])
title('Behavioral Curves for Recorded Mice')

if param == 6
    ylabel('DPrime of Correct Trials');xlabel('Number of Trials')
elseif param ==4
    ylabel('Percent of Correct Trials');xlabel('Number of Trials')
end
