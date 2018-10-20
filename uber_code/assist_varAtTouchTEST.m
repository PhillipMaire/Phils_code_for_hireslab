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



function [varSpikes, EventTimeAndTrial] = assist_varAtTouch(varNumber, array,range,Varargin)
MinNumVars = 3; 
switch (nargin)

    case MinNumVars
        SpikeShiftValue = 0;
    case MinNumVars +1 
        SpikeShiftValue = Varargin(1);
end
    
wndow = numel(range);

%set touch ranges
[EventTimeRow, EventTrialCol] = find(squeeze(array.S_ctk(varNumber,:,:)==1));

EventOnIdx = EventTimeRow+((EventTrialCol-1)*4000);
EventTimeAndTrial = horzcat(EventTimeRow, EventTrialCol);


EventOffIdx = EventOnIdx;
spikes = squeeze(array.R_ntk);

EventOnIdx = EventOnIdx(EventOnIdx<(numel(spikes)-range(end)));
EventOffIdx = EventOffIdx(1:length(EventOnIdx));
EventOnIdx = sort(EventOnIdx,1);
EventOffIdx = sort(EventOffIdx,1);
touchrange=horzcat(EventOnIdx,EventOffIdx);

%align spikes all around touches (-25ms:50ms after touch)
spikesAligned = zeros(numel(EventOnIdx),wndow);

for i = 1:size(spikesAligned,1)
    spikesAligned(i,:) = spikes(EventOnIdx(i)+range);
end
%% delete below 
% % % % %building output matrix (spikes)
% % % % [preTOnIdx ,~, ~, ~ ,touchdur ,~] = assist_predecisionVar(array);
% % % % prevarAligned=cell(1,length(preTOnIdx));
% % % % preTOffIdx=cell(1,length(preTOnIdx));
% % % % for f=1:length(preTOnIdx)
% % % %     if ~isempty(preTOnIdx{f})
% % % %     preTOffIdx{f}=preTOnIdx{f}+touchdur{f}(1,:);%bulid touch offIdx to find max Dkappa during touch
% % % %     spikewin=repmat(preTOnIdx{f}',1,length(range))+repmat(range,length(preTOnIdx{f}),1); %all time pts to find spks
% % % %     for d = 1:size(spikewin,1) %used for loop to keep structure of array
% % % %     prevarAligned{f}(d,:)=array.R_ntk(:,spikewin(d,:),f);
% % % %     end 
% % % %     else
% % % %         preTOffIdx{f}=0;
% % % %     end
% % % % end

   
%%
%Design matrix for ALL touches
vartouch = zeros(numel(EventOnIdx),6);%theta 1, amp 2, setpoint 3, phase 4, max curvature 5, vel 6
EventOnIdx = EventOnIdx + SpikeShiftValue;
EventOnIdx = EventOnIdx(~(EventOnIdx<1));

EventOffIdx = EventOffIdx + SpikeShiftValue;
EventOffIdx = EventOffIdx(~(EventOffIdx<1));

for i = 1:length(EventOnIdx)
    vartouch(i,1)=array.S_ctk(1,EventOnIdx(i)); %theta at touch
    vartouch(i,3)=array.S_ctk(3,EventOnIdx(i)); %amp at at touch
    vartouch(i,4)=array.S_ctk(4,EventOnIdx(i)); %setpoint at touch
    vartouch(i,5)=array.S_ctk(5,EventOnIdx(i)); %phase at touch
        kwin=array.S_ctk(6,EventOnIdx(i):EventOffIdx(i)); %get values in touch window
        [~ ,maxidx] = max(abs(kwin)); %find idx of max kappa within each touch window, neg or pos
    vartouch(i,6)=kwin(maxidx); %use idx to pull max kappa
    vartouch(i,2)=mean(array.S_ctk(2,EventOnIdx(i)-5:EventOnIdx(i)-1)); %finds mean of velocity (-4:-1ms) before touch
end


% % % % %building design matrix(features)for PRELICK(excluding any before answer period) touches 
% % % % vardesign=cell(1,length(preTOnIdx));
% % % % vars=[1 3 4 5];
% % % % for k=1:length(preTOnIdx)
% % % %     for g = 1:length(vars)
% % % %     vardesign{k}(:,vars(g))=array.S_ctk(vars(g),preTOnIdx{k},k); %just find val of theta, amp,setpoint, and phase at touch
% % % %     end
% % % %     for f=1:length(preTOnIdx{k}) %for each individual touch during that trial
% % % %         kappawin=preTOnIdx{k}(f):preTOffIdx{k}(f); %window for max kappa extraction (touchOn:touchOff)
% % % %         velwin=preTOnIdx{k}(f)-5:preTOnIdx{k}(f)-1; %window for mean vel pre touch extraction (touchON-5:touchOn-1)
% % % %         vardesign{k}(f,6)=max(abs(array.S_ctk(6,kappawin,k)));
% % % %         vardesign{k}(f,2)=nanmean(array.S_ctk(2,velwin,k));
% % % %     end
% % % % end

%mash variables and spikes into a single matrix
varSpikes=horzcat(vartouch,spikesAligned);
% prevarSpikes=cellfun(@(x,y) cat(2,x,y), vardesign,prevarAligned,'uniformoutput',0); %structure that still maintains trial, where each cell = 1 trial, could use in future for go/nogo/hit/miss/etc... analysi
% prevarSpikes=prevarSpikes(~cellfun('isempty',prevarSpikes)); %remove empty cells  
% prevarSpikes=cat(1,prevarSpikes{:});

% % post=ismember(varSpikes,prevarSpikes,'rows');%elim rows in ALL that are same as Pre to find Post
% % postvarSpikes=varSpikes(~post,:);


