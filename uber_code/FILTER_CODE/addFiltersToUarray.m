%%
function U =  addFiltersToUarray(U)
try  % if not in ms format make it that way
    U = msAndRoundUarray(U, 'ms');
catch
end

waitbar1 = waitbar(0, ['processing ' num2str(length(U)) ' cells and adding filters to U array']);
for cellStep = 1:length(U)
    clearvars -except U U2 Uall  waitbar1 cellStep
    
    %%
    trialLength = 4000;
    numTrials = length(U{cellStep}.meta.poleOnset);
    nanEmpty = nan(trialLength, numTrials);
    zerosEmpty = zeros(trialLength, numTrials);
    onesEmpty = ones(trialLength, numTrials);
    
    
    
    %% 1.1 Prepole to pole up --- basline for all time before
    filterNames{1,1} = '1.1 Prepole to pole up --- basline for all time before ';
    %%
    
    filter1_1 = nanEmpty;
    for k = 1:numTrials
        filter1_1(1:U{cellStep}.meta.poleOnset(k), k) = 1;
    end
    
    %% 1.2 pole up - 400 ms to pole up --- baseline user set time
    lessTime = 400;
    
    filterNames{1,2} =[ '1.2    ' num2str(lessTime)...
        ' ms before pole up --- baseline user set time (if not enough time before pole up will use as much as possible'];
    %%
    
    filter1_2 = nanEmpty;
    for k = 1:numTrials
        if U{cellStep}.meta.poleOnset(k)-lessTime > 0
            filter1_2(U{cellStep}.meta.poleOnset(k)-lessTime:U{cellStep}.meta.poleOnset(k), k) = 1;
        else
            filter1_2(1:U{cellStep}.meta.poleOnset(k), k) = 1;
        end
    end
    
    %% 2.1 Pole up to approximate first touch time
    addTimeToWindow =400;
    
    filterNames{1,3} = ['2.1 Pole up to approximate first touch time estimated at ' num2str(addTimeToWindow), ' ms'];
    
    %%
    filter2_1_IND = [];
    filter2_1 = nanEmpty;
    for k = 1:numTrials
        filter2_1(U{cellStep}.meta.poleOnset(k):U{cellStep}.meta.poleOnset(k)+addTimeToWindow, k) = 1;
        filter2_1_IND(k) = U{cellStep}.meta.poleOnset(k);
    end
    
    %% 2.2 Pole up and in reach to approximate first touch time
    addTimeToWindow =300;
    addTimeToOnset = 110; %estimated time from pole trigger to pole in reach
    
    filterNames{1,4} = '2.2 Pole up and in reach to approximate first touch time';
    filterNames{2,4} = ['add time to windows = ', num2str(addTimeToWindow)...
        ' ms   add time to onset (time estimated until pole is in reach) ' num2str(addTimeToOnset) ' ms' ];
    %%
    
    filter2_2 = nanEmpty;
    for k = 1:numTrials
        filter2_2(U{cellStep}.meta.poleOnset(k)+addTimeToOnset:U{cellStep}.meta.poleOnset(k)+addTimeToOnset+addTimeToWindow, k) = 1;
    end
    
    %% 2.3 pole up before estimated before touch
    addTimeToWindow = 110;
    
    filterNames{1,5} = ['2.3 pole up before estimated first touch, time after pole trigger = ' num2str(addTimeToWindow) ' ms'];
    %%
    
    filter2_3 = nanEmpty;
    for k = 1:numTrials
        filter2_3(U{cellStep}.meta.poleOnset(k):U{cellStep}.meta.poleOnset(k)+addTimeToWindow, k) = 1;
    end
    
    %% 3 Pole up to sometime after (or some window maybe make sure to capture those biphasic responses)
    addTime = 500;
    
    filterNames{1,6} = ['3 Pole up to ' num2str(addTime) ' ms after'];
    %%
    
    filter3 = nanEmpty;
    for k = 1:numTrials
        filter3(U{cellStep}.meta.poleOnset(k):U{cellStep}.meta.poleOnset(k)+addTime, k) = 1;
    end
    %% 4 First lick plus sometime, set so lick only a certain time after pole up counts
    winAfterLick = 100 ;
    afterPoleOnsetAdd = 200;
    
    filterNames{1,7} = '4 First lick plus sometime, set so lick only a certain time after pole up counts';
    filterNames{2,7} = ['winAfterLick = ' num2str(winAfterLick) ' afterPoleOnsetAdd = ' num2str(afterPoleOnsetAdd)];
    %%
    
    
    filter4 = nanEmpty;
    filter4_IND = [];
    for k = 1:numTrials
        
        firstLickGreaterThanInd =find((U{cellStep}.meta.beamBreakTimesCell{k}> U{cellStep}.meta.poleOnset(k)+afterPoleOnsetAdd), 1);
        filter4_IND(k) = nan;
        firstLickGreaterThan = U{cellStep}.meta.beamBreakTimesCell{k}(firstLickGreaterThanInd);
        if ~isempty(firstLickGreaterThan) && firstLickGreaterThan <= (trialLength-winAfterLick) %remove the lick responses that run over 4000 (could trim them but chose not to)
            filter4(firstLickGreaterThan:firstLickGreaterThan+winAfterLick, k) = 1;
            filter4_IND(k) = firstLickGreaterThan;
            
        end
    end
    if size(filter4,1)>4000
        keyboard
    end
    %% 5 lick period  defined as first to last lick but before pole down
    % winAfterLick =50; set above
    % afterPoleOnsetAdd; set above
    
    filterNames{1,8} = '5 lick period  defined as first to last lick but before pole down';
    filterNames{2,8} = ['winAfterLick = ' num2str(winAfterLick) ' afterPoleOnsetAdd = ' num2str(afterPoleOnsetAdd)];
    %%
    
    filter5 = nanEmpty;
    
    for k = 1:numTrials
        
        firstLickGreaterThanInd =(U{cellStep}.meta.beamBreakTimesCell{k}> U{cellStep}.meta.poleOnset(k)+afterPoleOnsetAdd);
        lastLickLessThanInd =(U{cellStep}.meta.beamBreakTimesCell{k}< U{cellStep}.meta.poleOffset(k));
        firstToLastLickInd = find(firstLickGreaterThanInd.*lastLickLessThanInd);
        licksInWin = U{cellStep}.meta.beamBreakTimesCell{k}(firstToLastLickInd);
        if ~isempty(licksInWin)
            filter5(licksInWin(1):licksInWin(end)+winAfterLick, k) = 1;
        end
    end
    %% MAKE THIS LATER -- ALL LICK PERIOD WITH CUT OFF TIME WILL NEED THE INDS FOR THIS ONE FOR SURE
    %% ACTUALLY REALLY ONLY NEED THE INDS AND THEN REMOVE ALL THE BORDER ONES THAT ARE CLOSE TO THE EDGE
    
    
    
    %% 6.1 pole down response plus some time
    %% WARNING  WARNING  WARNING  WARNING  WARNING
    %% because the 'IND' filters are being created to make Pvalues
    %% they will NOT index trials with pole down that is less than addTime variable
    %% (unlike the regular filters that will) IF USING THIS FOR P VALUES MAKE SURE TO
    %% SET 'smallLimit' to equal 'addTime' so that the plots will match the Pvalues
    %% if for some reason you want to allow the indices that are larger than smallLimit
    %% and less than addTime then you can change to adding of the nan value to filter6_1_IND
    %% below at the else statemnt marked by these symbols %###$$$@@@
    smallLimit = 35;
    addTime = 200;
    
    filterNames{1,9} = '6.1 pole down response plus some time';
    filterNames{2,9} = ['small limit = ' num2str(smallLimit) ...
        '   addTime = ' num2str(addTime) ];
    
    %%
    filter6_1 = nanEmpty;
    filter6_1_IND = [];
    for k = 1:numTrials
        if (U{cellStep}.meta.poleOffset(k)+addTime) <= trialLength
            filter6_1(U{cellStep}.meta.poleOffset(k):U{cellStep}.meta.poleOffset(k)+addTime, k) = 1;
            filter6_1_IND(k) = U{cellStep}.meta.poleOffset(k);
        elseif  (trialLength - U{cellStep}.meta.poleOffset(k))<smallLimit
            filter6_1_IND(k) = nan;
            %             disp(['skipping pole down response because less than user selected ', num2str(smallLimit), ' ms']);
        else
            filter6_1(U{cellStep}.meta.poleOffset(k):trialLength, k) = 1;
            filter6_1_IND(k) = nan;%###$$$@@@
            %         warning('had to cut the the total time b/c late pole down');
        end
    end
    
    
    
    %% 6.2 pole down response (after pole out of reach) plus some time
    smallLimit = 35;
    addTime = 200;
    addTimeToOffset = 200;%time i think it takes for pole to be out of reach
    
    filterNames{1,10} = '6.2 pole down response (after pole out of reach) plus some time';
    filterNames{2,10} = ['small limit (est pole out of reach time after trigger) = ' num2str(smallLimit) ...
        '   addTime = ' num2str(addTime) '   addTimeToOffset = ' num2str(addTimeToOffset) ];
    %%
    filter6_2 = nanEmpty;
    for k = 1:numTrials
        if (U{cellStep}.meta.poleOffset(k)+addTime) <= trialLength
            filter6_2(U{cellStep}.meta.poleOffset(k)+addTimeToOffset:...
                U{cellStep}.meta.poleOffset(k)+addTimeToOffset+addTime, k) = 1;
        elseif  (trialLength - U{cellStep}.meta.poleOffset(k))<smallLimit
            %             disp(['skipping pole down response because less than user selected ', num2str(smallLimit), ' ms']);
        else
            filter6_2(U{cellStep}.meta.poleOffset(k):trialLength, k) = 1;
            %         warning('had to cut the the total time b/c late pole down');
        end
    end
    %% 7 all pole down (and out of reach periods)
    addTimeAfterPoleDownTrigger = 300;
    minSizePoleDownPeriod = 200; %
    filterNames{1,11} = ['7 all pole down (and out of reach periods) time after pole down = '...
        num2str(addTimeAfterPoleDownTrigger), ' min size of captured period = ', num2str(minSizePoleDownPeriod)];
    %%
    filter7 = nanEmpty;
    
    
    for k = 1:numTrials
        if  (U{cellStep}.meta.poleOnset(k)-minSizePoleDownPeriod)>0% this should never happen but just in case
            filter7(1:U{cellStep}.meta.poleOnset(k),k) = 1;
        end
        if (U{cellStep}.meta.poleOffset(k)+addTimeAfterPoleDownTrigger+minSizePoleDownPeriod)<trialLength
            filter7((U{cellStep}.meta.poleOffset(k)+addTimeAfterPoleDownTrigger):trialLength, k) = 1;
        end
    end
    
    %% 0 no filter
    filterNames{1,12} = '0 no filter';
    %%
    filter0=onesEmpty;
    
    
    
    %% pole Position filters variable
    varFilterNames{1} =  'pole positions sorted from largest (near mouse) to smallest (away from mouse -- far)';
    numGroups = 10; %num filters in this filter stack
    motPos = U{cellStep}.meta.motorPosition;
    Uranges = U{cellStep}.meta.ranges;
    filterNames{1,12} = [];%fill in for indexing later
    
    poleRegions = round(linspace(Uranges(2), Uranges(1), numGroups+1));
    for k = 1:numGroups
        poleFiltTmp = nanEmpty(1,:);
        rangeTmpInds = find((motPos<=poleRegions(k)) .* (motPos> poleRegions(k+1)));
        poleFiltTmp(rangeTmpInds) = 1;
        
        poleFilt{k} = repmat(poleFiltTmp, [trialLength, 1]);
    end
    
    %% trial time filter variable
    varFilterNames{2} = 'trial times split up into section';
    numGroups = 2;
    numTrials = length(U{cellStep}.meta.poleOnset);
    trialTimeRegion = round(linspace(1,numTrials, numGroups+1));
    filterNames{1,13} = [];%fill in for indexing later
    
    for k = 1:numGroups
        timeTrialTmp = nanEmpty(1,:);
        timeTrialTmp(trialTimeRegion(k):trialTimeRegion(k+1)) = 1;
        timeTrialFilt{k} = timeTrialTmp;
    end
    
    %% noFilter variable filter (in case you don't want to plot agaist a variable filter)
    filterNames{1,14} = [];%fill in for indexing later
    varFilterNames{3} = 'all ones no filter';
    noFilter{1} = ones(trialLength, numTrials);
    
    %% combine all window filters into a struct
    allFilters.filter0 = filter0;
    allFilters.filter1_1 = filter1_1;
    allFilters.filter1_2 = filter1_2;
    allFilters.filter2_1 = filter2_1;
    allFilters.filter2_2 = filter2_2;
    allFilters.filter2_3 = filter2_3;
    allFilters.filter3 = filter3;
    allFilters.filter4 = filter4;
    allFilters.filter5 = filter5;
    allFilters.filter6_1 = filter6_1;
    allFilters.filter6_2 = filter6_2;
    allFilters.filter7 = filter7;
    allFilters.polePosition = poleFilt;
    allFilters.trialTime = timeTrialFilt;
    allFilters.noFilter = noFilter;
    
    
    %% indices for these thigs and add name/descrition
    allFilters.INDpoleUp = filter2_1_IND;
    filterNames{1, size(filterNames,2)+1} =  'all pole up indices (time in ms)'  ;
    allFilters.INDpoleDown = filter6_1_IND;
    filterNames{1, size(filterNames,2)+1} =   'all pole down indices (time in ms) also see warning in the addFiltersToUarray program'  ;
    allFilters.INDlickFilter4_INDS = filter4_IND;
    filterNames{1, size(filterNames,2)+1} =   'all lick periods based on the filter 4 description' ;
    
    
    
    %% get baslines for the period before select filters
    
    
    forThesFilters = {...
        'allFilters.filter2_1' , ...
        'allFilters.filter2_2' , ...
        'allFilters.filter2_3' , ...
        'allFilters.filter3' , ...
        'allFilters.filter4' , ...
        'allFilters.filter5' , ...
        'allFilters.filter6_1' , ...
        'allFilters.filter6_2' , ...
        'allFilters.filter7', ...
        };
    %% these baselines will be added to the U Array
    theseBaslineNumbers = [50];
    for msBefore = theseBaslineNumbers
        numFiltNames = size(filterNames,2);
        
        for k = 1:length(forThesFilters)
            tmpFilter = eval(forThesFilters{k});
            numTrialsTMP = size(tmpFilter,2);
            tmpFilterBaseline = nan(trialLength, numTrialsTMP);
            for kk = 1:numTrialsTMP
                endOfBaslineFilt = find(~isnan(tmpFilter(:,kk)), 1)-1;
                startOfBaslineFilt = endOfBaslineFilt-msBefore +1;
                if startOfBaslineFilt<1
                    startOfBaslineFilt = 1;%in case there isnt enough to capture what you wanted take what is there(should never be a problem though)
                end
                tmpFilterBaseline(startOfBaslineFilt:endOfBaslineFilt, kk) = 1;
            end
            evalString = [forThesFilters{k}, '_BL_',num2str(msBefore), ' = ', 'tmpFilterBaseline;'];
            eval(evalString);
            filterNames{1,numFiltNames+k} = ['basline filter for ', forThesFilters{k}, '. ',...
                num2str(msBefore), ' ms before it starts'];%giving names to these basline filters
        end
    end
    U{cellStep}.filters.filters = allFilters;
    U{cellStep}.filters.filterNames = filterNames';
    U{cellStep}.filters.varFilterNames = varFilterNames;
    
    
    %% end cell step code
    waitbar(cellStep./length(U), waitbar1);
end
close(waitbar1)
end