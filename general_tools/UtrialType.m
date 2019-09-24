%{



[trialTypes, trialTypeNames] = UtrialType(U)


%}


function [TT, trialTypeNames] = UtrialType(U2)

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
    };
theseCells = 1:length(U2);
TT = {};
for cellStep = theseCells
    TT{cellStep}.go = U2{cellStep}.meta.trialType==1;%all trials that are go
    TT{cellStep}.nogo = U2{cellStep}.meta.trialType==0;%all trials that are nogo
    TT{cellStep}.correct = U2{cellStep}.meta.trialCorrect==1;
    TT{cellStep}.incorrect = U2{cellStep}.meta.trialCorrect==0;
    TT{cellStep}.lick = (TT{cellStep}.go.*TT{cellStep}.correct)+(TT{cellStep}.nogo.*TT{cellStep}.incorrect);
    TT{cellStep}.nolick =TT{cellStep}.lick==0;
    TT{cellStep}.hit = (TT{cellStep}.go.*TT{cellStep}.correct);
    TT{cellStep}.corrRej=(TT{cellStep}.nogo.*TT{cellStep}.correct);
    TT{cellStep}.falseAlarm = TT{cellStep}.nogo.*TT{cellStep}.incorrect;
    TT{cellStep}.miss = TT{cellStep}.go.*TT{cellStep}.incorrect;
    
    trialTypes = [];
    trialTypes(1:length(TT{cellStep}.go), 1) =TT{cellStep}.go(:);%1
    trialTypes(1:length(TT{cellStep}.go), end+1) = TT{cellStep}.nogo(:);%2
    trialTypes(1:length(TT{cellStep}.go), end+1) = TT{cellStep}.correct(:);%3
    trialTypes(1:length(TT{cellStep}.go), end+1) = TT{cellStep}.incorrect(:);%4
    trialTypes(1:length(TT{cellStep}.go), end+1)= TT{cellStep}.lick(:);%5
    trialTypes(1:length(TT{cellStep}.go), end+1)=TT{cellStep}.nolick(:);%6
    trialTypes(1:length(TT{cellStep}.go), end+1) = TT{cellStep}.hit(:);%7
    trialTypes(1:length(TT{cellStep}.go), end+1)=TT{cellStep}.corrRej(:);%8
    trialTypes(1:length(TT{cellStep}.go), end+1)=  TT{cellStep}.falseAlarm(:);%9
    trialTypes(1:length(TT{cellStep}.go), end+1)=TT{cellStep}.miss(:);%10
end