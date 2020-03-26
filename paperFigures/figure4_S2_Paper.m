%%


%% look at the response in SPK for pole up vs pole down
% C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\POLE\code
poleUP_vs_poleDOWN(U, pole, V, 1:length(U))


%% simple rasters and psth's 
theseCells = [1,17,18];
poleUpDownResponse

%%
crush
theseCells = [1,17,18];

PoleSoundEffectOnTouch

%% this incorporates the pole responses 


crush
theseCells = [1,17,18];

PoleSoundEffectOnTouch_withPoleResponseAndWindow
%%
saveOn = false
poleSTDvariableEarlyTouchRemoval
%%


tmp12 = ones(size(spikes));
tmp12(allMask) = 0;
figure
imagesc(tmp12)
%% shows the delay from poel onset tuning with the theta and amp and kappa tuning 

PoleSoundEffectOnTouch_withOtherTuningCurves