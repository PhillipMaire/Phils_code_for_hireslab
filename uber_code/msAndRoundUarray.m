%%
function [newU] = msAndRoundUarray(newU, type)
%%
%%

switch type
    
    case 'ms'
        multiplyBy = 1000;
        for cellStep2 = 1:length(newU)
            if ~(newU{cellStep2}.meta.poleOnset(1) < 10)
                warning('already in ms')
                return
            end
            newU{cellStep2}.meta.poleOnset = round(newU{cellStep2}.meta.poleOnset .* multiplyBy);
            newU{cellStep2}.meta.poleOffset = round(newU{cellStep2}.meta.poleOffset .* multiplyBy);
            newU{cellStep2}.meta.trialStartTime  = round(newU{cellStep2}.meta.trialStartTime  .* multiplyBy);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %     newU{cellStep2}.meta.samplingPeriodTime
            for iiii = 1: length(newU{cellStep2}.meta.samplingPeriodTime); newU{cellStep2}.meta.samplingPeriodTime{iiii} = round(newU{cellStep2}.meta.samplingPeriodTime{iiii}.*multiplyBy); end
            %     newU{cellStep2}.meta.answerPeriodTime
            for iiii = 1: length(newU{cellStep2}.meta.answerPeriodTime); newU{cellStep2}.meta.answerPeriodTime{iiii} = round(newU{cellStep2}.meta.answerPeriodTime{iiii}.*multiplyBy); end
            %     newU{cellStep2}.meta.beamBreakTimes
            for iiii = 1: length(newU{cellStep2}.meta.beamBreakTimes ); newU{cellStep2}.meta.beamBreakTimes{iiii} = round(newU{cellStep2}.meta.beamBreakTimes{iiii}.*multiplyBy); end
            %     newU{cellStep2}.meta.drinkingTime(end)
            for iiii = 1: length(newU{cellStep2}.meta.drinkingTime); newU{cellStep2}.meta.drinkingTime{iiii} = round(newU{cellStep2}.meta.drinkingTime{iiii}.*multiplyBy); end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %     newU{cellStep2}.meta.answerLickTime
            newU{cellStep2}.meta.answerLickTime = round(newU{cellStep2}.meta.answerLickTime  .* multiplyBy);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %     newU{cellStep2}.meta.beamBreakTimesMat
            newU{cellStep2}.meta.beamBreakTimesMat = reshape(round(newU{cellStep2}.meta.beamBreakTimesMat .* multiplyBy), size(newU{cellStep2}.meta.beamBreakTimesMat));
            %     newU{cellStep2}.meta.beamBreakTimesCell
            for iiii = 1: length(newU{cellStep2}.meta.beamBreakTimesCell); newU{cellStep2}.meta.beamBreakTimesCell{iiii} = round(newU{cellStep2}.meta.beamBreakTimesCell{iiii}.*multiplyBy); end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % newU{cellStep2}.meta.timeoutPeriodStart
            newU{cellStep2}.meta.timeoutPeriodStart =round(newU{cellStep2}.meta.timeoutPeriodStart .* multiplyBy);
            % newU{cellStep2}.meta.timeoutPeriodEnd
            newU{cellStep2}.meta.timeoutPeriodEnd = round(newU{cellStep2}.meta.timeoutPeriodEnd .* multiplyBy);
        end
        %%
    case 'sec'
        multiplyBy = 1/1000;
        for cellStep2 = 1:length(newU)
            if (newU{cellStep2}.meta.poleOnset(1) < 10)
                warning('already in sec');
                return
            end
            newU{cellStep2}.meta.poleOnset = (newU{cellStep2}.meta.poleOnset .* multiplyBy);
            newU{cellStep2}.meta.poleOffset = (newU{cellStep2}.meta.poleOffset .* multiplyBy);
            newU{cellStep2}.meta.trialStartTime  = (newU{cellStep2}.meta.trialStartTime  .* multiplyBy);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %     newU{cellStep2}.meta.samplingPeriodTime
            for iiii = 1: length(newU{cellStep2}.meta.samplingPeriodTime); newU{cellStep2}.meta.samplingPeriodTime{iiii} = (newU{cellStep2}.meta.samplingPeriodTime{iiii}.*multiplyBy); end
            %     newU{cellStep2}.meta.answerPeriodTime
            for iiii = 1: length(newU{cellStep2}.meta.answerPeriodTime); newU{cellStep2}.meta.answerPeriodTime{iiii} = (newU{cellStep2}.meta.answerPeriodTime{iiii}.*multiplyBy); end
            %     newU{cellStep2}.meta.beamBreakTimes
            for iiii = 1: length(newU{cellStep2}.meta.beamBreakTimes ); newU{cellStep2}.meta.beamBreakTimes{iiii} = (newU{cellStep2}.meta.beamBreakTimes{iiii}.*multiplyBy); end
            %     newU{cellStep2}.meta.drinkingTime(end)
            for iiii = 1: length(newU{cellStep2}.meta.drinkingTime); newU{cellStep2}.meta.drinkingTime{iiii} = (newU{cellStep2}.meta.drinkingTime{iiii}.*multiplyBy); end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %     newU{cellStep2}.meta.answerLickTime
            newU{cellStep2}.meta.answerLickTime = (newU{cellStep2}.meta.answerLickTime  .* multiplyBy);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %     newU{cellStep2}.meta.beamBreakTimesMat
            newU{cellStep2}.meta.beamBreakTimesMat = reshape((newU{cellStep2}.meta.beamBreakTimesMat .* multiplyBy), size(newU{cellStep2}.meta.beamBreakTimesMat));
            %     newU{cellStep2}.meta.beamBreakTimesCell
            for iiii = 1: length(newU{cellStep2}.meta.beamBreakTimesCell); newU{cellStep2}.meta.beamBreakTimesCell{iiii} = (newU{cellStep2}.meta.beamBreakTimesCell{iiii}.*multiplyBy); end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % newU{cellStep2}.meta.timeoutPeriodStart
            newU{cellStep2}.meta.timeoutPeriodStart =(newU{cellStep2}.meta.timeoutPeriodStart .* multiplyBy);
            % newU{cellStep2}.meta.timeoutPeriodEnd
            newU{cellStep2}.meta.timeoutPeriodEnd = (newU{cellStep2}.meta.timeoutPeriodEnd .* multiplyBy);
        end
        %%
end
end

%
%
%
% for iiii = 1: length(SWITCH_REPLACE); SWITCH_REPLACE{iiii} = round(SWITCH_REPLACE{iiii}.*multiplyBy); end
% for iiii = 1: length(SWITCH_REPLACE); SWITCH_REPLACE{iiii} = round(SWITCH_REPLACE{iiii}.*multiplyBy); end
% for iiii = 1: length(SWITCH_REPLACE); SWITCH_REPLACE{iiii} = round(SWITCH_REPLACE{iiii}.*multiplyBy); end
% for iiii = 1: length(SWITCH_REPLACE); SWITCH_REPLACE{iiii} = round(SWITCH_REPLACE{iiii}.*multiplyBy); end
% for iiii = 1: length(SWITCH_REPLACE); SWITCH_REPLACE{iiii} = round(SWITCH_REPLACE{iiii}.*multiplyBy); end
% for iiii = 1: length(SWITCH_REPLACE); SWITCH_REPLACE{iiii} = round(SWITCH_REPLACE{iiii}.*multiplyBy); end
% for iiii = 1: length(SWITCH_REPLACE); SWITCH_REPLACE{iiii} = round(SWITCH_REPLACE{iiii}.*multiplyBy); end
% for iiii = 1: length(SWITCH_REPLACE); SWITCH_REPLACE{iiii} = round(SWITCH_REPLACE{iiii}.*multiplyBy); end
%
%
%
%
% SWITCH_REPLACE =round(SWITCH_REPLACE .* multiplyBy);
% SWITCH_REPLACE =round(SWITCH_REPLACE .* multiplyBy);
% SWITCH_REPLACE =round(SWITCH_REPLACE .* multiplyBy);
% SWITCH_REPLACE =round(SWITCH_REPLACE .* multiplyBy);
% SWITCH_REPLACE =round(SWITCH_REPLACE .* multiplyBy);
% SWITCH_REPLACE =round(SWITCH_REPLACE .* multiplyBy);
% SWITCH_REPLACE =round(SWITCH_REPLACE .* multiplyBy);
% SWITCH_REPLACE =round(SWITCH_REPLACE .* multiplyBy);