function [pointOfHighPerf, indexHighPerf, totalTrialsPicked] = highPerfRegion(arrayOfPerformance, numSmoothTrials, totalTrialsPicked)
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
paddingNum =   (totalTrialsPicked-1)/2
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