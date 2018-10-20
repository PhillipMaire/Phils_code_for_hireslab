function [singleWhiskerStruct] = whiskerOneID(whiskerNumber, whiskStuct)
%% get the index of the correct whisker

fieldNames = {'id', 'time', 'x', 'y', 'thick', 'scores'};
counter = 0;
for  kk = 1:length(whiskStuct)
    singleVal = whiskStuct(kk).(fieldNames{1});
    singleVal = double(singleVal);
    indexLin(kk) = singleVal == whiskerNumber;
    if singleVal == whiskerNumber
        counter = counter +1;
        indexReg(counter) =  kk;
    end
end
indexLin = indexLin';
indexReg = indexReg';
%% create newWhiskStruct 
 
for k = 1:length(indexReg)
    
    for kkk = 1:numel(fieldNames)
        singleWhiskStruct(k).(fieldNames{kkk}) = whiskStuct(indexReg(k)).(fieldNames{kkk});
    end
end
