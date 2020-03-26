%% instructions 
%% OLD DONT USE THIS 
% % % % % 
% % % % % % first  build the mats using the individual programs
% % % % % 
% % % % % 
% % % % % % then use the varray builder 
% % % % % 
% % % % % 
% % % % % % then use TtestMiniUcolorMap.m to make the color maps
% % % % % % then this will save some more variables so you can use those variables to make the plots easily
% % % % % 
% % % % % 
% % % % % 
% % % % % % then usw this to plot quickly mapAllThingsTrimmed_V2.m
%% licks still using this old version 

% C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\lick
% lickMap.m
%% whisking onset 

% C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\WHISKING\whiskingOnset
% AllWhiskingOnsetTimes.m
% generates this variable   OnsetsALL_CELLS.mat

% this variable is used by the following


% this uses the above variable to make the spike aligned response ignoring pole and touches 
% C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\whiskingOnsetResponse
% whiskingOnsetResponse.m 

%% touch response and struct 



% signifTestWithCurvSortingONSET_LAT

%% pole response 

% this name curve sorting is inherited from the touch program it is nonsense but the program is good

% C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\pole
% signifTestWithCurvSortingPole2ONSET_LAT.m
%%
whiskingOnsetResponse
signifTestWithCurvSortingONSET_LAT
signifTestWithCurvSortingPole2ONSET_LAT

%% this packages all the variables so you can play easier 


% C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS
% MasterVariablePack.m

% this also plots teh heat amps that are sorted... my naming sucks really bad 













%% now general plotting like heat map by depth