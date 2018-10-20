%% POLE UP
saveDir =  'C:\Users\maire\Documents\PLOTS\S2\whisker variables\aligned to PoleUp' ;
saveStringAddOn =  'whiskVars'  ;

for cellStep = 1:length(U)
    phaseVar = squeeze(U{cellStep}.S_ctk(5, :, :));
    ampVar =squeeze(U{cellStep}.S_ctk(3, :, :));
    thetaVar =      squeeze(U{cellStep}.S_ctk(1, :, :));
    figure;
    plot(nanmean(phaseVar(:,:),2))
    hold on
    plot(nanmean(ampVar(:,:),2))
    plot(nanmean(thetaVar(:,:),2))
    keyboard
    cellInfoTitle ; %creates cell title name
    tmpTitle = title(cellTitleName);
    set(tmpTitle, 'Units','normalized');
    set(tmpTitle, 'Position', [.5, .9]);
    keyboard
    numWithLeadZeros =  sprintf('%04d',cellStep);
    filename = [saveDir, filesep,numWithLeadZeros,'_', saveStringAddOn];
    saveas(gcf,filename,'png')
    close all hidden
end

%%
%% POLE DOWN

saveDir =  'C:\Users\maire\Documents\PLOTS\S2\whisker variables\alignedPoleDownZOOMgrid' ;
mkdir(saveDir);
saveStringAddOn =  'whiskVarsAlignedPoleDown'  ;
clear shiftToZero
for cellStep = 1:length(U)
    phaseVar = squeeze(U{cellStep}.S_ctk(5, :, :));
    ampVar =squeeze(U{cellStep}.S_ctk(3, :, :));
    thetaVar =      squeeze(U{cellStep}.S_ctk(1, :, :));
    phaseVar = shiftToZero( phaseVar .* U{cellStep}.filters.filters.filter6_1);
    ampVar = shiftToZero( ampVar .* U{cellStep}.filters.filters.filter6_1);
    thetaVar = shiftToZero( thetaVar .* U{cellStep}.filters.filters.filter6_1);
    
    figure;
    plot(nanmean(phaseVar(:,:),2))
    hold on
    plot(nanmean(ampVar(:,:),2))
    plot(nanmean(thetaVar(:,:),2))
    xlimVar = 125;
    xlim([0 xlimVar]);
    xticks(0:5:xlimVar);
    grid;
    
    cellInfoTitle ; %creates cell title name
    tmpTitle = title(cellTitleName);
    set(tmpTitle, 'Units','normalized');
    set(tmpTitle, 'Position', [.5, .9]);
    numWithLeadZeros =  sprintf('%04d',cellStep);
    filename = [saveDir, filesep,numWithLeadZeros,'_', saveStringAddOn];
    keyboard
    saveas(gcf,filename,'png')
    close all hidden
end

