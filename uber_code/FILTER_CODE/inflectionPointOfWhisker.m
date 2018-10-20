%%

hold on 
phaseVar = squeeze(U{cellStep}.S_ctk(5, :, :));
ampVar =squeeze(U{cellStep}.S_ctk(3, :, :));
thetaVar =      squeeze(U{cellStep}.S_ctk(1, :, :));
poleOnsetsTMP = U{cellStep}.meta.poleOnset;
%%
trialNumber = 1;
figure

for trialNumber = 1:size( thetaVar,2)
plot(phaseVar(:,trialNumber))
hold on
plot(ampVar(:,trialNumber))
plot(thetaVar(:,trialNumber), 'g-');
plot(poleOnsetsTMP(trialNumber), 0, '*k')


xlimVar = poleOnsetsTMP(trialNumber)+400;
xlim([poleOnsetsTMP(trialNumber)-200, xlimVar]);
xticks(poleOnsetsTMP(trialNumber)-200:20:xlimVar);
grid;
keyboard
hold off
end
%%
