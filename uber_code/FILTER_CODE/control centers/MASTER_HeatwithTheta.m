%% switch u arrays

U2 = U;










%%
close all hidden
clearvars -except U U2 Uall
addToBeginningOfPlot = 101;
baslineType = 'none';
for minimizeSection = 1

    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmapRAWbothSmooth20NSRA2';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleup neural response heatmap and theta (green)';
    %% figure props
    xLabelVar = 'time (ms) 0 = pole up trigger';
    yLabelVar = 'pole position in 10 bins (1 is closest)' ;
    titleVar = saveStringAddOn;
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
    SP1 = 1; %subplot indice 1
    SP2 = 1; %subplot indice 2
    
  
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
clearvars -except U U2 Uall
addToBeginningOfPlot = 101;
baslineType = 'none';
for minimizeSection = 1

    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\heatmapRAWbothSmooth20';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poledown heatmap neural response and theta (green)';
    %% figure props
    xLabelVar = 'time (ms) 0 = event signal';
    yLabelVar = 'pole position in 10 bins (1 is closest)' ;
    titleVar = saveStringAddOn;
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
    SMOOTHfactor = 20;
    SP1 = 2; %subplot indice 1
    SP2 = 2; %subplot indice 2
    
  
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



