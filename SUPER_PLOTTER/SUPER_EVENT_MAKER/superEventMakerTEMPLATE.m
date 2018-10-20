%% for touches 
for cellStep = 1:length(U)
    cellTMP = U{cellStep};
   touchFirstOnset = find(squeeze(cellTMP.S_ctk(9,:,:))==1);
    touchLateOnset = find(squeeze(cellTMP.S_ctk(12,:,:))==1);
%         touchLateOnset = touchFirstOnset(1); % plot only the first touches
    allTouches = sort([touchFirstOnset; touchLateOnset]);
    U{cellStep}.allTouches = allTouches;
end
%%
tic
[ultimateStruct]  =  superEventMaker(U, '.allTouches', 100, -50);
toc
%%
subplotMakerNumber = 1; subplotMaker;
for k = 1:length(ultimateStruct)
    cellTMP = U{k};
    spikes = squeeze(cellTMP.R_ntk) .* 1000;
    tmpVar = ultimateStruct{k}.Mat;
    tmp = tmpVar(:,1);
    tmp2 = repmat(tmp, [1,  100]) + repmat(0:99, [length(tmp), 1]);
    
    subplotMakerNumber = 2; subplotMaker;
  toPlot = spikes(tmp2);
  toPlot = nanmean(toPlot);
  plot(-49:50, toPlot);
    
end

%%
tic
[ultimateStruct]  =  superEventMaker(U, '.meta.beamBreakTimesMat');
toc

%%
tic
[ultimateStruct]  =  superEventMaker(U, '.meta.beamBreakTimesMat');
toc

%% this example we only get periods of amplitude greater than 4 
for k = 1:length(U)
cellInput{k} = squeeze(U{k}.S_ctk(3,:,:)) > 4;
disp(k)
end
%%

%%
tic 
[ampAbove4.start]  =  superEventMaker(U, cellInput, 'first');
toc
tic
[ampAbove4.end]  =  superEventMaker(U, cellInput, 'last');
toc

ampAbove4.start{1}.MatNames
linIndsOfAmp4ContiniousEvents = [ampAbove4.start{1}.Mat(:,1), ampAbove4.end{1}.Mat(:,1)];
% these are are the lin inds of continious whisking above 4 (continious string of 1's) 
% in the matrix that we fed into the builder. 
indsOfAmp4ContiniousEvents = [ampAbove4.start{1}.Mat(:,1), ampAbove4.end{1}.Mat(:,1)];
%% can multipley the index for the first and last array to get common points that match you required 


%%
for k = 1:length(U)
cellInput2{k} = squeeze(U{k}.S_ctk(5,:,:)) > -3;
disp(k)
end
%%
tic
[ultimateStruct]  =  superEventMakerINDEXover4000dontELIMINATE(U, cellInput2, 'first', 50, 50);
toc
%%
test = cellInput{1};
find(isnan(test))
%%
tic
[ultimateStruct]  =  superEventMaker(U, '.meta.beamBreakTimesMat');
toc



%%
for k = 1:U{1, 6}.k
    tm21 =  max(U{1, 6}.meta.beamBreakTimes{k})
    if isempty(tm21)
        test21(k) = 0;
    else
        test21(k) = tm21;
    end
end
U