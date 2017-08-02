swin = 50
perfthresh = .85
l=cat(1,o.trialResults);

figure(1);
clf
subplot(3,1,1);
title('Post-Reversal');
hold on
l1 = l(find(l(:,8)<14),:);
plot(smooth(l1(:,4),swin))
plot(smooth(l1(:,2),swin),'-','color',[.5 .5 .5])
plot([0 6000],[perfthresh perfthresh],'k:')
plot(find(l1(:,1)==1)*[1 1],[0 1],'b:')
set(gca,'ylim',[0 1],'xlim',[0 5000])

subplot(3,1,2);
hold on
l2 = l(find(l(:,8)>13&l(:,8)<28),:);
%plot(smooth(l(l(:,8)>8&l(:,8)<16,4),swin),'r')
plot(smooth(l2(:,4),swin),'r')
plot(smooth(l2(:,2),swin),'-','color',[.5 .5 .5])
plot([0 6000],[perfthresh perfthresh],'k:')
plot(find(l2(:,1)==1)*[1 1],[0 1],'r:')
set(gca,'ylim',[0 1],'xlim',[0 5000])
ylabel('Percent Correct (50 trial window)')

subplot(3,1,3)
l3 = l(find(l(:,8)>27),:);
hold on
plot([0 6000],[perfthresh perfthresh],'k:')
plot(smooth(l3(:,4),swin),'g')
plot(smooth(l3(:,2),swin),'-','color',[.5 .5 .5])
plot(find(l3(:,1)==1)*[1 1],[0 1],'g:')
set(gca,'ylim',[0 1],'xlim',[0 5000])
xlabel('Trials')