%%

%%


close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\depthPlots';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'baselineFiringRate';
    %% figure props
    xLabelVar = 'baseline spikes per second';
    yLabelVar = 'Depth (microns)' ;
    titleVar = 'baseline firing rate at different depths';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter1_1';
    baselineFilterName = 'filter1_1';
    setMainFilterAsBLandDontChangeSPK = true;
    baslineType = 'minus';
    varFiltName = 'noFilter';
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
    MarkerSize = 20;
    transparency = 1;
    
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
plotsFromFilters_plotDepth
close all hidden


%%
%%


close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\depthPlots';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'pole up average firing rate';
    %% figure props
    xLabelVar = 'spikes/s (minus basline 400ms before pole up)';
    yLabelVar = 'Depth (microns)' ;
    titleVar = 'pole up response (whisk or sound) before touch vs depth';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
    baselineFilterName = 'filter1_2';
    setMainFilterAsBLandDontChangeSPK = false;
    baslineType = 'minus';
    varFiltName = 'noFilter';
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
    MarkerSize = 20;
    transparency = 1;
    
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
plotsFromFilters_plotDepth
close all hidden


%%
%%


close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\depthPlots';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'pole in reach (110ms after poleup) average firing rate';
    %% figure props
    xLabelVar = 'spikes/s (minus basline 400ms before pole up)';
    yLabelVar = 'Depth (microns)' ;
    titleVar = 'pole in reach response (whisk or sound) vs depth';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_2';
    baselineFilterName = 'filter1_2';
    setMainFilterAsBLandDontChangeSPK = false;
    baslineType = 'minus';
    varFiltName = 'noFilter';
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
    MarkerSize = 20;
    transparency = 1;
    
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
plotsFromFilters_plotDepth
close all hidden


%%
%%


close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\polePosition\depthPlots';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'Pole down response';
    %% figure props
    xLabelVar = 'spikes/s (minus basline 50ms befole pole down)';
    yLabelVar = 'Depth (microns)' ;
    titleVar = 'pole down response (whisk or sound) vs depth';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter6_1';
    baselineFilterName = 'filter6_1_BL_50';
    setMainFilterAsBLandDontChangeSPK = false;
    baslineType = 'minus';
    varFiltName = 'noFilter';
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
    MarkerSize = 20;
    transparency = 1;
    
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
plotsFromFilters_plotDepth
close all hidden


%%