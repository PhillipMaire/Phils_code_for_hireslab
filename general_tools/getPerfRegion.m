%% getPerfRegion

%% get the performance regions for an array of 1's and 0's
% inputArray = TT.correct;
% % % % % % % % % % % % % % % % greaterOrLessThan = 0 ;% 1 is greater than set val 0 is less than

% % % % % % % % % % % % % % PerfSET = 0.6 ;% performance to find
smoothByVal = 20 ; % keep this pretty low don't go up to like 50 or 100
% for below
% we will find an array of start and end regions of the array that meets our performance parameters
% the maxskip value allows you to combine regions that only skip by a few trials becasue of chance
% so fo example if it was set to 5 then the following two regions 21 to 40 and 44 to 100, would be
% combine into 21 to 100 regions
maxSkipVal = 5;
% the min skip value limits the aboce saying that if a region is less than this value dont even use
% it to comine with the nearby values (cause somethines its only 1 long or something. so using the same above
% setting "maxSkipVal = 5"  and "minSkipvalue = 3" then 39 to 40 and 44 to 100 would not be combined becasue
% 39 to 40 is too small only 1 long (40-39 = 1)
minSkipvalue = 3;


smoothPerf = smooth(inputArray , smoothByVal);
trialNums = 1:1:length(smoothPerf);
figure
plot( 1:length(smoothPerf), smoothPerf)
hold on 
ylim([0 1])
close
if greaterOrLessThan == 1
    
    hist(smoothPerf, round(length(smoothPerf))./5)
    
    indsPerf = find(smoothPerf>=PerfSET);
elseif greaterOrLessThan == 0
    indsPerf = find(smoothPerf<=PerfSET);
else
    error('')
end

contIndsPerf = indsPerf'-(1:length(indsPerf));

[startNums , indsForStart,~] = unique(contIndsPerf);


indsForEnd = indsForStart(2:end)-1;
indsForEnd(end+1) = length(indsPerf);
if ~isempty(indsPerf)
    indsOfPerf = [indsPerf(indsForStart), indsPerf(indsForEnd)];
    
    indsOfPerf2 = indsOfPerf;
    lengthEach  = indsOfPerf(:, 2) - indsOfPerf(:, 1);
    skippedBy = (indsOfPerf(2:end, 1) - indsOfPerf(1:end-1, 2))-1;
    
    skipedByMinInds =skippedBy<=maxSkipVal;
    minLengthToCombine = lengthEach>=minSkipvalue;
    combineTheseInds = find(skipedByMinInds.*minLengthToCombine(1:end-1));
    for testIter = flip(1:length(combineTheseInds))
        indsOfPerf(combineTheseInds(testIter), 2) = indsOfPerf(combineTheseInds(testIter)+1, 2);
        indsOfPerf(combineTheseInds(testIter), 2) = indsOfPerf(combineTheseInds(testIter)+1, 2);
    end
    
    keepInds = setdiff(1:size(indsOfPerf,1), combineTheseInds+1);
    
    %%
    indsOfPerf =  indsOfPerf(keepInds, :);
    lengthEach  = indsOfPerf(:, 2) - indsOfPerf(:, 1);
    
    
else
    indsOfPerf = nan(1, 2);
    lengthEach = nan;
end



performaceRegionMat = [indsOfPerf,lengthEach];







