%% PLOT USING FILTERS MASTER


%% WARNING THIS PROGRAM CLEARS ALL VARIABLE THAT ARE NOT U ... YOU HAVE BEEN WARNED


%% USED TO SET UP THE PLOTTING AND THEN RUN THE GENERAL PLOTTING PROGRAM



%% ID: A
%% NAME: whisk modulation pole onset (before touch)
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; good for sanity check to test when pole is avialble (cause all should be the same)
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = false;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\AllTrials\baseline400';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp whisk beforeTouch TEST';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'whisk modulation pole onset (before touch): colors indicate pole positions (blue close -- red far)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
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
plotsFromFilters_plusVariableFilterTESTincludeALL2

%% ID: B
%% NAME: pole in reach estimated touch 
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\AllTrials\baseline400';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp touch estimated in reach';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'pole in reach estimated touch: colors indicate pole positions (blue close -- red far)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_2';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
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
plotsFromFilters_plusVariableFilterTESTincludeALL

%% ID: C
%% NAME: pole onset plus ms from 2.1 filter 
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\AllTrials\baseline400';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp plus 400 ms';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'pole onset +400 ms: colors indicate pole positions (blue close -- red far)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_1';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
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
plotsFromFilters_plusVariableFilterTESTincludeALL






%% ID: A2
%% NAME: whisk modulation pole onset (before touch) GO vs NOGO
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; good for sanity check to test when pole is avialble (cause all should be the same)
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\GOvsNOGO';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp whisk beforeTouch';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'whisk modulation pole onset (before touch): colors indicate pole positions (blue close -- red far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [8, 9]; %hit miss CR FA ALL correct incorrect GOs NOGOs
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
    setLineStyle{9} = '--';
    
    
end
plotsFromFilters_plusVariableFilterTESTincludeALL

%% ID: B2
%% NAME: pole in reach estimated touch GO vs NOGO
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\GOvsNOGO';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp touch estimated in reach';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'pole in reach estimated touch: colors indicate pole positions (blue close -- red far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_2';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [8 9]; %hit miss CR FA ALL correct incorrect GOs NOGOs
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
    setLineStyle{9} = '--';
    
    
end
plotsFromFilters_plusVariableFilterTESTincludeALL

%% ID: C2
%% NAME: pole onset plus ms from 2.1 filter  GO vs NOGO
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\GOvsNOGO';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp plus 400 ms';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'pole onset +400 ms: colors indicate pole positions (blue close -- red far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_1';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [8 9]; %hit miss CR FA ALL correct incorrect GOs NOGOs
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
    setLineStyle{9} = '--';
    
    
end
plotsFromFilters_plusVariableFilterTESTincludeALL







######### %DIVIDING DOESN'T WORK WELL BECAUSE MANY CELLS HAVE NO SPIKES FOR CERTAIN TRIALS
%% $$$$$$$$$$$$$ CHANGE BASLINE baslineType TO BE DIVIDE OR MINUS
%% ID: A2 divide 400 basline
%% NAME: whisk modulation pole onset (before touch) GO vs NOGO
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; good for sanity check to test when pole is avialble (cause all should be the same)
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\GOvsNOGO\baseline400divide';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp whisk beforeTouch divide 400 basline';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'whisk pole onset no touch: colors = pole positions (blue=close -- red=far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
    baselineFilterName = 'filter2_3_BL_50';
    baslineType = 'divide';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
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
    setLineStyle{9} = '--';
    
    
end
plotsFromFilters_plusVariableFilterTESTincludeALL2

%% ID: B2 divide 400 basline
%% NAME: pole in reach estimated touch GO vs NOGO
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\GOvsNOGO\baseline400divide';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp touch estimated in reach divide 400 basline';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'pole in reach estimated touch: colors indicate pole positions (blue close -- red far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_2';
    baselineFilterName = 'filter1_2';
    baslineType = 'divide';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [8 9]; %hit miss CR FA ALL correct incorrect GOs NOGOs
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
    setLineStyle{9} = '--';
    
    
end
plotsFromFilters_plusVariableFilterTESTincludeALL2

%% ID: C2 divide 400 basline
%% NAME: pole onset plus ms from 2.1 filter  GO vs NOGO
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\GOvsNOGO\baseline400divide';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp plus 400 ms divide 400 basline';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'pole onset +400 ms: colors indicate pole positions (blue close -- red far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_1';
    baselineFilterName = 'filter2_1_BL_50';
    baslineType = 'divide';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
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
    setLineStyle{9} = '--';
    
    
end
plotsFromFilters_plusVariableFilterTESTincludeALL2







%% ID: A3 recent Baseline
%% NAME: whisk modulation pole onset (before touch) GO vs NOGO
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; good for sanity check to test when pole is avialble (cause all should be the same)
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\GOvsNOGO\baselineBefore150';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp whisk beforeTouch';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'whisk modulation pole onset (before touch): colors indicate pole positions (blue close -- red far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
    baselineFilterName = 'filter2_3_BL_50';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [8, 9]; %hit miss CR FA ALL correct incorrect GOs NOGOs
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
    setLineStyle{9} = '--';
    
    
end
plotsFromFilters_plusVariableFilterTESTincludeALL

%% ID: B3 recent Baseline
%% NAME: pole in reach estimated touch GO vs NOGO
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\GOvsNOGO\baselineBefore150';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp touch estimated in reach';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'pole in reach estimated touch: colors indicate pole positions (blue close -- red far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_2';
    baselineFilterName = 'filter2_2_BL_50';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [8 9]; %hit miss CR FA ALL correct incorrect GOs NOGOs
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
    setLineStyle{9} = '--';
    
    
end
plotsFromFilters_plusVariableFilterTESTincludeALL

%% ID: C3 recent Baseline
%% NAME: pole onset plus ms from 2.1 filter  GO vs NOGO
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\GOvsNOGO\baselineBefore150';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp plus 400 ms';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'pole onset +400 ms: colors indicate pole positions (blue close -- red far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_1';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [8 9]; %hit miss CR FA ALL correct incorrect GOs NOGOs
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
    setLineStyle{9} = '--';
    
    
end
plotsFromFilters_plusVariableFilterTESTincludeALL







%% ID: D
%% NAME: first lick after a certain time after pole up (set in filter builder) 
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\AllTrials\baseline400';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'first licks after user set time';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'first lick after certain time (see txt file): colors indicate pole positions (blue close -- red far)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter4';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
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
plotsFromFilters_plusVariableFilterTESTincludeALL


%% ID: E
%% NAME: first lick after a certain time after pole up (set in filter builder) for trialsTypes hit and FA
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; 
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\HITvsFA';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'first licks after poleUP +200 HITvsFA';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'first lick after PoleUP +200 ms: colors indicate pole positions (blue close -- red far)(--=NoGo -=Go)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter4';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
    thesetrialTypes = [1 4]; %hit miss CR FA ALL correct incorrect GOs NOGOs
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
plotsFromFilters_plusVariableFilterTESTincludeALL


%% NAME: whisk modulation pole onset (before touch)
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; good for sanity check to test when pole is avialble (cause all should be the same)
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\AllTrials\baseline400';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp whisk beforeTouch';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'whisk modulation pole onset (before touch): colors indicate pole positions (blue close -- red far)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
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
plotsFromFilters_plusVariableFilterTESTincludeALL


%% NAME: whisk modulation pole onset (before touch)
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; good for sanity check to test when pole is avialble (cause all should be the same)
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\AllTrials\baseline400';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp whisk beforeTouch';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'whisk modulation pole onset (before touch): colors indicate pole positions (blue close -- red far)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
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
plotsFromFilters_plusVariableFilterTESTincludeALL


%% NAME: whisk modulation pole onset (before touch)
%% BASLINE: 400 ms before pole onset
%% VARIABLE FILT: pole position 
%% NOTES; good for sanity check to test when pole is avialble (cause all should be the same)
for minimizeSection = 1
    clearvars -except U U2 Uall
    %% save section
    saveON = true;
    saveDir = 'C:\Users\maire\Documents\PLOTS\S2\Pole Position\AllTrials\baseline400';%dont add end slash
    mkdir(saveDir);
    saveStringAddOn = 'poleUp whisk beforeTouch';
    %% figure props
    xLabelVar = 'time (ms) ';
    yLabelVar = 'spikes/sec (minus 400 ms before pole up)' ;
    titleVar = 'whisk modulation pole onset (before touch): colors indicate pole positions (blue close -- red far)';
    %% INPUTS
    addToFigNum = 0; % to make different graphs to directly compare two
    mainFilterName = 'filter2_3';
    baselineFilterName = 'filter1_2';
    varFiltName = 'polePosition';
    numColors = 6; %matches the varFiltNumber (determined in addFilterToUarray program)
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
plotsFromFilters_plusVariableFilterTESTincludeALL

