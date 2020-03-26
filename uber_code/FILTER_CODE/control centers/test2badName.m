%%  test2




%%

%%
close all hidden

for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    addToBeginningOfPlot = 50; 
    saveON = false;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\classifyingTypeALLinONE';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'whisk modulated classification';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400ms before pole up)' ;
    titleVar = 'pole up whisk classifying cell type';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
%     differentLengthsCutOff = 300;
    baselineFilterName = 'filter1_2';
    baslineType = 'minus';
    varFiltName = 'noFilter';
    numColors = 20; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [5]; %hit miss CR FA ALL correct incorrect GOs NOGOs
    % plotcolors = {'b' 'k' 'r' 'g'};
    %% INPUTS 2
    SMOOTHfactor = 5;
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
plotsFromFilters_withPvalueOnlyOneTraceAcceptedPLOT_ALL_CELLS


close all hidden

%%

close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    addToBeginningOfPlot =50; 
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\classifyingTypeALLinONE';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'touch time modulated classification';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400ms before pole up)' ;
    titleVar = 'pole up estimated touch time classifying cell type';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_2';
%     differentLengthsCutOff = 300;
    baselineFilterName = 'filter1_2';
    baslineType = 'minus';
    varFiltName = 'noFilter';
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
plotsFromFilters_withPvalueOnlyOneTraceAcceptedPLOT_ALL_CELLS

close all hidden






%%
tic
close all hidden
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    addToBeginningOfPlot =50; 
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\classifyingTypeALLinONE';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'pole Downn modulated classification';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus50ms before pole down)' ;
    titleVar = 'pole down classifying cell type';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter6_1';
%     differentLengthsCutOff = 300;
    baselineFilterName = 'filter6_1_BL_50';
    baslineType = 'minus';
    varFiltName = 'noFilter';
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
plotsFromFilters_withPvalueOnlyOneTraceAcceptedPLOT_ALL_CELLS

close all hidden
toc














