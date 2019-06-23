% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %% spikeOnsetFirstSpike.m
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % close all
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % meanTraceFig = figure(2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % hold on
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % allTracesFig = figure (1);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % hold on
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % SP1 = 5;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % SP2 = 9;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % shiftToZero = false;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % counter =0 ;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % for cellStep = 1:45
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % U{23}.details.projectDetails.cellNumberForProject
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % cellStep = 1
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % counter = counter +1;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % theta = 'change this to spikes';
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % spikesTMP = squeeze(U{cellStep}.R_ntk);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % spikes = smooth(spikesTMP, 30, 'moving');
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % spikes = reshape(spikes, size(spikesTMP));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % numTrials = size(spikes, 2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % poleOnsets = U{cellStep}.meta.poleOnset;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % addTimeBefore = 400;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % afterPoleNoMove = 0;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % preSpikeTime = addTimeBefore + afterPoleNoMove;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % xaxisNUMS = (1:(addTimeBefore+ timeAfterPoleOnset+1))- (addTimeBefore+1);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % poleOnsets  = poleOnsets - addTimeBefore;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % timeAfterPoleOnset = 1000;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % timeAfterPoleOnset = timeAfterPoleOnset-1; %to make it an even 30
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % spikesTrimmed = [];%initialize
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % preSpikeSTD = [];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % preSpikeMean = [];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % for k = 1:numTrials
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     spikesTrimmed(:, k) = spikes(poleOnsets(k):poleOnsets(k)+timeAfterPoleOnset+addTimeBefore, k);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     %shift to zero
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     if shiftToZero
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         spikesTrimmed(:, k) = -mean(spikesTrimmed(1:preSpikeTime, k)) + spikesTrimmed(:, k);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     preSpikeSTD(k,1) = std(spikesTrimmed(1:addTimeBefore, k));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     preSpikeMean(k,1) = mean(spikesTrimmed(1:addTimeBefore, k));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % STDspikes = [];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % STDspikeBLnum = 30;%must be even
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % eachSideOfBL = STDspikeBLnum./2;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % for k = 1:numTrials
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     STDspikesTMP =spikesTrimmed(:, k);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     STDspikesTMP = STDspikesTMP - preSpikeMean(k);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     if k+eachSideOfBL > numTrials %end trials pad with last X trials
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         STDspikes(:, k) = STDspikesTMP./ mean(preSpikeSTD(end-STDspikeBLnum:end));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     elseif k-eachSideOfBL < 1  %end trials pad with last X trials
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         STDspikes(:, k) = STDspikesTMP./ mean(preSpikeSTD(1:STDspikeBLnum+1));%must be cause othe rwindow is STDspikeBLnum plus on cause k number
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     else
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         STDspikes(:, k) = STDspikesTMP./ mean(preSpikeSTD(k-eachSideOfBL:k+eachSideOfBL));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % lims4respDetection = [-25:65];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % STDspikes= STDspikes(lims4respDetection+addTimeBefore, :);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % STDthresh = 1.75;%%%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % estimRespOnset = [];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % for k = 1:numTrials
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     respInd = find(STDspikes(:, k) >= STDthresh, 1);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     if numel(respInd) > 0
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         estimRespOnset(k, 1) = respInd;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     else
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         estimRespOnset(k, 1) = 0;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % estimRespOnset = estimRespOnset+ lims4respDetection(1);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % figure(1);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % tmpSP = subplot(SP1, SP2, counter);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % estimRespOnset2 =estimRespOnset(find(estimRespOnset>lims4respDetection(1)+1));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % hist(estimRespOnset2, length(lims4respDetection)./5)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % xlim([lims4respDetection(1), lims4respDetection(end)]);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % titleVar = [num2str(length(estimRespOnset2)), '/' num2str(length(estimRespOnset))];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % tmpSP.Title.String = titleVar;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %      tmpSP.Title.FontSize = 9;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % allRespOnsets{cellStep} = estimRespOnset;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % figure
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % for k = 100:numTrials
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     hold off
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     test10 =spikesTrimmed(:, k);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     test10 = test10 - preSpikeMean(k);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     test10 = test10./ mean(preSpikeSTD(k:k+29));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     plot(xaxisNUMS, test10)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     hold on
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     plot(-400:1000, ones(1401, 1).*2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     ylim([-2 10]);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     keyboard
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
%% first spike during event of interest
close all hidden
subplotMakerNumber = 1; subplotMaker
ylimSET = [0 .4];
xlimSET = [-10 300];
numBinsSET = 40;
modifyValue = xlimSET(1);
for cellStep = 1:length(U)
    disp(cellStep)
    subplotMakerNumber = 2; subplotMaker
    spikesTMP = squeeze(U{cellStep}.R_ntk);
    poleONSETS = U{cellStep}.meta.poleOnset;
    firstSpikes = [];
    for k = 1:length(poleONSETS)
        eventStartTime = poleONSETS(k) + modifyValue;
        firstSpikesTMP = find(spikesTMP(eventStartTime:end, k), 1);
        if isempty(firstSpikesTMP)
            firstSpikes(k) = nan;
        else
            firstSpikes(k) = firstSpikesTMP+modifyValue;
        end
    end

    edgesForHist = linspace(xlimSET(1),xlimSET(2),numBinsSET);
  
    [tmpHISTn xOfHist] = hist(firstSpikes, edgesForHist);
    percentOfTotal = tmpHISTn./length(firstSpikes);
    tmpBAR1 = bar(xOfHist(1:end-1), percentOfTotal(1:end-1), 'b');
    %     tmpBAR1.EdgeColor = tmpBAR1.FaceColor;
    hold on
    numWithNoWhisk =sum(isnan(firstSpikes))./length(firstSpikes);
    xPosForNoWhisk = xOfHist(2)-xOfHist(1);
    
    
    tmpBAR2 =  bar(  xlimSET(1)-xPosForNoWhisk, numWithNoWhisk, 'r');
    tmpBAR2.BarWidth = 7;
    
    tmpBAR3 =  bar(  xOfHist(end), percentOfTotal(end), 'g');
    tmpBAR3.BarWidth = 7;
    %     tmpBAR2.EdgeColor = tmpBAR2.FaceColor;
    xlimSET2 = [];
    xlimSET2(1) = xlimSET(1) - xPosForNoWhisk.*2;
    xlimSET2(2) = xlimSET(2) + xPosForNoWhisk.*2;
    xlim(xlimSET2)
    ylim(ylimSET)
    grid on
   set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
end
keyboard
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
filename =  [num2str(cellStep), '_FirstSpikeAfterPoleUp' ];
saveas(gcf,filename,'png')
savefig(filename)

% % % close all hidden






