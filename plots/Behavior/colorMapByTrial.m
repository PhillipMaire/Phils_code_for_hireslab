figure;plot(1:4000,U{1}.S_ctk(1,:,1))
%%%(1,:,1))
%%% variable type
%%%tiem points 
%%% trial nums

subset = [120:204];
subset = subset - 57;


allVars=U{1}.S_ctk(2,:,220-57:222-57);

test=U{1}.S_ctk(2,:,220-57);
test2= U{1}.S_ctk(2,:,221-57);
new = [test; test2];
%%
clear varsTOplot2
clear maxVar
clear meanVar
clear varsTOplot

varSelect = 3;
% time = 460:700;
time = 1:4000;
for D = 61:209
    
    
varsTOplot(D,:) = U{1}.S_ctk(varSelect,time,D);
varsTOplot2(D,:) =smooth(U{1}.S_ctk(varSelect,time,D),500);
maxVar(D,:) = max(varsTOplot(D,:));
meanVar(D,:) = mean(varsTOplot(D,:));
end
% varsTOplot(isnan(varsTOplot)) = 0;
% varsTOplot(isnan(varsTOplot)) = 0;
figure;imagesc(varsTOplot)


 

%%
figure 
plot(meanVar(trial,:))

%%
% varsTOplot3 = varsTOplot<10;


clear varsTOplot2
clear maxVar
clear meanVar
clear varsTOplot


% time = 460:700;
time = 1:4000;
trial = 303:303+35;
for D = trial
    
    
varsTOplot(D,:) = U{1}.S_ctk(2,time,D);
varsTOplot2(D,:) =smooth(U{1}.S_ctk(1,time,D),100);
maxVar(D,:) = max(varsTOplot(D,:));
meanVar(D,:) = mean(varsTOplot(D,:));
end
% varsTOplot(isnan(varsTOplot)) = 0;
% varsTOplot(isnan(varsTOplot)) = 0;
varsTOplot2 = varsTOplot2(trial,:);
varsTOplot = varsTOplot(trial,:);
figure;imagesc(varsTOplot2)

varsTOplot3 = varsTOplot<10;


%%
varsCombined = varsTOplot;
varsCombined2 = varsTOplot2;
%%

varsCombined =(varsCombined +varsTOplot)/2;
varsCombined2 =(varsCombined2 +varsTOplot2)/2;

%%
figure;imagesc(varsCombined)
figure;imagesc(varsCombined2)
%%





% U{1}.varNames
% 
% ans = 
% 
%   Columns 1 through 3
% 
%     'thetaAtBase'    'velocity'    'amplitude'
% 
%   Columns 4 through 7
% 
%     'setpoint'    'phase'    'deltaKappa'    'M0Adj'
% 
%   Columns 8 through 10
% 
%     'FaxialAdj'    'firstTouchOnset'    'firstTouchOffset'
% 
%   Columns 11 through 12
% 
%     'firstTouchAll'    'lateTouchOnset'
% 
%   Columns 13 through 15
% 
%     'lateTouchOffset'    'lateTouchAll'    'PoleAvailable'
% 
%   Column 16
% 
%     'beamBreakTimes'