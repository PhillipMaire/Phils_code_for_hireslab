%% PLOTS USING FILTERS
mainFig = figure(1);
waitbar1 = waitbar(0, 'building graph');
hold on
%  set(gca,'YScale','log')

%% INPUTS
mainFilterName = 'filter2_1';
baselineFilterName = 'filter1_1';
varFiltName = 'trialTime';
thesetrialTypes = [1, 3]; %hit miss CR FA
plotAllTrials = false; %turn on or off plotting the combination of all trials
plotcolors = {'b' 'k' 'r' 'g'};
SMOOTHfactor = 30;


colorNum = 5; 
setColor{1} = [cool(colorNum); cool(colorNum)]
setColor{3} = [hot(colorNum); hot(colorNum)]
setColor{4} = [hot(colorNum); hot(colorNum)]


setLineStyle{1} = '-';
setLineStyle{2} = '';
setLineStyle{3} = '--';
setLineStyle{4} = '--';
% numColors = 6;
% setColor{1} = philsColorCodes(numColors, 'blue3');
% setColor{2} = philsColorCodes(numColors, 'black3');
% setColor{3} = philsColorCodes(numColors, 'red3');
% setColor{4} = philsColorCodes(numColors, 'green3');


for k = 1:4
    setColor{k}  =flipud(brewermap(10,'Spectral'));
end
close all
%%

counter = 0 ;
for cellStep = 1:length(U)
   counter = counter +1; 
   if counter ==9 
       counter = 1 ; 
       figure(cellStep);
   end
    waitbar(cellStep/length(U), waitbar1);
    subplot(3, 3, counter)
    %% get filters
    filtersStruct = 'U{cellStep}.filters.filters';
    variableFilterAll = eval([filtersStruct, '.', varFiltName]);
    for varFiltStep = 1:length(variableFilterAll)
        
        variableFilter = variableFilterAll{varFiltStep};
        mainfilterTMP = (eval([filtersStruct, '.', mainFilterName]));
        mainFilter = mainfilterTMP .*(variableFilter);
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
        if ~isempty(findEnd)
            findStart = find(~isnan(poleUpMean), 1);
            findEnd = find(~isnan(poleUpMean));
            findEnd = findEnd(end);
        else
            poleUpMeanPlotTT{k} = nan;
        end
        
        test20 = smooth(poleUpMean(findStart:findEnd), SMOOTHfactor);
        test20(1:5) = nan;%remove spikes from smoothing
        test20(end-4:end) = nan;%remove spikes from smoothing
        %% PLOTTING
        
        hold on
        
        if plotAllTrials
            plot(test20, 'k--');
        end
        %% plotting TT code: hit miss cr fa
        for k = thesetrialTypes
            if ~(nanmean(poleUpMeanPlotTT{k})== 0)
                plotTest = plot(poleUpMeanPlotTT{k});
                plotTest.Color = setColor{k}(varFiltStep,:);
                plotTest.Color(4) = .6;
                plotTest.LineStyle = setLineStyle{k};
                plotTest.LineWidth = 1;
            end
        end
        
    end
    
    
    %     keyboard
    %     clf('reset')
end
close(waitbar1)
% HAVE TO ADD TRIAL TYPE AND TRIAL OUTCOME FILTERS TO THIS