%% Whisking quantification
lookbackwndw=50;

for cellStep = 1:length(U)
    cellStep
    %     masks =  assist_touchmasks(U{d});
    responses =  squeeze(U{cellStep}.R_ntk);
    filterToUse = U{cellStep}.filters.filters.polePosition{end};
    responses = responses.* filterToUse;
    %         responses=responses.*masks.touch;
    responses(1:lookbackwndw,:)=0;
    U{1, 1}.filters.filters.noFilter
    responseIdx = find(responses==1);
    figure(380);clf
    stimVals = [1 2 3 4 5 6];
    
    for g = 1:length(stimVals)
        
        stimuli = squeeze(U{cellStep}.S_ctk(stimVals(g),:,:));
        
        raw = zeros(length(responseIdx),lookbackwndw);
        avgs = zeros(1,lookbackwndw);
        for n = 1:length(responseIdx)
            stimIdx = responseIdx(n)-lookbackwndw+1 : responseIdx(n);
            
            if sum(isnan(stimuli(stimIdx)))>0
                disp('Skipping spike b/c NaN value')
            else
                raw(n,:) = stimuli(stimIdx);
                avgs = avgs+stimuli(stimIdx);
            end
        end
        
        
        
        figure(380);
        subplot(2,3,g)
        boundedline(1:lookbackwndw,mean(raw),std(raw));
        set(gca,'xtick',0:10:50,'xticklabel',-50:10:0,'xlim',[0 50])
    end
    cellInfoTitle
    tmpTitle = title(cellTitleName);
    set(tmpTitle, 'Units','normalized');
    set(tmpTitle, 'Position', [.5, .9]);
    directoryString = 'C:\Users\maire\Documents\PLOTS\S2\STA';
    mkdir(directoryString)
    filename = [directoryString, filesep, 'STA', ' cell_', projectCellNum];
    saveas(gcf,filename,'png')
    savefig(filename)
    close all
    %     directoryString = 'C:\Users\Public\Documents';
    %     cd(directoryString);
    %     dateString = datestr(now,'yymmdd_HHMMSS');
    %     saveName = [directoryString, filesep, , dateString];
    %     save(saveName)
    
end

