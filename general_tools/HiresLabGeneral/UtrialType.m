%{



[trialTypes, trialTypeNames] = UtrialType(U)


%}


function [trialTypes, trialTypeNames] = UtrialType(U2)

trialTypeNames = {...
    'go'...
    'nogo'...
    'correct'...
    'incorrect'...
    'lick'...
    'nolick'...
    'hit'...
    'corrRej'...
    'falseAlarm'...
    'miss'...
    }
theseCells = 1:length(U2);
for cellStep = theseCells
    go = U2{cellStep}.meta.trialType==1;%all trials that are go
    nogo = U2{cellStep}.meta.trialType==0;%all trials that are nogo
    correct = U2{cellStep}.meta.trialCorrect==1;
    incorrect = U2{cellStep}.meta.trialCorrect==0;
    lick = (go.*correct)+(nogo.*incorrect);
    nolick =lick==0;
    hit = (go.*correct);
    corrRej=(nogo.*correct);
    falseAlarm = nogo.*incorrect;
    miss = go.*incorrect;
    
    trialTypes = [];
    trialTypes(1:length(go), 1) =go(:);%1
    trialTypes(1:length(go), end+1) = nogo(:);%2
    trialTypes(1:length(go), end+1) = correct(:);%3
    trialTypes(1:length(go), end+1) = incorrect(:);%4
    trialTypes(1:length(go), end+1)= lick(:);%5
    trialTypes(1:length(go), end+1)=nolick(:);%6
    trialTypes(1:length(go), end+1) = hit(:);%7
    trialTypes(1:length(go), end+1)=corrRej(:);%8
    trialTypes(1:length(go), end+1)= falseAlarm(:);%9
    trialTypes(1:length(go), end+1)=miss(:);%10
end