% This function will find the indices of touch, the spikes around that
% touch given by the RANGE (ie -25:50ms) you provide. Lastly it'll find the
% theta, phase, amplitude, setpoint, max kappa, and pre touch velocity.

% Simple organization tool for visualizing parameters at touch onset

% OUTPUT: First 6 columns will be values for the variables 
% 1) THETA 2) AMP 3) SETPOINT 4) PHASE 5) MAX KAPPA 6) PRE TOUCH VELOCITY 
% Last columns will be the spikes around your given window 
% Will output values for ALL TOUCHES, PREDECISION TOUCHES, and POST
% DECISION TOUCHES

%INPUT: vector with time points you want to view (ie [-25:50])



function [varSpikes,prevarSpikes,postvarSpikes] = assist_varAtPoleUp(array,range,Varargin)


switch (nargin)

    case 2
        SpikeShiftValue = 0;
    case 3 
        SpikeShiftValue = Varargin(1);
end
    
wndow = numel(range);

%change filter to a single '1' where it starts 

TMPfilter = array.filters.filters.filter2_2;
newFilter = nan(size(TMPfilter));
for findStartIter = 1: size(TMPfilter,2)
newFilter(find(TMPfilter(:, findStartIter)==1, 1),findStartIter) =1;
end
%set touch ranges
touchOnIdx = find(newFilter==1);
touchOffIdx = touchOnIdx+50;
spikes = squeeze(array.R_ntk);

touchOnIdx = touchOnIdx(touchOnIdx<(numel(spikes)-range(end)));
touchOffIdx = touchOffIdx(1:length(touchOnIdx));
touchOnIdx = sort(touchOnIdx,1);
touchOffIdx = sort(touchOffIdx,1);
touchrange=horzcat(touchOnIdx,touchOffIdx);

%align spikes all around touches (-25ms:50ms after touch)
spikesAligned = zeros(numel(touchOnIdx),wndow);

for i = 1:size(spikesAligned,1)
    spikesAligned(i,:) = spikes(touchOnIdx(i)+range);
end

%building output matrix (spikes)
[preTOnIdx ,~, ~, ~ ,touchdur ,~] = assist_predecisionVar(array);
prevarAligned=cell(1,length(preTOnIdx));
preTOffIdx=cell(1,length(preTOnIdx));
for f=1:length(preTOnIdx)
    if ~isempty(preTOnIdx{f})
    preTOffIdx{f}=preTOnIdx{f}+touchdur{f}(1,:);%bulid touch offIdx to find max Dkappa during touch
    spikewin=repmat(preTOnIdx{f}',1,length(range))+repmat(range,length(preTOnIdx{f}),1); %all time pts to find spks
    for d = 1:size(spikewin,1) %used for loop to keep structure of array
    prevarAligned{f}(d,:)=array.R_ntk(:,spikewin(d,:),f);
    end 
    else
        preTOffIdx{f}=0;
    end
end

   
%%
%Design matrix for ALL touches
vartouch = zeros(numel(touchOnIdx),6);%theta 1, amp 2, setpoint 3, phase 4, max curvature 5, vel 6
touchOnIdx = touchOnIdx + SpikeShiftValue;
touchOnIdx = touchOnIdx(~(touchOnIdx<1));

touchOffIdx = touchOffIdx + SpikeShiftValue;
touchOffIdx = touchOffIdx(~(touchOffIdx<1));

for i = 1:length(touchOnIdx)
    vartouch(i,1)=array.S_ctk(1,touchOnIdx(i)); %theta at touch
    vartouch(i,3)=array.S_ctk(3,touchOnIdx(i)); %amp at at touch
    vartouch(i,4)=array.S_ctk(4,touchOnIdx(i)); %setpoint at touch
    vartouch(i,5)=array.S_ctk(5,touchOnIdx(i)); %phase at touch
        kwin=array.S_ctk(6,touchOnIdx(i):touchOffIdx(i)); %get values in touch window
        [~ ,maxidx] = max(abs(kwin)); %find idx of max kappa within each touch window, neg or pos
    vartouch(i,6)=kwin(maxidx); %use idx to pull max kappa
    vartouch(i,2)=mean(array.S_ctk(2,touchOnIdx(i)-5:touchOnIdx(i)-1)); %finds mean of velocity (-4:-1ms) before touch
end


%building design matrix(features)for PRELICK(excluding any before answer period) touches 
vardesign=cell(1,length(preTOnIdx));
vars=[1 3 4 5];
for k=1:length(preTOnIdx)
    for g = 1:length(vars)
    vardesign{k}(:,vars(g))=array.S_ctk(vars(g),preTOnIdx{k},k); %just find val of theta, amp,setpoint, and phase at touch
    end
    for f=1:length(preTOnIdx{k}) %for each individual touch during that trial
        kappawin=preTOnIdx{k}(f):preTOffIdx{k}(f); %window for max kappa extraction (touchOn:touchOff)
        velwin=preTOnIdx{k}(f)-5:preTOnIdx{k}(f)-1; %window for mean vel pre touch extraction (touchON-5:touchOn-1)
        vardesign{k}(f,6)=max(abs(array.S_ctk(6,kappawin,k)));
        vardesign{k}(f,2)=nanmean(array.S_ctk(2,velwin,k));
    end
end

%mash variables and spikes into a single matrix
varSpikes=horzcat(vartouch,spikesAligned);
prevarSpikes=cellfun(@(x,y) cat(2,x,y), vardesign,prevarAligned,'uniformoutput',0); %structure that still maintains trial, where each cell = 1 trial, could use in future for go/nogo/hit/miss/etc... analysi
prevarSpikes=prevarSpikes(~cellfun('isempty',prevarSpikes)); %remove empty cells  
prevarSpikes=cat(1,prevarSpikes{:});

post=ismember(varSpikes,prevarSpikes,'rows');%elim rows in ALL that are same as Pre to find Post
postvarSpikes=varSpikes(~post,:);


