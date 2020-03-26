%%


[OnsetsALL_CELLS] = AllWhiskingOnsetTimes(BV, 1:length(BV))
%%

figure; hist(OnsetsALL_CELLS{2}.trialTimeONSETS)
%%
maxPoleTime = 300;
[out1] = SPmaker(5,3);
medWhisk = [];
for i = 1:length(BV)
    
  
    pOnset = round(mean(BV{i}.meta.poleOnset)*1000);
    goodWhiskINDS = (OnsetsALL_CELLS{i}.trialTimeONSETS<(pOnset+maxPoleTime)).* ...
        (OnsetsALL_CELLS{i}.trialTimeONSETS>(pOnset));

    
      [~,ia,~] = unique(OnsetsALL_CELLS{i}.trialNums);
         goodWhiskINDS =  intersect(ia, find(goodWhiskINDS));
      
    goodWhisks = OnsetsALL_CELLS{i}.trialTimeONSETS(goodWhiskINDS);

    medWhisk(i) = median(goodWhisks) - pOnset;
    meanWhisk(i) = mean(goodWhisks) - pOnset;
    
    
    [out1] = SPmaker(out1);
    hist(goodWhisks-pOnset)
end
%%

OnsetsALL_CELLS{i}.segmentsFinal