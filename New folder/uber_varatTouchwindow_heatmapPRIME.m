
[layer, txt] = loadDataNames(U);

%%
for p=1:length(U)
    close all;
    rec=p
    countThresh = 3; %min touch in each bin to be considered
    gaussFilt = [3]; %sigma filter for imgaussfilt (can be single value for filtering across rows and columns or two values [x y] for filter of row/column
    window = [-200:200]; %ms to look around touch
    
    [varspikes, preDvarspikes,postDvarspikes] = assist_varAtTouch(U{rec},window);
    % First 6 columns will be values for the variables
    % 1) THETA
    % 2) PRE TOUCH VELOCITY
    % 3) AMP
    % 4) SETPOINT
    % 5) PHASE
    % 6) MAX KAPPA    
    % Last columns will be the spikes around your given window
    
    comp={varspikes, preDvarspikes, postDvarspikes};
    for g = 1:length(comp)
        %%
        %Plot theta at touch
        fields = [  {'theta'}        {'velocity'}       {'amplitude'}    {'setpoint'}     {'phase'}               {'kappa'}];
        V.bounds = [{[-99.5:1:99.5]} {[-9750:50:9750]} {[-99.5:.5:99.5]} {[-99.5:.5:99.5]} {linspace(-pi,pi,180)} {[-.95:.005:.95]}];
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
            V.(fields{d}).range = trims(:,1);
            V.(fields{d}).spikes=cell2mat(cellfun(@(x) mean(x,1),sorted,'uniformoutput',0));
            V.(fields{d}).spikes=V.(fields{d}).spikes(indexHasTheta==1,:);
            
            %Trimming bins with touchcounts below thresholds
            mintouches=find(V.(fields{d}).counts<countThresh);
            V.(fields{d}).counts(mintouches,:)=[];
            V.(fields{d}).spikes(mintouches,:)=[];
            V.(fields{d}).range(mintouches,:)=[];
            
            %Plotting features
            figure(30+g);subplot(2,3,d);
            imagesc(imgaussfilt(V.(fields{d}).spikes,gaussFilt,'padding','replicate'));colormap(gca,parula);
            set(gca,'Ydir','normal','ytick',(1:length(V.(fields{d}).range)),'yticklabel',[V.(fields{d}).range],...
                'xtick',(0:25:length(window)),'xticklabel',[min(window):25:max(window)],'xlim',[0 length(window)]);
            for k=1:size(V.(fields{d}).counts,1)
                text(20,k,num2str(V.(fields{d}).counts(k)),'FontSize',8,'Color','white')
            end
            hold on;plot([sum(window<0) sum(window<0)],[length(V.(fields{d}).range) 0],'w:')
            axis('square')
            xlabel('time from touch onset (ms)')
            title([fields{d}])
        end
      
    end
    pause
end
