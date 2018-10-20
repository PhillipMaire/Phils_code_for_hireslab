%% plotting depth vs X

%% average spike rate
for k = 1:numel(U)
    prePole = -400;
    postPole = 250;
    [beforeSpikes, beforeInfo]=spikeRatePoleUp(U{k}, prePole);
    [afterSpikes, afterInfo]=spikeRatePoleUp(U{k}, postPole);
    
    
    allInfo.before{k}= beforeInfo;
    allInfo.after{k}= afterInfo;
end


for k = 1:numel(U)
    spkRateBefore(k) = allInfo.before{k}.meanSpikesPerSec;
    spkRateAfter(k) = allInfo.after{k}.meanSpikesPerSec;
    cellDepth(k) = U{k}.details.depth*-1
end
%%%%%%PLOTTING OPTION FOR ABOVE%%%%%%


%%

for k = 1:numel(U)
    figure(9)

    hold on
    if spkRateBefore(k)>spkRateAfter(k)
   line([spkRateBefore(k),spkRateAfter(k)], [cellDepth(k),cellDepth(k)],'color','red','lineWidth',2)
   scatter(spkRateAfter(k), cellDepth(k),30, 'r<','filled')
    else
        line([spkRateBefore(k),spkRateAfter(k)], [cellDepth(k),cellDepth(k)],'color','blue','lineWidth',2)
        scatter(spkRateAfter(k), cellDepth(k),30, 'b>','filled')
    end
%     set(gca, 'XScale', 'log')
    
end
 scatter(spkRateBefore, cellDepth,10, 'ko','filled')
hold off
%%
if 1 ==1 %%set 1 to plot ratioof modulation
    ratioVar = spkRateAfter./spkRateBefore;
    figure(10)
    scatter(ratioVar, cellDepth,90, 'k.')
   
end

test4 = smooth(ratioVar,3,'moving')
if 1==0
    figure(11)
% %    plot( 
end

%%
figure(22)
cdfplot(spkRateAfter)
hold on 
cdfplot(spkRateBefore)
hold off
%% 
figure(23)
scatter(spkRateBefore, spkRateAfter,600, '.k')
hold on 
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
hline = refline(1)
hline.Color = 'c';
grid on
xlabel('spikes/sec before pole onset') % x-axis label
ylabel('spikes/sec after pole onset') % y-axis label
title('Modulation of Firing Rate Pre Vs Post-Pole Onset')
xlim([0 200]) 
ylim([0 200])
hold off
%% scratch 2 


%% scratch paper 


[cellDepthSorted, index] = sort(cellDepth);
for k = 1:numel(ratioVar)
ratioVarSorted(k) = ratioVar(index(k));
end

figure
test = movmean(ratioVarSorted, 10, 'SamplePoints', cellDepthSorted);
hold on
scatter(test, cellDepthSorted, 'r')



test10 = [ratioVar; cellDepth]
smooth(test10)


 Xi = 0:5:500;
 Yi = pchip(cellDepth,ratioVar,Xi);
 figure(10)
 plot(Yi,Xi,ratioVar,cellDepth)
 
 
 vq = interp1(ratioVar,v,xq)