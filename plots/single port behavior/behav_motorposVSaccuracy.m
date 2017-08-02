function behav_motorposVSaccuracy(mousel,varargin)
%function used for building both behavioral accuracy and lick probability
%based on normalized motor positions 

%% using o wrapped data, construct data matrix with req. var. and normalize positions with 0 as the go/nogo boundary
joint=cell(1,length(mousel)); 
%joint = data matrix
%1 = motor pos, 2 = corr hit, 3= furthest ant pos, 4 = nogo ant pos, 5
%incorr trials
for i =1:length(mousel)
    tmp=find(mousel{i}(:,8)==max(mousel{i}(:,8))); %take last session
    lastsesh=mousel{i}(tmp,:);%keep only last session
    moto=lastsesh(:,10);%motor positions
    corrhit=lastsesh(:,4);%correct trials
    incorrtrials=lastsesh(:,5);%incorrect trials
    antpos=lastsesh(:,11);
    noantpos=lastsesh(:,12);
    joint{i}=sortrows(horzcat(moto,corrhit,antpos,noantpos,incorrtrials),1);%sorted
end

%normalize positions with 0 as the go boundary
for i = 1:length(joint) %need to normalize by go and nogo as boundary wasn't right in the middle
    gos=find(joint{i}(:,1)>=joint{i}(1,3));
    nogos=find(joint{i}(:,1)<joint{i}(1,3));
        gotmp=joint{i}(gos,1)-joint{i}(1,3);%normalizing equation
            joint{i}(gos,1)=gotmp/(max(joint{i}(gos,1))-joint{i}(1,3));
        nogotmp=joint{i}(nogos,1)-joint{i}(1,4);
            joint{i}(nogos,1)=-(1+(nogotmp/(joint{i}(1,4)-joint{i}(1,3))));
    joint{i}(find(joint{i}(:,1)>= -1 & joint{i}(:,1)<=1)); %sometimes motor pos may not save data and so it comes out as 0, drop those pole pos that are out of range
end
%% PLOT BEHAVIORAL ACCURACY - below lick prob does the same thing pretty much
% goselreg=find(joint{2}(:,1)>=0);
% nogoselreg=find(joint{2}(:,1)<0);
% figure(13);clf;plot(joint{2}(goselreg,1),smooth(joint{2}(goselreg,2),100),'color',[.5 .5 .5]);
% hold on; plot(joint{2}(nogoselreg,1),smooth(joint{2}(nogoselreg,2),100),'color',[.5 .5 .5])
% 
% for i = 3:length(joint)
% goselreg=find(joint{i}(:,1)>=0);
% nogoselreg=find(joint{i}(:,1)<0);
% hold on; plot(joint{i}(goselreg,1),smooth(joint{i}(goselreg,2),100),'color',[.5 .5 .5]);
% hold on; plot(joint{i}(nogoselreg,1),smooth(joint{i}(nogoselreg,2),100),'color',[.5 .5 .5])
%     
% end
% 
% %population mean 
% conglo=cell(1,length(joint));
% for k=1:length(joint)
%     conglo{k}=binslin(joint{k}(:,1),joint{k}(:,2),'equalE',81,-1,1);
% end
% 
% indiv=nan(80,length(conglo));
% for i =2:length(conglo) %start from 2 since we don't want to include mouse 1 since it has full continuous range
%     indiv(:,i)=cellfun(@mean,conglo{i});
% end
% 
% totmean=nanmean(indiv,2);
% totmean(:,2)=linspace(-.975,.975,80);
% hold on; scatter(-1*ones(1,length(joint)-1),indiv(1,2:end));
% hold on;plot(totmean(41:end,2),smooth(totmean(41:end,1),10),'r')
% %hold on;plot(totmean(1:40,2),totmean(1:40,1),'r')
% scatter(-1,totmean(1,1));
% 
% set(gca,'xtick',[-1:.5:1],'ytick',[0:.25:1],'ylim',[0 1])
% xlabel('Decision Boundary');ylabel('Accuracy')

%% PLOT LICKPROB

%separating out go analysis and nogo analysis because of blank inbetween. otherwise smoothing will be affected.
% goselreg=find(joint{2}(:,1)>=0); %find go trials
% nogoselreg=find(joint{2}(:,1)<0); %find no go trials; 
% golick=find(joint{2}(:,2)==1); %hit trials = correct trials in goselreg
% falick=find(joint{2}(:,5)==1); %false alarm = incorrect trials and nogoselreg
% figure(14);clf;plot(joint{2}(goselreg,1),smooth(joint{2}(goselreg,2),100),'color',[.5 .5 .5]);
% hold on; plot(joint{2}(nogoselreg,1),smooth(joint{2}(nogoselreg,2),100),'color',[.5 .5 .5])

conglo=cell(1,length(joint)); %bin by motor positions
for k=1:length(joint)
    conglo{k}=binslin(joint{k}(:,1),joint{k}(:,[2 5]),'equalE',11,-1,1);
end

prob=nan(length(conglo{1}),length(conglo));
perim=size(prob);
range=linspace(-1,1,11);
for m = 1:length(conglo)
    for k = 1:length(conglo{1})
        if k<=length(conglo{1})/2 %since normalized, separate go/nogo by dividing in middle
            prob(k,m)= numel(find(conglo{m}{k}(:,2)==1))/length(conglo{m}{k});
        else prob(k,m) = numel(find(conglo{m}{k}(:,1)==1))/length(conglo{m}{k});
        end
    end
end

if varargin{1}=='cont'
    %for continuous
    figure(14);clf;
    plot(prob,'k'); hold on;plot(mean(prob,2),'r','linewidth',4)
    plot(prob,'ko-')
    plot([5.5 5.5],[0 1],'k:')
    set(gca,'xlim',[1 10],'xtick',[1 5.5 10],'xticklabel',{-1 0 1},'ytick',[0:.25:1],'ylim',[0 1])
    xlabel('Decision Boundary');ylabel('Lick Probability')
    title('Expert Session Full Continuous')
    
    figure(15);clf;
    plot(diff(prob),'k'); hold on
    plot(mean(diff(prob),2),'ro-','linewidth',4)
    plot([1 9],[0 0 ],'k:')
    ylabel('% Change in Lick Prob'); xlabel('Normalized Motor Positions')
    
    
else
    %for semi-continuous
    figure(14);clf;plot(range(length(range)/2+1:end),smooth(prob(41:end,2),20),'color',[.5 .5 .5])
    hold on; plot(range(1:length(range)/2),prob(1:40,2),'color',[.5 .5 .5]) %nogo end
    
    for p=3:perim(2)
        hold on; plot(range(length(range)/2+1:end),smooth(prob(41:end,p),20),'color',[.5 .5 .5])
        plot(range(1:length(range)/2),prob(1:40,p),'color',[.5 .5 .5])
    end
    %plotting population lick probability
    popprob=nanmean(prob(:,2:end),2);
    plot(range(length(range)/2+1:end),smooth(popprob(41:end,1),20),'r')
    plot(range(1:40),popprob(1:40,1),'r')
    set(gca,'xtick',[-1:.5:1],'ytick',[0:.25:1],'ylim',[0 1])
    xlabel('Decision Boundary');ylabel('Lick Probability')
    
end


