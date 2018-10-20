%%

hold on
cellStep = 1;
phaseVar = squeeze(U{cellStep}.S_ctk(5, :, :));
velVar =squeeze(U{cellStep}.S_ctk(2, :, :))./100;
thetaVar =      squeeze(U{cellStep}.S_ctk(1, :, :));
% thetaVar = [zeros(1,size(thetaVar,2)); diff(thetaVar)];
% thetaVar = thetaVar.*10;
% thetaVar = diff(thetaVar);


poleOnsetsTMP = U{cellStep}.meta.poleOnset;
%%
close all
figure(10)
startTrial = 30
for trialNumber = startTrial:size( thetaVar,2)
    xTOplot =(1:length(phaseVar(:,trialNumber))) - poleOnsetsTMP(trialNumber);
    baslineIND = (poleOnsetsTMP(trialNumber)-200):poleOnsetsTMP(trialNumber);
    %     phaseTOplot= phaseVar(:,trialNumber) - mean(phaseVar(baslineIND, trialNumber));
    %     ampTOplot= ampVar(:,trialNumber) - mean(ampVar(baslineIND, trialNumber));
    thetaTOplot = thetaVar(:,trialNumber) - mean(thetaVar(baslineIND, trialNumber));
    phaseTOplot= phaseVar(:,trialNumber);
    ampTOplot= velVar(:,trialNumber);
    
%     plot(xTOplot, phaseTOplot, 'b-')


%     plot(xTOplot, ampTOplot, '-r');
    plot(xTOplot, thetaTOplot, 'g-');
        hold on
    poleUpLineRange = -40:40;
    plot(ones(length(poleUpLineRange)).*0, poleUpLineRange, '-k')
    
    
    ylim([-10 30]);
    xlim([-20, 200]);
    xticks(-20:20:200);
    grid;
    keyboard
%         pause(0.2)
%     hold off
end
%%
diff