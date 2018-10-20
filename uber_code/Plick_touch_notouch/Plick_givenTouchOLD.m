function Plick_givenTouch(U)

 saveON = 0;


allcellNum = [1000, 1006, 1007, 1008, 1009, 1013, 1014, 1015, 1016, 1017];


titleCell= {'PM0001 Before Lesion 2', 'PM0001 Before Lesion 0', ...
    'PM0001 After Lesion 1', 'PM0001 After Lesion 2', ...
    'PM0001 After Lesion 3', 'AH0718 Before Lesion 1', ...
    'AH0718 Before Lesion 0', 'AH0718 After Lesion 1', ...
    'AH0718 After Lesion 2', 'AH0718 After Lesion 3', };

for cellNum = 1:numel(allcellNum)
    cellNum
    clearvars -except cellNum U titleCell saveON

    %% isolate the region of analysis to a select region based on high perfomrance
    windowShowSample = 4000; %show sample size for sliding window;
    ROIperfON = 1; 
    totalTrialsPicked = 249;
    numSmoothTrials = 150;
    [pointOfHighPerf, indexHighPerfLinInds, totalTrialsPicked] = highPerfRegion2(U{cellNum}.meta.trialCorrect, numSmoothTrials, totalTrialsPicked);
    %% basic info
    ranges = U{cellNum}.meta.ranges;%first number is nogo second is go limits
    
    %%
    
    trialType = U{cellNum}.meta.trialType;
    nogoTrialInds = trialType==0;
    trialCorrect = U{cellNum}.meta.trialCorrect;
    firstContacts = U{cellNum}.S_ctk(9,:,:);
    onsetPlusRise = round((U{cellNum}.meta.poleOnset + 0.15)*1000);
    answerLicks = round(U{cellNum}.meta.answerLickTime*1000);
    
    [~,~,trials] = size(firstContacts);
    firstTouchTime = nan(1, trials);
    for kk = 1:trials
        firstTouchTimeSingle = find(firstContacts(:,:,kk)==1); 
        firstTouchTime(1:numel(firstTouchTimeSingle),kk) = firstTouchTimeSingle';
    end
    %%% only look at touches if it was before answer lick and after onset
    firstTouchTime2 = ((firstTouchTime>answerLicks)+(firstTouchTime<onsetPlusRise))>0;
    firstTouchTime(firstTouchTime2) = nan;
    motorPosition = U{cellNum}.meta.motorPosition;
    %%
    if ROIperfON == 1;  
    trialType = trialType(indexHighPerfLinInds);
    nogoTrialInds = nogoTrialInds(indexHighPerfLinInds) ;
    trialCorrect = trialCorrect(indexHighPerfLinInds);
    firstContacts = firstContacts(indexHighPerfLinInds);
    onsetPlusRise = onsetPlusRise(indexHighPerfLinInds);
    answerLicks = answerLicks(indexHighPerfLinInds);

    
    firstTouchTime = firstTouchTime(indexHighPerfLinInds);
    
     motorPosition = motorPosition(indexHighPerfLinInds);
    end
    
    
    %%
    
    
    W_touch = (firstTouchTime>0); 
    WO_touch = isnan(firstTouchTime);
    

    
    W_touch_mot = motorPosition(find(W_touch));
    WO_touch_mot = motorPosition(find(WO_touch));
    [W_touch_mot_sort sortInd_W ] = sort(W_touch_mot);
    [WO_touch_mot_sort sortInd_WO ] = sort(WO_touch_mot);
    
    W_touch_cor = trialCorrect(find(W_touch));
    WO_touch_cor = trialCorrect(find(WO_touch));
    
    W_touch_cor = W_touch_cor(sortInd_W);
    WO_touch_cor = WO_touch_cor(sortInd_WO);
    
    W_touch_cor2 = smooth(W_touch_cor, 200, 'moving')';
    WO_touch_cor2 = smooth(WO_touch_cor, 200, 'moving')';
   

    [W_samplingNums] = calcNumInWindow(W_touch_mot_sort, ranges, windowShowSample);
    [WO_samplingNums] = calcNumInWindow(WO_touch_mot_sort, ranges, windowShowSample);

    figure(cellNum)
    clf
    totalSamples = length(W_touch);
    
    %% plot with number samples 
    lineProps. col = {'r'};
%     shadedErrorBar(W_touch_mot_sort, W_touch_cor2,W_samplingNums/20)
    mseb(W_touch_mot_sort, W_touch_cor2,W_samplingNums/totalSamples, lineProps, .25);
        lineProps. col = {'b'};
    mseb(WO_touch_mot_sort, WO_touch_cor2,WO_samplingNums/totalSamples, [], .25);
   
     %% plot just with the lines
%     plot(W_touch_mot_sort,  W_touch_cor2, 'b')
%     hold on
%     plot(WO_touch_mot_sort,  WO_touch_cor2, 'r')

    %     plot(motorPosition, ones(numel(motorPosition)), '.');
    xlabel('pole positions (only no go)')
    ylabel('percent correct')
    title(titleCell{cellNum})

    
    if saveON == 1 
    savefig(titleCell{cellNum})
    saveas(gcf,titleCell{cellNum},'png')
    end
    
    
  
    
end
end




%%
function [samplingNums2] = calcNumInWindow(vector, ranges, windowShowSample);

samplesPer = ranges(1):ranges(2);
nanPads = nan(windowShowSample,1);
samplesPer(end+1 : length(samplesPer)+windowShowSample) = nanPads;
samplesPer = [nanPads', samplesPer];
for k = 1:(length(samplesPer)-(windowShowSample))
    % get the total count of all samples ina certain space.
     %% if is nan then make high or low number to count edge trials
    factor1 = samplesPer(k);
    factor2 = samplesPer(k+windowShowSample);
    if isnan(factor1)
        factor1 = ranges(1); 
    end
    if isnan(factor2)
        factor2 = ranges(2);
    end 
    %%
    samplingNums(k) = sum((vector >= factor1).*(vector < factor2));
end
%%
samplingNums = samplingNums(windowShowSample+1:end);
% % % % for kk = 1:2
% % % %     for k = 1:windowShowSample
% % % %         edge(k) = sum((vector > samplesPer(k)).*(vector < samplesPer(k+windowShowSample)));
% % % %     end
% % % % end
addNum = ranges(1)-1;
for k = 1:length(vector)
    try
    samplingNums2(k) = samplingNums(vector(k)-addNum);
    catch 
        test1 = vector(k)-addNum;
       if abs(vector(k)-ranges(1))>abs(vector(k)-ranges(2))
           varAdjust = ranges(2);
       else
           varAdjust = ranges(1);
       end
        samplingNums2(k) = samplingNums(varAdjust-addNum);
       warning(['pole position out of range sutoset number ', num2str(k), ' from ', num2str(vector(k)), ' to ', num2str(varAdjust)]);
       display(['actual range is from ', num2str(ranges(1)), ' to ', num2str(ranges(2))]);
    end
end
end















%%
function [pointOfHighPerf, indexHighPerf, totalTrialsPicked] = highPerfRegion2(arrayOfPerformance, numSmoothTrials, totalTrialsPicked)
% % arrayOfPerformance = U{1, 1}.meta.trialCorrect;
% % numSmoothTrials = 200;
if totalTrialsPicked > length(arrayOfPerformance)
    warning('number of trials requested exceeds the total number of trials, changing it to the just include all trials consider changing this variable')
    totalTrialsPicked
    totalTrialsPicked = length(arrayOfPerformance)
end
    
if (totalTrialsPicked/2) == round(totalTrialsPicked/2) %if even 
    warning('numSmoothTrials (input 2) must be centered around one number and this must be odd');
    display(['Changing numSmoothTrials from ', num2str(totalTrialsPicked) , ' to ', num2str(totalTrialsPicked-1)]);
    totalTrialsPicked = totalTrialsPicked-1;
end
if numSmoothTrials> (totalTrialsPicked-1)/2
paddingNum = numSmoothTrials;
else 
paddingNum =   (totalTrialsPicked-1)/2;
end
    
smoothedPerf = smooth(arrayOfPerformance, numSmoothTrials,'moving');

smoothedPerf(1:paddingNum)= 0;
smoothedPerf(end-paddingNum+1:end)= 0;

[sortedSmoothPerf, index] = sort(smoothedPerf);
pointOfHighPerf = index(end);

eachEnd = (totalTrialsPicked-1)/2;



indexHighPerf = pointOfHighPerf-eachEnd: pointOfHighPerf+eachEnd;
indexHighPerfLinInds = zeros(length(arrayOfPerformance),1)';
indexHighPerfLinInds(indexHighPerf) = 1;



end

%%
% % %
% nanPads = nan(windowShowSample,1);
% samplesPer(end+1 : length(samplesPer)+windowShowSample) = nanPads;
% samplesPer = [nanPads', samplesPer]


%%














