%% PLOTS USING FILTERS
mainFig = figure(10);
hold on
%  set(gca,'YScale','log')

%% INPUTS
mainFilterName = 'filter6_1';
baselineFilterName = 'filter1_1';
thesetrialTypes = 1:4; %hit miss CR FA 
plotAllTrials = false; %turn on or off plotting the combination of all trials
 plotcolors = {'b' 'k' 'r' 'g'};
 
%%
for cellStep = 1:length(U)
    %% get filters
    filtersStruct = 'U{cellStep}.filters.filters';
    mainFilter = eval([filtersStruct, '.', mainFilterName]);
    baselineFilter = eval([filtersStruct, '.', baselineFilterName]);
    %% get the description of the filter names
    strucNames = fieldnames(eval(filtersStruct));
    allFilterNames = {mainFilterName , baselineFilterName};
    for k = 1:2
        nameCellInd = strfind(strucNames, allFilterNames{k});
        nameInd = find(~cellfun(@isempty,nameCellInd));
        filterNames(k,:) = U{cellStep}.filters.filterNames(nameInd,:);
    end
    %%
    trialLength = 4000;
    % times 1000 so that it is all in spikes per second
    allSpikes = 1000.*squeeze(U{cellStep}.R_ntk);
    
    Ttype = U{cellStep}.meta.trialType;
    Tcorrect = U{cellStep}.meta.trialCorrect;
    
    hit = (Ttype.*Tcorrect)'; hit(hit==0) = nan;
    miss = (Ttype.* ~Tcorrect)';  miss(hit==0) = nan;
    CR = (~Ttype.* Tcorrect)';  CR(hit==0) = nan;
    FA = (~Ttype.* ~Tcorrect)';  FA(hit==0) = nan;
    
    trialTypes{1} = hit;
    trialTypes{2} = miss;
    trialTypes{3} = CR;
    trialTypes{4} = FA;
    %% baslines
    
    basline400 = allSpikes .* baselineFilter;
    basline400mean = nanmean(basline400, 1);
    basline400meanREP =  repmat(basline400mean , [trialLength,1]);
    %% after pole touch possible
    poleUpResp = allSpikes.* mainFilter;
    poleUpRespShifted = nan(size(poleUpResp));
    
    %% shift everything to zero
    for kk = 1:size(poleUpResp,2)
        tmpVar = poleUpResp(:,kk);
        findStart = find(~isnan(tmpVar), 1);
        if ~isempty(findStart)
            findEnd = find(~isnan(tmpVar));
            findEnd = findEnd(end);
            poleUpRespShifted(1:length(findStart:findEnd), kk) = tmpVar(findStart:findEnd);
        end
    end
    poleUpNorm = poleUpRespShifted - basline400meanREP;
    poleUpMean = nanmean(poleUpNorm, 2);
    
    
    %% TRIAL TYPE setting up to plot
    SMOOTHfactor = 30;
    for k = thesetrialTypes
        allREP_TT{k} = repmat(trialTypes{k}', [trialLength, 1]);
        
        poleUpNormTT{k} = poleUpNorm .* allREP_TT{k};
        poleUpMeanTT{k} =  nanmean(poleUpNormTT{k}, 2);
        
        findStart = find(~isnan(poleUpMeanTT{k}), 1);
        findEnd = find(~isnan(poleUpMeanTT{k}));
        if ~isempty(findEnd)
            findEnd = findEnd(end);
            poleUpMeanPlotTT{k} = smooth(poleUpMeanTT{k}(findStart:findEnd), SMOOTHfactor);
            poleUpMeanPlotTT{k}(1:5) = nan;
            poleUpMeanPlotTT{k}(end-4:end) = nan;
        else
            poleUpMeanPlotTT{k} = nan;
        end
        
    end
    
    %% all setting up to plot
    findStart = find(~isnan(poleUpMean), 1);
    findEnd = find(~isnan(poleUpMean));
    findEnd = findEnd(end);
    
    test20 = smooth(poleUpMean(findStart:findEnd), SMOOTHfactor);
    test20(1:5) = nan;%remove spikes from smoothing
    test20(end-4:end) = nan;%remove spikes from smoothing
    %% PLOTTING
    clf('reset')
    hold on
     if plotAllTrials
    plot(test20, 'k--');
     end
    %% plotting TT code: hit miss cr fa

    for k = thesetrialTypes
        
         test = plot(poleUpMeanPlotTT{k}, plotcolors{k});
    end
    keyboard
   
    %%
    
end

% HAVE TO ADD TRIAL TYPE AND TRIAL OUTCOME FILTERS TO THIS