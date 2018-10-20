%% try to normolize the swall
% % trim
% swall
figure;
cutSpikes = [12 20]
LcutSpike = length(cutSpikes(1) : cutSpikes(2));
lengthSpike = 30;
clear normSwall
normSwalltemp2 = []
for k = 1:length(swall)
    clear normSwalltemp
    [~, LsingleSwall] = size(swall{k});
    if LsingleSwall ~= 0
        for kk = 1:LsingleSwall
            trimmedSpike = swall{k}(cutSpikes(1): cutSpikes(2),kk);
            normSignal = trimmedSpike;
            if min(trimmedSpike) < 0
                normSignal = normSignal + abs(min(normSignal));
            elseif min(trimmedSpike)>0
                normSignal = normSignal - min(normSignal);
            end
            normSignal = normSignal./(max(normSignal));
            
            normSwalltemp(1:LcutSpike,kk) = normSignal;
        end
              normSwalltemp2(:, end+1: end+LsingleSwall) = normSwalltemp;
        normSwall{k} = normSwalltemp;
        
    else
        normSwall{k} = [];
    end
    %
    %     plot(normSwall{k});
    %     waitForEnterPress
end
% % normalize to time and mV
%% make template
template = normSwall{1}(:, good{1});
template = mean(template,2);


%% correlate points
trialRvals2 = []
for k = 1:length(swall)
    clear trialRvals
    [~, LsingleSwall] = size(swall{k});
    if LsingleSwall ~= 0
        for kk = 1:LsingleSwall
            R = corrcoef(template, normSwall{k}(:,kk));
            C = cov(template, normSwall{k}(:,kk));
            R = R(2);
            trialRvals(kk) = R;
        end
        trialRvals2(end+1:end +LsingleSwall) = trialRvals;
        Rvalue{k} = trialRvals;
        
    else
        Rvalue{k} = [];
    end
    %
    %     plot(normSwall{k});
    %     waitForEnterPress
end

%%
plot(sort(trialRvals2),  'k.')
%%
figure(2)
[asdf gh] = sort(trialRvals2);
startVar = 9000
theseOnes = startVar: startVar+100;
plot(normSwalltemp2(:,gh(theseOnes)));



