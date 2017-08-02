function output = behav_processBehavior_v3(info,hist,trim,BV,d)

%% Build a trial results matrix
% run behav_bdatawrapper first
% 1-5 Trial number, bar at go, bar at nogo, trial corrects, trials
% incorrect
% 6-10 Dprime, useTrials, session #, filled w/ 1 for trial start, motor
% position, 
% 11-12 most anterior go motor position, most anterior nogo position 

    
    trialResults = zeros(size(info.SidesSection_previous_sides,2)-1,12);
    trialResults(:,1) = 1:length(trialResults(:,1)); %trial number
    
    go =info.SidesSection_previous_sides == 114; %if pole presented go, display '1' (true)
    nogo =info.SidesSection_previous_sides == 108; %if pole presented nogo, display '1' (true)
    
    trialResults(:,3) = nogo(1:end-1); %fill nogo
    trialResults(:,2) = go(1:end-1); %fill go
    
    
    tmp = hist.AnalysisSection_PercentCorrect;
    tmp2 = zeros(length(hist.AnalysisSection_PercentCorrect)+1,1);
    for i = 1:length(tmp);
        tmp2(i+1)=tmp{i};
    end
    rew=zeros(length(hist.AnalysisSection_PercentCorrect),1);
    for i = 2:length(hist.AnalysisSection_PercentCorrect);
        if tmp2(i)>=tmp2(i-1);
            rew(i-1) = 1;
        end
    end
    trialResults(:,4) = rew(:); %trial correct
    
    fill=ones(length(trialResults(:,4)),1);
    trialResults(:,5) = (fill-trialResults(:,4));
    
    
    dprime = cat(1,hist.AnalysisSection_Dprime{:}); %concatenate cell array of dprime values to a matrix cat(dimension 1, matrix)
    trialResults(:,6)=dprime(:);
    
    trialResults(trim,7) = 1; %fill with useTrials
    trialResults(:,10)=info.MotorsSection_previous_pole_positions(1:length(info.pole_contdiscrim_obj_hit_history)); %fill 8 w/ motor positions
    trialResults(trim(1),9) = 1; %this is the trial start
    
    trialResults(1:end,11)=info.MotorsSection_yes_pole_position_ant;%most anterior GO pole pos
    trialResults(1:end,12)=info.MotorsSection_no_pole_position_ant;
          
    [~,~,~,~,~,preLickTouches] = assist_predecisionVar(BV,d);
    tmp=cellfun(@numel,preLickTouches)
    
    
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
end

