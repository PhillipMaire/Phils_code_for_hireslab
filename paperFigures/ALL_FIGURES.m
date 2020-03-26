%%    load(OSconv('Z:\Users\Phil\Data\Characterization\S2BadContacts2\U_191028_1154.mat'))
%%    load('C:\Users\maire\Dropbox/U_191028_1154.mat')

%%    load('/Users/phillipmaire/Dropbox/U_191028_1154.mat')
%% load('C:\Users\maire\Downloads\excitatory_all.mat')
%%
if ismac
    base1 = '/Users/phillipmaire/';
    load('/Users/phillipmaire/Dropbox/U_191028_1154.mat')
else
    load('C:\Users\maire\Dropbox/U_191028_1154.mat')
    base1 = 'C:\Users\maire\';
end

%%
U = msAndRoundUarray(U, 'ms');%turn units into ms time units
% % % U = msAndRoundUarrayJON(U, 'ms');

%% AllWhiskingOnsetTimes.m
%   [OnsetsALL_CELLS] = AllWhiskingOnsetTimes(U, 1:length(U))
dateNum1 = '190917';
load(OSconv([base1, 'Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\OnsetsALL_CELLS_', dateNum1,'.mat']))
for k = 1:length(U)
    U{k}.whiskOnset = OnsetsALL_CELLS{k};
end

%% date num 2 load

dateNum1 = '191017_1429'
dateNum1 = '191018_1607';
dateNum1 = '191223_1304';
dateNum1 = '200103_1151';

%%
%touchSTD.m
load(OSconv([base1, 'Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\', dateNum1, '_allCellsTouch.mat']))


%%
% poleSTD.m
load(OSconv([base1, 'Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\', dateNum1, '_pole.mat']))
%% whiskingVariablesTuningWithMasksEqualBins_bootstrap_noAnova.m
% dateNum = '191014_1551';
load(OSconv([base1, 'Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\', dateNum1, '_Whisk.mat']))

% plotmodindexandthesortedheatmapofnormalizedresponses.m
load(OSconv([base1, 'Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\', dateNum1, '_V.mat']))
modIntensityAndDirection2TouchAndPole

%% modulation_sig_vs_BL_simpleWhisking.m
load(OSconv([base1, 'Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\', dateNum1, '_allWhiskingVar.mat']))


%% THIS IS SET FOR ALL OTHER PROGRAMS THAT YOU SAVE
dateString1 = datestr(now,'yymmdd_HHMM');
%% whisking variables tuning (also writes the Whisk variable above)

saveDir = 'C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\freeWhisking';
cd(saveDir)
whiskingVariablesTuningWithMasksEqualBins_bootstrap_noAnova
%%


saveDir = 'C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\heatmaps';
saveOn = true
plotmodindexandthesortedheatmapofnormalizedresponses
%% Pole
saveOn = 0
saveDir = 'C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\POLE';
cd(saveDir)
poleSTD

%% touch

saveOn = 0
saveDir = 'C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\TOUCH';
cd(saveDir)
touchSTD
%% ##############modulation
%% whisking  modulation
saveOn = 1;
saveDir = 'C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\modulation';
cd(saveDir)
simpleWhiskingModulation
%% publish('simpleWhiskingModulation',['simpleWhiskingModulation_', dateString1] , 'pdf')
%% modulation for touch pole up and pole down
saveOn = 1;
saveDir = 'C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\modulation';
cd(saveDir)

modulation_sig_vs_BL
%% protraction vs retraction response
saveOn = 0;
saveDir = 'C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\TOUCH';
cd(saveDir)
protractionVSretraction

%%

% edit plotmodindexandthesortedheatmapofnormalizedresponses.m
%%
saveOn = 0;
saveDir = 'C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\heatmaps';
cd(saveDir)
plotmodindexandthesortedheatmapofnormalizedresponses
%%
saveOn = 0;
saveDir = 'C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\depthPlots';
cd(saveDir)

spikerateVSdepth
%% cell response to each type

tmp1 = PU_PD_T_AMP~=0;
touchAndPoleInds = savedIndsFortheResponsePropMap((tmp1(1, :) | tmp1(2, :))&(tmp1(3, :)));

allTouchCells = find(tmp1(3, :))
%% save the variables

savVariablesAndPrograms
%% WORKING ON THESE/ NOT YET SORTED


%% gray and red showing how number of spikes change compared to random 
% -also shows the psth of random vs real for the selected spike bins, which gives some perspectice
% on the limitations and advantages of the method
% - also has tuning curves for a few variables agains random I think its cool but jinho thinks it
% doesnt really show anything more than a normal tuning curve. my argument is that it shows large
% bursting and large inhibitory events that can give us an idea of the real tuning as opposed to
% correlated tuning. 

% OLD changeInSpikesPerTouchVariableAssesment

changeInSpikesPerTouchVariableAssesment2 
%%
testingE_IBALANCE_randDist2

%%
changeInSpikesPerTouchVariableAssesment3_simple
%%
testingTouchTuningVars2_binSubtractedBL
%%
testingTouchTuningVars2

%%



testingTouchTuningVars2_binSubtractedBL.m
%%

whiskingTuningModDepth

%%

depthOnsetOffsetPeakANDdirection





