%% figure1
% this is teh touch based figure
crush
theseCells = [1, 17,  18];
TcellInds = [1 6 7 12:18 20 23 26 29 30 36:38 40, 43:45]%self selected
TexcitedCellIns = [1 6 7 16:18 26 37 43:45];% self selected 
% both touch and pole responses VVV
BothPandT = [6 1 26 45 30 20 18 17 12 8 37 14 6 10 35 7 15 38 29 33 25 43 13]
% pretouch velocity vs increase in SPK from BL period
% - Do I need to use a long BL and block out touch and other touches in
% this BL period

% pretouchVelVStouchEvokedSpikes
%%
% this uses equal num bins and goes across protraction and retraction
pretouchVelVStouchEvokedSpikes(U, TexcitedCellIns, true);

% this plots protraction andretraction seperatly 
pretouchVelVStouchEvokedSpikes_P_R(U, TexcitedCellIns, true);


pretouchVelVStouchEvokedSpikes_P_R_touchWindow(U, 1:45, V, 1);% excited
pretouchVelVStouchEvokedSpikes_P_R_touchWindow(U, 1:45, V, 0);% inhibited

pretouchVelVStouchEvokedSpikes_P_R_touchWindow(U, 1, V, 1);% excited

%%

% adaptationITI(U, TexcitedCellIns)
% adaptationITI(U, 1)
crush

theseCells = find(all(cellfun(@(x) x.isSig, V(3:4, :))));
adaptationITI_2(U, theseCells, V)

%%

adaptationITI(U, 1:45)

%%
crush
adaptationITI_line1(U, theseCells)
% THE ABOVE CAN LOOK A LOT BETTER IN THE LOG2 SCALE

% % equalAxes
%        logifyFig({'x', 'y'},2, 'equal', [], 2);
%%

% annotation('textbox', [.9, 0.5, 0, 0], 'string', 'My Text')


%%
adaptationNumTouchMaxITIlimit_V2 % this iteration resets the Touch order 
% after user setting of maxITItoInclude. I dont think I will use this
% iteration but just incase it is here. 
%%
adaptationNumTouchMaxITIlimit_V3 % this version just removes all touches
% after the ITI reaches a set point defined by the user essentially
% capturing the first whisking touching bout depending on the users
% settings 

%%
theseCells = [1, 17,  18];
first3Touches(U, theseCells)

pu_pd_T123

%%

theseCells = [1, 17,  18];
touchRasterAndPSTH(U, theseCells)

%% andrews requested fig 2 191110
%%

crush
theseCells = [1, 17,  18];

pretouchVelVStouchEvokedSpikes_touchWindow(U, theseCells, V, 2)
%%
%%

crush
theseCells = [1, 17,  18];

pretouchVelVStouchEvokedSpikes_touchWindow2(U, theseCells, V, 2)
%%
% % % % % % theseCells = [1, 17,  18];
% % % % % % kappaTuningCurveAndRaster
%% for this one the tuning curve alinges with the raster
theseCells = [1, 17,  18];
kappaTuningCurveAndRaster2
%%
modIntensityAndDirection2TouchAndPole

%%
%{

fn = 'testing'
loc1 = 'C:\Users\maire\Dropbox\HIRES_LAB\S2_project\paper Figures';
% export_fig([loc1, filesep, fn, '.eps'], '-depsc', '-painters', '-r10000', '-transparent')
export_fig([loc1, filesep, fn, '.eps'], '-depsc', '-painters', '-r1200')
fix_eps_fonts([loc1, filesep, fn, '.eps'], 'Arial')
%}
%% testing bars P
data1 = [1 8 9 8 9 7 4 2 1 2 1 2 1 2]
dataRange = [1, 10];
trials1 = 200
summary = barsP(data1,dataRange,trials1)
%%
crush
figure
hold on 

plot(data1)
plot(summary.mode)
plot(summary.mean)


