%% PLOTS USING FILTERS
% plotsFromFilters_withPvalueOnlyOneTraceAcceptedPLOT_ALL_CELLS
%%
addToFigNum = 0;
saveCurrentVars = false;
allCounter = 0;
counter = SP1.*SP2;
for cellStep = 1:length(U)
    allCounter = allCounter+1;
    if counter == SP1.*SP2
        counter = 0 ;
        mainFig = figure(cellStep+100+addToFigNum);
        hold on
        
    end
    
    counter = counter +1;
    
    %     waitbar(cellStep/length(U), waitbar1);
    subplot(SP1, SP2, counter)
    %% create title for each cell
    cellInfoTitle ; %creates cell title name
    %     tmpTitle = title(cellTitleName);
    tmpTitle = title({['cell ', projectCellNum, ' ', depth, '\mum']});
    set(tmpTitle, 'Units','normalized');
    set(tmpTitle, 'Position', [.6, .9]);
    %% get filters
    filtersStruct = 'U{cellStep}.filters.filters';%beginning of name of struct based on add filters to U array program
    variableFilterAll = eval([filtersStruct, '.', varFiltName]); % variable filters are filters like pole
    %position and trial time (chuncked of trials in order)  so you can look at how things change in these dims
    for varFiltStep = 1:length(variableFilterAll)
        %%
        %         if saveCurrentVars
        %             allVars = whos;
        %             allVars =struct2cell(allVars);
        %             allVarNames = allVars(1,:);
        %             keepVariablesString = 'clearvars -except  keepVariablesString  allVarNames';
        %             for jhdfjhsdujfhsjd = 1: length(allVarNames)
        %                 keepVariablesString = [keepVariablesString, '  ', allVarNames{jhdfjhsdujfhsjd}];
        %             end
        %             saveCurrentVars = false;
        %         end
        %         eval(keepVariablesString);
        %%
        
        
        variableFilter = variableFilterAll{varFiltStep}; %userSet
        mainfilterTMP = (eval([filtersStruct, '.', mainFilterName]));%userSet
        try
            mainfilterTMP = cell2mat(mainfilterTMP);
        catch
        end
        mainfilterTMPaddBeginning = mainfilterTMP;
        if exist('addToBeginningOfPlot', 'var')
            for kkAddToFilt = 1: size(mainfilterTMP, 2)
                mainfilterTMPsingle = mainfilterTMP(:,kkAddToFilt);
                findFirstOfSingle = find(~isnan(mainfilterTMPsingle), 1);
                if findFirstOfSingle-addToBeginningOfPlot <1
                    findFirstOfSingle = addToBeginningOfPlot+1;
                else
                    mainfilterTMPaddBeginning(findFirstOfSingle-addToBeginningOfPlot:findFirstOfSingle,kkAddToFilt) = 1;
                end
            end
        else
            addToBeginningOfPlot =0;
        end
        mainFilter = mainfilterTMP .*(variableFilter);%userSet
        mainFilterAddBeginning = mainfilterTMPaddBeginning .*(variableFilter);%userSet
        baselineFilter = eval([filtersStruct, '.', baselineFilterName]).*(variableFilter);%userSet
        
        %% get the description of the filter names
        strucNames = fieldnames(eval(filtersStruct)); % for the filter info txt file
        allFilterNames = {mainFilterName , baselineFilterName};
        for k = 1:2%find the correct filter name
            % for basline and main filter
            nameCellInd = strfind(strucNames, allFilterNames{k});
            nameInd = find(~cellfun(@isempty,nameCellInd));
            nameInd = nameInd(1);%quick hack cause baseline filters created relative to each filter
            % starts with the same name so it will find 2. just use the first one.
            filterNames(k,:) = U{1}.filters.filterNames(nameInd,:);
        end
        %%
        trialLength = 4000; %set this so it's easy to change if needed
        allSpikes = 1000.*squeeze(U{cellStep}.R_ntk);% times 1000 so that it is all in spikes per second (easy hack)
        
        Ttype = U{cellStep}.meta.trialType;
        Tcorrect = U{cellStep}.meta.trialCorrect;
        
        hit = (Ttype.*Tcorrect)'; hit(hit==0) = nan;
        miss = (Ttype.* ~Tcorrect)';  miss(hit==0) = nan;
        CR = (~Ttype.* Tcorrect)';  CR(hit==0) = nan;
        FA = (~Ttype.* ~Tcorrect)';  FA(hit==0) = nan;
        
        %         totalNumTrials = length(hit);
        
        %these (below) all get rotated later FYI
        trialTypes{1} = hit;
        trialTypes{2} = miss;
        trialTypes{3} = CR;
        trialTypes{4} = FA;
        trialTypes{5} = ones(length(FA),1); %all trials
        trialTypes{6} = Tcorrect';
        trialTypes{7} = ~Tcorrect';
        trialTypes{8} = Ttype';
        trialTypes{9} = ~Ttype';
        %% baselines
        
        selectedBasline = allSpikes .* baselineFilter;
        selectedBaslineShifted = shiftToZero(selectedBasline);
        selectedBaslineMean = nanmean(selectedBaslineShifted, 1);
        %         selectedBaslineMeanREP =  repmat(selectedBaslineMean , [trialLength,1]); delete
        
        %% basline you only really need a single basline mean for each line
        selectedBaslineMeanSingle = nanmean(selectedBaslineMean);
        
        
        
        %% add filters to the spikes and shift to zero
        selectedResp = allSpikes.* mainFilter;
        selectedRespAddBeginning = allSpikes.* mainFilterAddBeginning;
        selectedRespShifted = shiftToZero(selectedResp);
        selectedRespAddBeginningShifted = shiftToZero(selectedRespAddBeginning);
        %         selectedRespMeanSingle = nanmean(selectedRespShifted, 2); delete
        
        
        %% TRIAL TYPE setting up to plot
        
        for k = thesetrialTypes
            TTfilterAll{k} = repmat(trialTypes{k}', [trialLength, 1]);
            
            selectedRespTT{k} = selectedRespShifted .* TTfilterAll{k};
            %%% this is where the two plot types slip off (one with beginning and one without)
            selectedRespTTAddBeginning{k} = selectedRespAddBeginningShifted .* TTfilterAll{k};
            selectedRespMeanTT{k} =  nanmean(selectedRespTTAddBeginning{k}, 2);
            
            findStart = find(~isnan(selectedRespMeanTT{k}), 1);
            findEnd = find(~isnan(selectedRespMeanTT{k}));
            if ~isempty(findEnd)
                findEnd = findEnd(end);
                %% basline compare if cell is significant INSERT FUNCTION
                
                selectedRespMeanTrimTT = selectedRespMeanTT{k}(findStart:findEnd);
                
                %% ADJUST BASED ON BASLINE
                selectedBaslineMeanSingleREP = repmat(selectedBaslineMeanSingle, [length(selectedRespMeanTrimTT),1]);
                if ~exist('baslineType',   'var') ==1
                    baslineType = 'minus';% default to minus
                end
                
                if contains(lower(baslineType), 'divide')
                    selectRespNormTT{k} = (selectedRespMeanTrimTT - selectedBaslineMeanSingleREP) ./ selectedBaslineMeanSingleREP;
                elseif contains(lower(baslineType), 'minus')
                    selectRespNormTT{k} = selectedRespMeanTrimTT - selectedBaslineMeanSingleREP;
                else
                    error('not valid baseline instruction');
                end
                %%  smooth it and cut off edges with by adding nans
                
                selectedRespMeanPlotTT{k} = smooth(selectRespNormTT{k}, SMOOTHfactor);
                selectedRespMeanPlotTT{k}(1:5) = nan;
                selectedRespMeanPlotTT{k}(end-4:end) = nan;
            else
                selectedRespMeanPlotTT{k} = nan; % if no response put a nan (doesn't plot it)
            end
        end
        %% save all the data in this struct
        eval(['meanSpikeData{', num2str(cellStep), '}.', varFiltName, '{varFiltStep} = selectedRespMeanPlotTT;']);
        %% plotting TT code: hit miss cr fa all correct incorrect go nogo
        hold on
        if ~exist('plotType', 'var') || strcmp(plotType, 'response');
            for k = thesetrialTypes
                if ~(nanmean(selectedRespMeanPlotTT{k})== 0)
                    plotCurvesHandle = plot(...
                        (1:length(selectedRespMeanPlotTT{k}))-addToBeginningOfPlot,selectedRespMeanPlotTT{k});
                    plotCurvesHandle.Color = setColor{k}(varFiltStep,:);
                    plotCurvesHandle.Color(4) = transparency;
                    plotCurvesHandle.LineStyle = setLineStyle{k};
                    plotCurvesHandle.LineWidth = LineWidth;
                    
                    
                    
                    usingmatlabTtestWithPlotFilters
                    
                    
                    
                    tmpTitle.String{2} = [' P=', num2str(probOfSigDiff)];
                    % polyfitTESTforResponseCurves % add a poly fit to the graph (this is working just commented out)
                    if probOfSigDiff> 0.05 || isnan(probOfSigDiff)%change color for insignificant plots
                        set(gca, 'color',[.66 .66 .66] )
                        plotCurvesHandle.Color(4) = .4;
%                     elseif probOfSigDiff> 0.01%
%                           set(gca, 'color',[.78 .78 .78] )
%                         plotCurvesHandle.Color(4) = .5;
%                     elseif probOfSigDiff> 0.001%
%                         set(gca, 'color',[.9 .9 .9] )
%                         plotCurvesHandle.Color(4) = .8;
                    end
                    tmpTitle.FontSize = 8;
                    getCurrentFigHandle = gcf;
                    getCurrentFigHandle.InvertHardcopy = 'off';
                    %                     plotCurvesHandle.Parent.XLim(2)  = length(selectedRespMeanPlotTT{k})- addToBeginningOfPlot;
                    plotCurvesHandle.Parent.XLim(2)  =  149;
                    plotCurvesHandle.Parent.XLim(1)  = - addToBeginningOfPlot;
                    
                    
                    %%
                    
                    % plot the rectangels for the places it is located
                    ylimTMP=get(gca,'ylim');
                    transparentTMP = 0.1;
                    %%
                    rectangleTMP = rectangle('Position', [startMeasureBASE ylimTMP(1) (endMeasureBASE-startMeasureBASE) length(ylimTMP(1):ylimTMP(2))-1],...
                        'FaceColor','blue');
                    rectangleTMP.EdgeColor = [rectangleTMP.FaceColor, transparentTMP];
                    rectangleTMP.FaceColor = [rectangleTMP.FaceColor, transparentTMP];
                    %%
                    rectangleTMP = rectangle('Position', [startMeasureSIG ylimTMP(1) (endMeasureSIG-startMeasureSIG) length(ylimTMP(1):ylimTMP(2))-1],...
                        'FaceColor','red');
                    rectangleTMP.EdgeColor = [rectangleTMP.FaceColor, transparentTMP];
                    rectangleTMP.FaceColor = [rectangleTMP.FaceColor, transparentTMP];
                    
                    
                    
                end
            end
        elseif strcmp(plotType, 'depthPlot');
            % depthFilterPlot
            
            
        end
        %       testThisShit(varFiltStep, :) = selectedRespMeanPlotTT{5}'  ;
    end
    %     DONT CHANGE
    addPlotsAtEnd = true; %hack used adding title and info for last plot DONT CHANGE
    % and for making end plot full so that the
    %position of the title and such are aligned
    %% save it and add text
    if counter == SP1.*SP2
        addSubTextToFilterPlot
        if saveON
            saveFilterPlot %calls this and saves it;
        end
        addPlotsAtEnd = false;
    end
end
%% fill in the extra polots with blank plots
if addPlotsAtEnd
    test10 = allCounter./(SP1.*SP2);
    if test10 ~= round(test10)
        numSubPlotsMade=round( ((test10-floor(test10)).*(SP1.*SP2)));
        makeTheseSubPlots = (SP1.*SP2) - numSubPlotsMade;
        for iters = 1:makeTheseSubPlots
            itersPlotNums = iters+((SP1.*SP2)-makeTheseSubPlots);
            subplot(SP1, SP2, itersPlotNums)
        end
    end
    addSubTextToFilterPlot %need this here and above (this just catches the last plot)
    if saveON
        saveFilterPlot
    end
end
% close(waitbar1)
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