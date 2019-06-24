
% You need not run this. Called by processBatchBehaviorFMR


function output = processBehavior(S,protocalName);
%% Build a trial results matrix
% 1-5 Trial number, bar at go, bar at nogo, trial corrects, trials
% incorrect
% 6-8 Dprime, useTrials, session #
%% single port continious (regular)
if strcmp(protocalName, 'pole_contdiscrim_obj_') || strcmp(protocalName, 'pole_contdiscrim_delay_obj_')
    numVariables = 50;
    load([S.baseFolder filesep S.mouseName{1} filesep S.behavFile{1}])
% % % % % %     trialResults = zeros(size(saved.SidesSection_previous_sides,2)-1,numVariables);
    
    
    trialResults.MotorsSection_previous_pole_positions = saved.MotorsSection_previous_pole_positions;
    trialResults.SidesSection_previous_sides                      = saved.SidesSection_previous_sides; %114 is r and 108 is left
    trialResults.AnalysisSection_PercentCorrect           = saved_history.AnalysisSection_PercentCorrect;
    trialResults.AnalysisSection_HR                       = saved_history.AnalysisSection_HR;
    trialResults.AnalysisSection_FAR                      = saved_history.AnalysisSection_FAR;
    trialResults.AnalysisSection_HRMinusFAR               = saved_history.AnalysisSection_HRMinusFAR;
    trialResults.AnalysisSection_Dprime                   = saved_history.AnalysisSection_Dprime;
    trialResults.AnalysisSection_Dprime60                 = saved_history.AnalysisSection_Dprime60;
    trialResults.TimesSection_PostTrialPauseTime          = saved_history.TimesSection_PostTrialPauseTime;
    trialResults.TimesSection_ExtraITIOnError             = saved_history.TimesSection_ExtraITIOnError;
    trialResults.TimesSection_AnswerPeriodTime            = saved_history.TimesSection_AnswerPeriodTime;
    trialResults.TimesSection_PreAnswerTime               = saved_history.TimesSection_PreAnswerTime;
    trialResults.TimesSection_SamplingPeriodTime          = saved_history.TimesSection_SamplingPeriodTime;
    trialResults.TimesSection_PoleRetractTime             = saved_history.TimesSection_PoleRetractTime;
    trialResults.TimesSection_PreTrialPauseTime           = saved_history.TimesSection_PreTrialPauseTime;
    trialResults.ValvesSection_WaterValveTime             = saved_history.ValvesSection_WaterValveTime;
    trialResults.MotorsSection_motor_position             = saved_history.MotorsSection_motor_position;
    trialResults.MotorsSection_no_pole_position_ant       = saved_history.MotorsSection_no_pole_position_ant;
    trialResults.MotorsSection_no_pole_position_pos       = saved_history.MotorsSection_no_pole_position_pos;
    trialResults.MotorsSection_yes_pole_position_ant      = saved_history.MotorsSection_yes_pole_position_ant;
    trialResults.MotorsSection_yes_pole_position_pos      = saved_history.MotorsSection_yes_pole_position_pos;
    trialResults.MotorsSection_motor_move_time            = saved_history.MotorsSection_motor_move_time;
    trialResults.MotorsSection_lateral_motor_position     = saved_history.MotorsSection_lateral_motor_position;
    trialResults.RewardsSection_LastTrialEvents           = saved_history.RewardsSection_LastTrialEvents;
    
    
    
    
    output.trialResults = trialResults;
    
    
    
    
elseif protocalName == 'fix name here'
    
    %% 2 port continious
    load([S.baseFolder filesep S.mouseName{1} filesep S.behavFile{1}])
    trialResults = zeros(size(saved.SidesSection_previous_sides,2)-1,17);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%saving 16 for dprime
    trialResults(:,1) = 1:length(trialResults(:,1)); %trial number
    
    right   =       saved.SidesSection_previous_sides == 114; %if pole presented right, display '1' (true)
    left    =       saved.SidesSection_previous_sides == 108; %if pole presented left, display '1' (true)
    absent  =       saved.SidesSection_previous_sides == 97; %if pole presented absent, display '1' (true)
    miss    = rot90(saved.pole_2port_cont_plus_abs_psmobj_hit_history) == -1;
    incorr  = rot90(saved.pole_2port_cont_plus_abs_psmobj_hit_history) ==  0;
    hit     = rot90(saved.pole_2port_cont_plus_abs_psmobj_hit_history) ==  1;
    corrRej = rot90(saved.pole_2port_cont_plus_abs_psmobj_hit_history) ==  2;
    
    if length(right) == length(miss)
        warning( 'Did not subtract 1 from the SidesSection variable. maybe because saved file was corrupt')
        indValue = 1;
    else
        indValue = 0;
    end
    
    trialResults(:,2)  = right(1:end-1); %fill right
    trialResults(:,3)  = left(1:end-1); %fill left
    trialResults(:,4)  = absent(1:end-1); %fill absent
    
    trialResults(:,5)  = miss(1:end-indValue);
    trialResults(:,6)  = incorr(1:end-indValue);
    trialResults(:,7)  = hit(1:end-indValue);
    trialResults(:,8)  = corrRej(1:end-indValue);
    
    trialResults(:,9)  = right(1:end-1)+hit(1:end-indValue) ==2;
    trialResults(:,10) = right(1:end-1)+incorr(1:end-indValue) ==2;
    trialResults(:,11) = left(1:end-1)+hit(1:end-indValue) ==2;
    trialResults(:,12) = left(1:end-1)+incorr(1:end-indValue) ==2;
    trialResults(:,13) = absent(1:end-1)+corrRej(1:end-indValue) ==2;
    trialResults(:,14) = absent(1:end-1)+incorr(1:end-indValue)==2;
    
    % dprime = cat(1,saved_history.AnalysisSection_Dprime{:}); %concatenate cell array of dprime values to a matrix cat(dimension 1, matrix)
    % trialResults(:,15)=dprime(:);
    
    % for me dprime is a N by 17 mat, each row with ...
    %'NaN    NaN  n/a'
    %not sure if this is because there are no numbers or id it defaults to a
    %string for some reason. when the analysis section is complete and dprime
    %is actually correct, we can address this, possibly with str2num. -psm
    
    
    %{'Trial number', 'R_trials', 'L_trials', 'Abs_trials', 'L_or_R_miss',...
    %    'All_incorrect', 'L_or_R_hit', 'Abs_corrRej', 'R_hits', 'R_incorr',...
    %     'L_hits', 'L_incorr', 'Abs_corrRej', 'Abs_incorr', 'Good_Trials'};
    
    
    %
    %
    % dprime = cat(1,saved_history.AnalysisSection_Dprime{:});
    % %concatenate cell array of dprime values to a matrix cat(dimension 1, matrix)
    % trialResults(:,6)=dprime(:);
    
    % trialResults(S.goodTrials{1},15) = 1; %fill with useTrials
    
    
    % tmp = cat(1,saved_history.AnalysisSection_NumIgnores{:});
    % numIgnores = zeros(length(tmp),1);
    % numIgnores = str2num(tmp(:,13:16));
    %
    % trialResults(:,8) = diff([0; numIgnores]); % ignores
    %
    % tmp = cat(1,saved_history.AnalysisSection_NumRewards{:});
    % rewards = str2num(tmp(:,13:16));
    % trialResults(:,9) = diff([0; rewards]); % rewards
    %
    % trialResults(:,10) = ~trialResults(:,9)-trialResults(:,8); % errors
    %
    % trialResults(:,6) = trialResults(:,2).*trialResults(:,9)+trialResults(:,3).*trialResults(:,10);   % right licks
    % trialResults(:,7) = trialResults(:,3).*trialResults(:,9)+trialResults(:,2).*trialResults(:,10);   % right licks
    output.trialResults = trialResults;
    
    
    %%
else
    warning( 'no matching protocal was found');
    warning( 'no matching protocal was found');
    warning( 'no matching protocal was found');
    warning( '');
end