%% ID: A
%% NAME: whisk modulation pole onset (before touch)
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position
%% NOTES; good for sanity check to test when pole is avialble (cause all should be the same)

%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all hidden
clearvars -except U U2 Uall
addToBeginningOfPlot = 101;
baslineType = 'none';
for minimizeSection = 1

    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmapRAW';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'heatmap poleup +400ms  both whisk and touch_3ALL';
    %% figure props
    xLabelVar = 'time (ms) 0 = poleup signal';
    yLabelVar = 'pole position in 10 bins (1 is closest)' ;
    titleVar = 'poleup +400ms raw spikes per sec heatmap';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_1';
%     differentLengthsCutOff = 300;
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 20; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [5]; %hit miss CR FA ALL correct incorrect GOs NOGOs
    % plotcolors = {'b' 'k' 'r' 'g'};
    %% INPUTS 2
    SMOOTHfactor = 30;
    SP1 = 5; %subplot indice 1
    SP2 = 9; %subplot indice 2
    
  
    colorString = 'Spectral';
    % colorString = 'RdYlBu';
    for k = 1:9 % for each trial type (for variable filter it plots colors according to the variable filter)
        % so for pole position if you plot go and no go then it will plot them as different colors because the
        % pole positions are different for each
        setColor{k}  =flipud(brewermap(numColors,colorString));
    end
    
    %% COLOR CODE PLOT
    colorCodeFig = figure(9999);
    hold on
    numColors ;
    for colorNums = 1:numColors
        lineName =  plot((1:numColors), ones(1, numColors).*colorNums);
        lineName.LineWidth = 50;
        lineName.Color = setColor{1}(colorNums,:);
    end
    if saveON
        colorCodeSaveName = [saveDir,filesep,saveStringAddOn,'_colorCode' ];
        saveas(gcf,colorCodeSaveName,'png')
    end
    
    %% line properties
    LineWidth = 2;
    transparency = .8;
    
    setLineStyle{1} = '-';
    setLineStyle{2} = '-';
    setLineStyle{3} = '--';
    setLineStyle{4} = '--';
    setLineStyle{5} = '-';
    setLineStyle{6} = '-';
    setLineStyle{7} = '-';
    setLineStyle{8} = '-';
    setLineStyle{9} = '-';
    
    
end
plotsFromFilters_varFilterHEAT2

close all hidden
%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%


close all hidden
clearvars -except U U2 Uall
addToBeginningOfPlot = 101;
baslineType = 'none';
for minimizeSection = 1

    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmapRAWbothSmooth20';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'heatmap poledown +200ms RAW ALL';
    %% figure props
    xLabelVar = 'time (ms) 0 = poledown signal';
    yLabelVar = 'pole position in 10 bins (1 is closest)' ;
    titleVar = 'poledown +200ms raw spikes per sec heatmap';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter6_1';
%     differentLengthsCutOff = 300;
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 20; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [5]; %hit miss CR FA ALL correct incorrect GOs NOGOs
    % plotcolors = {'b' 'k' 'r' 'g'};
    %% INPUTS 2
    SMOOTHfactor = 20;
    SP1 = 5; %subplot indice 1
    SP2 = 9; %subplot indice 2
    
  
    colorString = 'Spectral';
    % colorString = 'RdYlBu';
    for k = 1:9 % for each trial type (for variable filter it plots colors according to the variable filter)
        % so for pole position if you plot go and no go then it will plot them as different colors because the
        % pole positions are different for each
        setColor{k}  =flipud(brewermap(numColors,colorString));
    end
    
    %% COLOR CODE PLOT
    colorCodeFig = figure(9999);
    hold on
    numColors ;
    for colorNums = 1:numColors
        lineName =  plot((1:numColors), ones(1, numColors).*colorNums);
        lineName.LineWidth = 50;
        lineName.Color = setColor{1}(colorNums,:);
    end
    if saveON
        colorCodeSaveName = [saveDir,filesep,saveStringAddOn,'_colorCode' ];
        saveas(gcf,colorCodeSaveName,'png')
    end
    
    %% line properties
    LineWidth = 2;
    transparency = .8;
    
    setLineStyle{1} = '-';
    setLineStyle{2} = '-';
    setLineStyle{3} = '--';
    setLineStyle{4} = '--';
    setLineStyle{5} = '-';
    setLineStyle{6} = '-';
    setLineStyle{7} = '-';
    setLineStyle{8} = '-';
    setLineStyle{9} = '-';
    
    
end
plotsFromFilters_varFilterHEAT2

close all hidden

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



















close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmap\ZSCORE';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'heatmap 50ms BL before pole up whisk response 110 ms';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 50 ms before)' ;
    titleVar = 'pole up whisk response 110 ms ';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
    baselineFilterName = 'filter2_3_BL_50';
    baslineType = 'minus';
    varFiltName = 'polePosition';
    numColors = 20; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [5]; %hit miss CR FA ALL correct incorrect GOs NOGOs
    % plotcolors = {'b' 'k' 'r' 'g'};
    %% INPUTS 2
    SMOOTHfactor = 30;
    SP1 = 3; %subplot indice 1
    SP2 = 3; %subplot indice 2
    
  
    colorString = 'Spectral';
    % colorString = 'RdYlBu';
    for k = 1:9 % for each trial type (for variable filter it plots colors according to the variable filter)
        % so for pole position if you plot go and no go then it will plot them as different colors because the
        % pole positions are different for each
        setColor{k}  =flipud(brewermap(numColors,colorString));
    end
    
    %% COLOR CODE PLOT
    colorCodeFig = figure(9999);
    hold on
    numColors ;
    for colorNums = 1:numColors
        lineName =  plot((1:numColors), ones(1, numColors).*colorNums);
        lineName.LineWidth = 50;
        lineName.Color = setColor{1}(colorNums,:);
    end
    if saveON
        colorCodeSaveName = [saveDir,filesep,saveStringAddOn,'_colorCode' ];
        saveas(gcf,colorCodeSaveName,'png')
    end
    
    %% line properties
    LineWidth = 2;
    transparency = .8;
    
    setLineStyle{1} = '-';
    setLineStyle{2} = '-';
    setLineStyle{3} = '--';
    setLineStyle{4} = '--';
    setLineStyle{5} = '-';
    setLineStyle{6} = '-';
    setLineStyle{7} = '-';
    setLineStyle{8} = '-';
    setLineStyle{9} = '-';
    
    
end
plotsFromFilters_varFilterHEAT



%%

close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmapFIX';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'heatmap 50ms BL before pole down response plus some time';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 50 ms before)' ;
    titleVar = 'pole down response plus 200ms (min length 35ms)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter6_1';
    differentLengthsCutOff = 200;
    baselineFilterName = 'filter6_1_BL_50';
    baslineType = 'minus';
    varFiltName = 'polePosition';
    numColors = 20; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [5]; %hit miss CR FA ALL correct incorrect GOs NOGOs
    % plotcolors = {'b' 'k' 'r' 'g'};
    %% INPUTS 2
    SMOOTHfactor = 30;
    SP1 = 3; %subplot indice 1
    SP2 = 3; %subplot indice 2
    
  
    colorString = 'Spectral';
    % colorString = 'RdYlBu';
    for k = 1:9 % for each trial type (for variable filter it plots colors according to the variable filter)
        % so for pole position if you plot go and no go then it will plot them as different colors because the
        % pole positions are different for each
        setColor{k}  =flipud(brewermap(numColors,colorString));
    end
    
    %% COLOR CODE PLOT
    colorCodeFig = figure(9999);
    hold on
    numColors ;
    for colorNums = 1:numColors
        lineName =  plot((1:numColors), ones(1, numColors).*colorNums);
        lineName.LineWidth = 50;
        lineName.Color = setColor{1}(colorNums,:);
    end
    if saveON
        colorCodeSaveName = [saveDir,filesep,saveStringAddOn,'_colorCode' ];
        saveas(gcf,colorCodeSaveName,'png')
    end
    
    %% line properties
    LineWidth = 2;
    transparency = .8;
    
    setLineStyle{1} = '-';
    setLineStyle{2} = '-';
    setLineStyle{3} = '--';
    setLineStyle{4} = '--';
    setLineStyle{5} = '-';
    setLineStyle{6} = '-';
    setLineStyle{7} = '-';
    setLineStyle{8} = '-';
    setLineStyle{9} = '-';
    
    
end
plotsFromFilters_varFilterHEAT




%%



close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmapZSCORE';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'heatmap 50ms BL before first lick 200ms after pole up';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 50 ms before)' ;
    titleVar = 'first lick 200ms after pole up';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter4';
    differentLengthsCutOff = 300;
    baselineFilterName = 'filter4_BL_50';
    baslineType = 'minus';
    varFiltName = 'polePosition';
    numColors = 20; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [5]; %hit miss CR FA ALL correct incorrect GOs NOGOs
    % plotcolors = {'b' 'k' 'r' 'g'};
    %% INPUTS 2
    SMOOTHfactor = 30;
    SP1 = 3; %subplot indice 1
    SP2 = 3; %subplot indice 2
    
  
    colorString = 'Spectral';
    % colorString = 'RdYlBu';
    for k = 1:9 % for each trial type (for variable filter it plots colors according to the variable filter)
        % so for pole position if you plot go and no go then it will plot them as different colors because the
        % pole positions are different for each
        setColor{k}  =flipud(brewermap(numColors,colorString));
    end
    
    %% COLOR CODE PLOT
    colorCodeFig = figure(9999);
    hold on
    numColors ;
    for colorNums = 1:numColors
        lineName =  plot((1:numColors), ones(1, numColors).*colorNums);
        lineName.LineWidth = 50;
        lineName.Color = setColor{1}(colorNums,:);
    end
    if saveON
        colorCodeSaveName = [saveDir,filesep,saveStringAddOn,'_colorCode' ];
        saveas(gcf,colorCodeSaveName,'png')
    end
    
    %% line properties
    LineWidth = 2;
    transparency = .8;
    
    setLineStyle{1} = '-';
    setLineStyle{2} = '-';
    setLineStyle{3} = '--';
    setLineStyle{4} = '--';
    setLineStyle{5} = '-';
    setLineStyle{6} = '-';
    setLineStyle{7} = '-';
    setLineStyle{8} = '-';
    setLineStyle{9} = '-';
    
    
end
plotsFromFilters_varFilterHEAT

close all hidden








close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmap\ZSCORE';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'heatmap 50ms BL poleup +400ms  both whisk and touch';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 50 ms before)' ;
    titleVar = 'poleup +400ms  both whisk and touch';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_1';
%     differentLengthsCutOff = 300;
    baselineFilterName = 'filter2_1_BL_50';
    baslineType = 'minus';
    varFiltName = 'polePosition';
    numColors = 20; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [5]; %hit miss CR FA ALL correct incorrect GOs NOGOs
    % plotcolors = {'b' 'k' 'r' 'g'};
    %% INPUTS 2
    SMOOTHfactor = 30;
    SP1 = 3; %subplot indice 1
    SP2 = 3; %subplot indice 2
    
  
    colorString = 'Spectral';
    % colorString = 'RdYlBu';
    for k = 1:9 % for each trial type (for variable filter it plots colors according to the variable filter)
        % so for pole position if you plot go and no go then it will plot them as different colors because the
        % pole positions are different for each
        setColor{k}  =flipud(brewermap(numColors,colorString));
    end
    
    %% COLOR CODE PLOT
    colorCodeFig = figure(9999);
    hold on
    numColors ;
    for colorNums = 1:numColors
        lineName =  plot((1:numColors), ones(1, numColors).*colorNums);
        lineName.LineWidth = 50;
        lineName.Color = setColor{1}(colorNums,:);
    end
    if saveON
        colorCodeSaveName = [saveDir,filesep,saveStringAddOn,'_colorCode' ];
        saveas(gcf,colorCodeSaveName,'png')
    end
    
    %% line properties
    LineWidth = 2;
    transparency = .8;
    
    setLineStyle{1} = '-';
    setLineStyle{2} = '-';
    setLineStyle{3} = '--';
    setLineStyle{4} = '--';
    setLineStyle{5} = '-';
    setLineStyle{6} = '-';
    setLineStyle{7} = '-';
    setLineStyle{8} = '-';
    setLineStyle{9} = '-';
    
    
end
plotsFromFilters_varFilterHEAT

close all hidden


%%%%%%%%%%%%%%%%%%%
%%

% for cellStepTMP = 1:length(U)
%    allDepths(cellStepTMP) = U{cellStepTMP}.details.depth; 
% end
% [~, depthInds] = sort(allDepths);
% Usorted = cell(0);
% for cellStepTMP = depthInds
%     Usorted{end+1} = U{cellStepTMP};
% end
% Unormal = U;
% U = Usorted;
%%






















%%

close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmapFIX';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'heatmap poleup +400ms  both whisk and touch_3';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400ms before pole up)' ;
    titleVar = 'poleup +400ms  both whisk and touch';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_1';
%     differentLengthsCutOff = 300;
    baselineFilterName = 'filter1_2';
    baslineType = 'minus';
    varFiltName = 'polePosition';
    numColors = 20; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [5]; %hit miss CR FA ALL correct incorrect GOs NOGOs
    % plotcolors = {'b' 'k' 'r' 'g'};
    %% INPUTS 2
    SMOOTHfactor = 30;
    SP1 = 3; %subplot indice 1
    SP2 = 3; %subplot indice 2
    
  
    colorString = 'Spectral';
    % colorString = 'RdYlBu';
    for k = 1:9 % for each trial type (for variable filter it plots colors according to the variable filter)
        % so for pole position if you plot go and no go then it will plot them as different colors because the
        % pole positions are different for each
        setColor{k}  =flipud(brewermap(numColors,colorString));
    end
    
    %% COLOR CODE PLOT
    colorCodeFig = figure(9999);
    hold on
    numColors ;
    for colorNums = 1:numColors
        lineName =  plot((1:numColors), ones(1, numColors).*colorNums);
        lineName.LineWidth = 50;
        lineName.Color = setColor{1}(colorNums,:);
    end
    if saveON
        colorCodeSaveName = [saveDir,filesep,saveStringAddOn,'_colorCode' ];
        saveas(gcf,colorCodeSaveName,'png')
    end
    
    %% line properties
    LineWidth = 2;
    transparency = .8;
    
    setLineStyle{1} = '-';
    setLineStyle{2} = '-';
    setLineStyle{3} = '--';
    setLineStyle{4} = '--';
    setLineStyle{5} = '-';
    setLineStyle{6} = '-';
    setLineStyle{7} = '-';
    setLineStyle{8} = '-';
    setLineStyle{9} = '-';
    
    
end
plotsFromFilters_varFilterHEAT

close all hidden
%%


close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmapZSCORE';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'heatmap pole up whisk period baseline 1_2';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400ms before pole up)' ;
    titleVar = 'pole up response';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
%     differentLengthsCutOff = 300;
    baselineFilterName = 'filter1_2';
    baslineType = 'minus';
    varFiltName = 'polePosition';
    numColors = 20; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [5]; %hit miss CR FA ALL correct incorrect GOs NOGOs
    % plotcolors = {'b' 'k' 'r' 'g'};
    %% INPUTS 2
    SMOOTHfactor = 30;
    SP1 = 3; %subplot indice 1
    SP2 = 3; %subplot indice 2
    
  
    colorString = 'Spectral';
    % colorString = 'RdYlBu';
    for k = 1:9 % for each trial type (for variable filter it plots colors according to the variable filter)
        % so for pole position if you plot go and no go then it will plot them as different colors because the
        % pole positions are different for each
        setColor{k}  =flipud(brewermap(numColors,colorString));
    end
    
    %% COLOR CODE PLOT
    colorCodeFig = figure(9999);
    hold on
    numColors ;
    for colorNums = 1:numColors
        lineName =  plot((1:numColors), ones(1, numColors).*colorNums);
        lineName.LineWidth = 50;
        lineName.Color = setColor{1}(colorNums,:);
    end
    if saveON
        colorCodeSaveName = [saveDir,filesep,saveStringAddOn,'_colorCode' ];
        saveas(gcf,colorCodeSaveName,'png')
    end
    
    %% line properties
    LineWidth = 2;
    transparency = .8;
    
    setLineStyle{1} = '-';
    setLineStyle{2} = '-';
    setLineStyle{3} = '--';
    setLineStyle{4} = '--';
    setLineStyle{5} = '-';
    setLineStyle{6} = '-';
    setLineStyle{7} = '-';
    setLineStyle{8} = '-';
    setLineStyle{9} = '-';
    
    
end
plotsFromFilters_varFilterHEAT

close all hidden
%%
%%
