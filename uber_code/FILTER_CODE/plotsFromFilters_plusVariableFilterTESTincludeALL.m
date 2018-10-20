%% PLOTS USING FILTERS

%  set(gca,'YScale','log')


% colorNum = 5;
% setColor{1} = [cool(colorNum); cool(colorNum)]
% setColor{3} = [hot(colorNum); hot(colorNum)]
% setColor{4} = [hot(colorNum); hot(colorNum)]


% numColors = 6;
% setColor{1} = philsColorCodes(numColors, 'blue3');
% setColor{2} = philsColorCodes(numColors, 'black3');
% setColor{3} = philsColorCodes(numColors, 'red3');
% setColor{4} = philsColorCodes(numColors, 'green3');



% close all
%%
allCounter = 0;
counter = SP1.*SP2;
labelingHack = true;
% figure(1+100+addToFigNum);
% waitbar1 = waitbar(0, 'building graph');
hold on
for cellStep = 1:length(U)
    allCounter = allCounter+1;
    if counter == SP1.*SP2
        %         if labelingHack
        %             labelingHack = false;
        %         else
        %             addSubTextToFilterPlot
        %         end
        counter = 0 ;
        mainFig = figure(cellStep+100+addToFigNum);
        hold on
        
    end
    
    counter = counter +1;
    %     waitbar(cellStep/length(U), waitbar1);
    subplot(SP1, SP2, counter)
    cellInfoTitle ; %creates cell title name
    tmpTitle = title(cellTitleName);
    set(tmpTitle, 'Units','normalized');
    set(tmpTitle, 'Position', [.5, .9]);
    %% get filters
    filtersStruct = 'U{cellStep}.filters.filters';
    variableFilterAll = eval([filtersStruct, '.', varFiltName]);
    for varFiltStep = 1:length(variableFilterAll)
        
        variableFilter = variableFilterAll{varFiltStep};
        mainfilterTMP = (eval([filtersStruct, '.', mainFilterName]));
        mainFilter = mainfilterTMP .*(variableFilter);
        baselineFilter = eval([filtersStruct, '.', baselineFilterName]).*(variableFilter);
        
        %% get the description of the filter names
        strucNames = fieldnames(eval(filtersStruct));
        allFilterNames = {mainFilterName , baselineFilterName};
        for k = 1:2
            nameCellInd = strfind(strucNames, allFilterNames{k});
            nameInd = find(~cellfun(@isempty,nameCellInd));
            nameInd = nameInd(1);
            
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
        trialTypes{6} = Tcorrect;
        trialTypes{7} = ~Tcorrect';
        trialTypes{8} = Ttype';
        trialTypes{9} = ~Ttype';
        %% baselines
        
        selectedBasline = allSpikes .* baselineFilter;
        selectedBaslineShifted = shiftToZero(selectedBasline);
        selectedBaslineMean = nanmean(selectedBaslineShifted, 1);
        selectedBaslineMeanREP =  repmat(selectedBaslineMean , [trialLength,1]);
        %% add filters to the spikes and shift to zero
        selectedResp = allSpikes.* mainFilter;
        selectedRespShifted = shiftToZero(selectedResp);
        
        %% shift everything to zero

        %% adjust with basline get mean
        if exist('baslineType',   'var') ==1
            if contains(lower(baslineType), 'divide')
                selectRespNorm = selectedRespShifted ./ selectedBaslineMeanREP;
            else
                error('not valid baseline instruction');
            end
            
        else %default to subtraction of basline
            selectRespNorm = selectedRespShifted - selectedBaslineMeanREP;
        end
        selectRespMean = nanmean(selectRespNorm, 2);
        
        
        %% TRIAL TYPE setting up to plot
        
        for k = thesetrialTypes
            if k ~= 5
                allREP_TT{k} = repmat(trialTypes{k}', [trialLength, 1]);
                
                selectedRespNormTT{k} = selectRespNorm .* allREP_TT{k};
                selectedRespMeanTT{k} =  nanmean(selectedRespNormTT{k}, 2);
                
                findStart = find(~isnan(selectedRespMeanTT{k}), 1);
                findEnd = find(~isnan(selectedRespMeanTT{k}));
                if ~isempty(findEnd)
                    findEnd = findEnd(end);
                    selectedRespMeanPlotTT{k} = smooth(selectedRespMeanTT{k}(findStart:findEnd), SMOOTHfactor);
                    selectedRespMeanPlotTT{k}(1:5) = nan;
                    selectedRespMeanPlotTT{k}(end-4:end) = nan;
                else
                    selectedRespMeanPlotTT{k} = nan;
                end
            end
        end
        
        %% all spikes setting up to plot
        if ~isempty(findEnd)
            findStart = find(~isnan(selectRespMean), 1);
            findEnd = find(~isnan(selectRespMean));
            if ~isempty(findEnd)
                findEnd = findEnd(end);
            else
                selectedRespMeanPlotTT{k} = nan;
            end
        else
            selectedRespMeanPlotTT{k} = nan;
        end
        
        allSpikes = smooth(selectRespMean(findStart:findEnd), SMOOTHfactor);
        allSpikes(1:5) = nan;%remove spikes from smoothing
        allSpikes(end-4:end) = nan;%remove spikes from smoothing
        
        %% plotting TT code: hit miss cr fa
        hold on
        selectedRespMeanPlotTT{5} = allSpikes;
        for k = thesetrialTypes
            if ~(nanmean(selectedRespMeanPlotTT{k})== 0)
                plotTest = plot(selectedRespMeanPlotTT{k});
                plotTest.Color = setColor{k}(varFiltStep,:);
                plotTest.Color(4) = transparency;
                plotTest.LineStyle = setLineStyle{k};
                plotTest.LineWidth = LineWidth;
            end
        end
        
    end
    addInfoAtEnd = true;
    if counter == SP1.*SP2
        addSubTextToFilterPlot
        saveFilterPlot
        addInfoAtEnd = false;
    end
    %     keyboard
    %     clf('reset')
end
%% fill in the extra polots with blank plots
if addInfoAtEnd
    test10 = allCounter./(SP1.*SP2);
    if test10 ~= round(test10)
        numSubPlotsMade=round( ((test10-floor(test10)).*(SP1.*SP2)));
        makeTheseSubPlots = (SP1.*SP2) - numSubPlotsMade;
        for iters = 1:makeTheseSubPlots
            itersPlotNums = iters+((SP1.*SP2)-makeTheseSubPlots);
            subplot(SP1, SP2, itersPlotNums)
        end
        
    end
    % close(waitbar1)
    
    
    addSubTextToFilterPlot %need this here and above (this just catches the last plot)
    saveFilterPlot
end

%% save a text with the parameters used for this plot
plotParamsName = [saveDir, filesep, saveStringAddOn, '_plotParams.txt'];
plotParamsTxt = fopen(plotParamsName,'w');
for txtFileIter = 1 : numel(filterNames)./2
    fprintf(plotParamsTxt,'%s\r\n',filterNames{txtFileIter,1});
    fprintf(plotParamsTxt,'%s\r\n',filterNames{txtFileIter,2});
    fprintf(plotParamsTxt,'%s\r\n','');
end
fprintf(plotParamsTxt,'%s\r\n','all basline filters start with the number 1');
fclose(plotParamsTxt);
% HAVE TO ADD TRIAL TYPE AND TRIAL OUTCOME FILTERS TO THIS