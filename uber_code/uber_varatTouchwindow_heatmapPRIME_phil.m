
% % [layer, txt] = loadDataNames(U);

%%
saveON = 0

addToName = 'minN-5 -50to100ms';
for cellNum=[1,4]
    %% aneming section 
    
     mouseName = U{cellNum}.details.mouseName;
    sessionName = U{cellNum}.details.sessionName;
    cellNumString = U{cellNum}.details.cellNum;
    cellCode = U{cellNum}.details.cellCode; 
    projectCellNum = num2str(U{cellNum}.cellNum);
    depth = num2str(U{cellNum}.details.depth);
    fractionCorrect = num2str(U{cellNum}.details.fractionCorrect*100);
    trialsCorrect = U{cellNum}.meta.trialCorrect;
    fractionCorrectstr = ['1-',num2str(numel(trialsCorrect)),' ',fractionCorrect(1:4), '%'];
    
    useTrials = U{cellNum}.details.useTrials;
    %look at good perfomrance region
    numTrialsInRowCorrect = 4; %number of correct trials ina row to
    %find the last instance of so that you can give a good performance measure
    correctTrialsInRow = ones(1,numTrialsInRowCorrect);
    new = strfind(trialsCorrect, correctTrialsInRow);
    perormanceRegion= 1:new(end)+numTrialsInRowCorrect;
    meanPerformanceRegion = num2str(mean(trialsCorrect(perormanceRegion))*100);
    perormanceRegionStr = [num2str(useTrials(1)),'-',num2str(useTrials(perormanceRegion(end)))...
        ,' ', meanPerformanceRegion(1:4),'%'];
    
    
       filename = [' ', addToName, ' cell-', projectCellNum, ' depth-',    depth, ' ' ,mouseName, ' ' ,sessionName, ' ', cellNumString, ' ', cellCode, '.eps'];
    %%
    
    
    close all;
    
    countThresh = 5; %min touch in each bin to be considered
    gaussFilt = [1.9]; %sigma filter for imgaussfilt (can be single value for filtering across rows and columns or two values [x y] for filter of row/column
    window = [-50:100]; %ms to look around touch
    
% %     XstepSize = 25; %step size for x values AUTO SET BY MATLAB
    
    normalizeTHEsampleCountHistogram = 0; %set 1 for norm set 0 for not norm 
    XshiftSampleCount = 0; % shift (from zero) the line graph indicating the number of samples per bin
    normSizeSampleCount = 50; %set where the normalized peak of the sample histogram will be
    
    [varspikes, preDvarspikes,postDvarspikes] = assist_varAtTouch(U{cellNum},window);
    % First 6 columns will be values for the variables
    % 1) THETA
    % 2) PRE TOUCH VELOCITY
    % 3) AMP
    % 4) SETPOINT
    % 5) PHASE
    % 6) MAX KAPPA
    % Last columns will be the spikes around your given window
    
    comp={varspikes, preDvarspikes, postDvarspikes};
    figNames = [{'All'} {'Pre-Decision'} {'Post-Decision'}]
    for g = 1:length(comp)
        %%
        %Plot theta at touch
        fields = [  {'theta'}        {'velocity'}       {'amplitude'}    {'setpoint'}     {'phase'}               {'kappa'}];
        V.bounds = [{[-99.5:1:99.5]} {[-9750:50:9750]} {[-99.5:.5:99.5]} {[-99.5:.5:99.5]} {linspace(-pi,pi,180)} {[-.95:.005:.95]}];
        V.NumYticks = [{10} {10} {10} {10} {10} {10}];
        
        for d = [1 2 3 4 5 6] %for variables 1:6
            
            if d == 2
                [sorted, sortedBy ,binBounds]=binslin(comp{g}(:,d),comp{g}(:,7:end),'equalE',numel(V.bounds{d})+1,-10000,10000);
            elseif d == 5
                [sorted, sortedBy ,binBounds]=binslin(comp{g}(:,d),comp{g}(:,7:end),'equalX',numel(V.bounds{d})+1);
            elseif d == 6
                [sorted, sortedBy ,binBounds]=binslin(comp{g}(:,d),comp{g}(:,7:end),'equalE',numel(V.bounds{d})+1,-1,1);
            else
                [sorted, sortedBy ,binBounds]=binslin(comp{g}(:,d),comp{g}(:,7:end),'equalE',numel(V.bounds{d})+1,-100,100);
            end
            
            binrange = V.bounds{d};
            
            % Trimming unused ranges
            trims=[binrange' cell2mat(cellfun(@mean,sortedBy,'Uniformoutput',0))];
            indexHasTheta = ~isnan(trims(:,2));
            trims = trims(indexHasTheta, :);
            counttmp=cell2mat(cellfun(@size,sorted,'uniformoutput',0));
            
            % Populating fields with values
            V.(fields{d}).counts =counttmp(indexHasTheta==1,1);
            V.(fields{d}).increments = linspace(trims(1,1),trims(end,1),V.NumYticks{d});
            %             test1 = numel(trims(:, 1))/(V.NumYticks{d}+1);
            %
            %             test3 = (trims(1, 1):test1:trims(end, 1));
            %
            %
            
            
            
            
            V.(fields{d}).range = trims(:,1);
            V.(fields{d}).spikes=cell2mat(cellfun(@(x) mean(x,1),sorted,'uniformoutput',0));
            V.(fields{d}).spikes=V.(fields{d}).spikes(indexHasTheta==1,:);
            
            %Trimming bins with touchcounts below thresholds
            mintouches=find(V.(fields{d}).counts<countThresh);
            V.(fields{d}).counts(mintouches,:)=[];
            V.(fields{d}).spikes(mintouches,:)=[];
            V.(fields{d}).range(mintouches,:)=[];
            
            %Plotting features
      
            % %             YstepIncrements = V.(fields{d}).increments;
            
            figStartNum = 30;
            f = figure(figStartNum+g);
            set(f,'name',figNames{g},'numbertitle','off')
            subplot(2,3,d);
          
            
   
            
            
            
            colorSpikes = imgaussfilt(V.(fields{d}).spikes,gaussFilt);
            ylimits = [V.(fields{d}).range(1), V.(fields{d}).range(end)];
            xlimits = [window(1), window(end)];
            imagesc(xlimits,ylimits, colorSpikes);
            
% % % % % % % %               figHandle = gca;
% % % % % % % %             ax1_pos = figHandle.Position;
% % % % % % % %             ax1 = gca; % current axes
% % % % % % % % ax1.XColor = 'k';
% % % % % % % % ax1.YColor = 'k';
% % % % % % % % ax1_pos = ax1.Position; % position of first axes
% % % % % % % % ax2 = axes('Position',ax1_pos,...
% % % % % % % %     'XAxisLocation','top',...
% % % % % % % %     'YAxisLocation','right',...
% % % % % % % %     'Color','none');
% % % % % % % %             
% % % % % % % %             
            hold on

            normSampleCounts = (V.(fields{d}).counts)* normSizeSampleCount/max(V.(fields{d}).counts);
            if normalizeTHEsampleCountHistogram == 1 %normalization switch
            plot (normSampleCounts + XshiftSampleCount,(V.(fields{d}).range), 'r'); 
            else
            plot (V.(fields{d}).counts + XshiftSampleCount,(V.(fields{d}).range), 'r');  %%if you want to plot not normalized 
            end
            colormap(gca,jet);
% % % %             set(gca,'Ydir','normal','ytick',(1:length(V.(fields{d}).range)),'yticklabel',[V.(fields{d}).range],...
% % % %                 'xtick',(0:XstepSize:length(window)),'xticklabel',[min(window):XstepSize:max(window)],'xlim',[0 length(window)]);
% % %             for k=1:size(V.(fields{d}).counts,1)
% % %                 text(20,k,num2str(V.(fields{d}).counts(k)),'FontSize',8,'Color','white')
% % %             end


%             plot([0, 0],[V.(fields{d}).range(1), V.(fields{d}).range(end)],'w:') %plotting touch onset line 
            plot([XshiftSampleCount, XshiftSampleCount],[V.(fields{d}).range(1), V.(fields{d}).range(end)],'r:')%plotting base of the sample count histogram
            
            %             axis('square')
            xlabel('time from touch onset (ms)')
            title([fields{d}])
            
        end
        %% resize 
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, .5, 0.70]);
        
        %% save it 
       if saveON == 1 
           filename = strcat(figNames{g}, filename);
             saveas(gcf,filename,'epsc')
           
       end
    end

        

   
        
        
        
   
        

    pause()
end
