% trialContactBrowser is a tool to determine and examine whisking and contacts
%
% trialContactBrowser(array) will construct an first pass estimate of
% contacts using default parameters.
%
% trialContactBrowser(array, contacts) will load the browser with the
% contact info specified in the contacts structure, but default detection
% parameters.
%
% trialContactBrowser(array, contacts, params) will load the browser with
% the contact and parameter info specified in your saved structures. If you
% have built a contacts array from the trial array already, this is how you
% want to call the program.
%
% Version 1.0 SAH 140514

function trialContactBrowserAutoSave(array, contacts, params, varargin)
autoSaveDir = 'Z:\Users\Phil\Data\Characterization\autoSAVEcontacts\';

if nargin <4
    if nargin==1
        disp('Contacts data missing, building and assigning to workspace as "contacts"')
        [contacts, params]=autoContactAnalyzerSi(array);
        contactsname = 'contacts';
        %        assignin('base','contacts',contacts);
    end
    
    if nargin<=2
        
        
        % Populate parameters with defaults
        params.sweepNum = find(array.whiskerTrialInds,1);
        params.displayType = 'all';
        params.displayTypeMinor = 'none';
        params.arbTimes = [];
        params.trialList = '';
        params.trialRange =  [array.trialNums(1) array.trialNums(end)];
        params.colors = prism(length(array.cellNum));
        params.trialcolors = {'g','r','k','b'};
        params.summarize = 'off';
        params.touchThresh = [.1 .1 .1 .1]; %Touch threshold for go (protraction, retraction), no-go (protraction,retraction). Check with Parameter Estimation cell
        params.goProThresh = 0; % Mean curvature above this value indicates probable go protraction, below it, a go retraction trial.
        params.nogoProThresh = 0; % Mean curvature above this value indicates probable nogo protraction, below it, a nogo retraction trial.
        params.poleOffset = .50; % Time where pole becomes accessible
        params.poleEndOffset = .195; % Time between start of pole exit and inaccessiblity
        params.tid=0; % Trajectory id
        params.framesUsed=1:length(array.trials{find(array.whiskerTrialInds,1)}.whiskerTrial.time{1});
        params.curveMultiplier=1.5;
        params.noiseMultiplier=1.5;
        params.baselineCurve = [0 .02]; % To subtract from the baseline curve for contact detection
        params.videoDirectory = {};
        
        %             'maxBins', 51, 'spikeRateWindow', .05, 'spikeSynapticOffset',0,...
        %             'colors',prism(length(array.cellNum)), 'trialcolors', {{'g','r','k','b'}}, 'summarize', 'off');
        %
        
        % Get mean answer time
        tmp=[];
        for i=1:array.length
            if isempty(array.trials{i}.answerLickTime)==0
                tmp(i)=array.trials{i}.answerLickTime;
            else
                tmp(i)=NaN;
            end
        end
        
        params.meanAnswerTime=nanmean(tmp);
        params.cellNum   = array.cellNum;
        params.trialNums = array.trialNums;
        params.arrayname = inputname(1);
        
        % Define the type of spike data present
        if sum(ismember(fieldnames(array.trials{params.sweepNum}),'shanksTrial'))
            params.spikeDataType = 'silicon';
            params.shankNum  = array.shankNum;
        elseif sum(ismember(fieldnames(array.trials{params.sweepNum}),'spikesTrial'))
            params.spikeDataType = 'singleUnit';
        else
            params.spikeDataType = 'none';
        end
        
    end
    
    if  nargin == 1
        params.contactsname = 'contacts';
    else
        params.contactsname = inputname(2);
        params.arrayname = inputname(1); % Command-line name of this instance of a TrialArray.
        
    end
    
    
    % Setup Figure and handles
    hParamBrowserGui = figure('Color','white'); ht = uitoolbar(hParamBrowserGui);
    setappdata(0,'hParamBrowserGui',gcf);
    hParamBrowserGui = getappdata(0,'hParamBrowserGui');
    h_b=brush(hParamBrowserGui);
    set(h_b,'Color',[1 0 1]);
    
    % Setup pushbuttons
    icon_del    = imread('delete.tif');
    icon_add    = imread('add.png');
    icon_right  = imread('arrow-right.png');
    icon_left   = imread('arrow-left.png');
    icon_recalc = imread('refresh.png');
    icon_save   = imread('save.png');
    icon_float  = imread('floatingBaseline.tif');
    icon_floatOff = imread('floatingBaselineOff.tif');
    icon_zoomIn = imread('arrow-down.png');
    icon_zoomOut= imread('arrow-up.png');
    icon_exclude = imread('red_flag_16.png');
    icon_video  = imread('video_camera.png');
    
    bbutton = uipushtool(ht,'CData',icon_left,'TooltipString','Back');
    fbutton = uipushtool(ht,'CData',icon_right,'TooltipString','Forward');
    abutton = uipushtool(ht,'CData',icon_add,'TooltipString','Add Contact','Separator','on');
    dbutton = uipushtool(ht,'CData',icon_del,'TooltipString','Delete Contact');
    rbutton = uipushtool(ht,'CData',icon_recalc,'TooltipString','Recalculate Contact Dependents');
    flagToggle = uitoggletool(ht,'CData',icon_exclude,'TooltipString','Flag trial for exclusion');
    
    sbutton = uipushtool(ht,'CData',icon_save,'TooltipString','Save Contacts and Parameters','Separator','on');
    
    floatToggle = uitoggletool(ht,'CData',icon_floatOff, 'TooltipString', 'Toggle PreContact Baseline Correction');
    zoomToggle  = uitoggletool(ht, 'CData',icon_zoomOut,   'TooltipString', 'Toggle Zoom Level');
    vbutton = uipushtool(ht, 'CData',icon_video,   'TooltipString', 'Toggle Zoom Level');
    
    
    
    % Setup pushbutton callbacks
    set(fbutton,'ClickedCallback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''next'')'])
    set(bbutton,'ClickedCallback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''last'')'])
    set(abutton,'ClickedCallback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''add'')'])
    set(dbutton,'ClickedCallback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''del'')'])
    set(rbutton,'ClickedCallback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''recalc'')'])
    set(sbutton,'ClickedCallback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''save'')'])
    set(vbutton,'ClickedCallback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''videoOn'')'])
    
    set(flagToggle,'OnCallback',   ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''flagOn'')'])
    set(flagToggle,'OffCallback',  ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''flagOff'')'])
    set(floatToggle,'OnCallback',  ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''floatOn'')'])
    set(floatToggle,'OffCallback', ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''floatOff'')'])
    set(zoomToggle,'OnCallback',   ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''zoomOut'')'])
    set(zoomToggle,'OffCallback',  ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''zoomIn'')'])
    
    % Setup menus
    m1=uimenu(hParamBrowserGui,'Label','Time Period','Separator','on');
    uimenu(m1,'Label','All'                          ,'Callback', ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''all'')']);
    uimenu(m1,'Label','Contacts Only'                ,'Callback', ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''contactsOnly'')']);
    uimenu(m1,'Label','Exclude Contacts'             ,'Callback', ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''excludeContacts'')']);
    uimenu(m1,'Label','Pole Presentation to Decision','Callback', ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''poleToDecision'')']);
    uimenu(m1,'Label','First Contact to Decision'    ,'Callback', ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''contactToDecision'')']);
    uimenu(m1,'Label','Post Decision'                ,'Callback', ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''postDecision'')']);
    uimenu(m1,'Label','Post Pole'                    ,'Callback', ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''postPole'')']);
    uimenu(m1,'Label','Abritrary Range'              ,'Callback', ['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''arbitrary'')']);
    
    m2=uimenu(hParamBrowserGui,'Label','Adjust parameters','Separator','on');
    uimenu(m2,'Label','Plots'   ,'Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''adjPlots'')']);
    uimenu(m2,'Label','Spikes'  ,'Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''adjSpikes'')']);
    uimenu(m2,'Label','Contacts','Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''adjContacts'')']);
    uimenu(m2,'Label','Trial Range','Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''adjTrials'')']);
    
    uimenu(hParamBrowserGui,'Label','Jump to sweep','Separator','on','Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''jumpToSweep'')']);
    
    % Old code to call external contact summary routines, may reimplement in
    % future versions -SAH
    %
    %     m3=uimenu(hParamBrowserGui,'Label','Summarize','Separator','on');
    %     uimenu(m3,'Label','STA'     ,'Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''STA'')']);
    %     uimenu(m3,'Label','Clusts'  ,'Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''clusts'')']);
    %     uimenu(m3,'Label','Tuning'  ,'Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''tuning'')']);
    %     uimenu(m3,'Label','Contacts','Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''contacts'')']);
    %     uimenu(m3,'Label','Fit'     ,'Callback',['trialContactBrowser(' params.arrayname ',' params.contactsname ', params,''fit'')']);
    %
    %
    setappdata(hParamBrowserGui, 'params',params);
    setappdata(hParamBrowserGui, 'contacts', contacts);
    setappdata(hParamBrowserGui, 'array', array);
else
    hParamBrowserGui = getappdata(0,'hParamBrowserGui');
    params = getappdata(hParamBrowserGui,'params');
    
    if isempty(params) % Initial call to this method has argument
        params = struct('sweepNum',find(cellfun(@(x) ~isempty(x.whiskerTrial),array.trials),1),'trialList',params.trialNums(cellfun(@(x) ~isempty(x.whiskerTrial),T.trials)),'displayType','all');
    end
    
    hs_1 = subplot(4,3,[1 2  4 5]);
    
    
    for j = 1:length(varargin);
        argString = varargin{j};
        switch argString
            
            case 'next'
                if params.sweepNum < length(array.trials)
                    params.sweepNum = params.sweepNum + 1;
                end
                reset_axes(params);
                
            case 'last'
                if params.sweepNum > 1
                    params.sweepNum = params.sweepNum - 1;
                end
                reset_axes(params);
                
            case 'add'
                
                toAdd = [];
                try
                    toAdd = find(get(findobj('Tag','t_d'),'BrushData'));
                    display ('Distance Brushing')
                    
                end
                try
                    toAdd = params.cropind(logical(get(findobj('Tag','t_cvd'),'BrushData')));
                    display ('CurveVsDistance Brushing')
                    
                end
                
                if ~isempty(toAdd);
                    
                    addContact(toAdd);
                end
                contacts = getappdata(getappdata(0,'hParamBrowserGui'),'contacts');
                params.xlim =  get(subplot(4,3,[1 2  4 5]),'xlim');
                params.ylim =  get(subplot(4,3,[1 2  4 5]),'ylim');
                
                
            case 'del'
                
                toDel = [];
                try
                    toDel = find(get(findobj('Tag','t_d'),'BrushData'));
                    display ('Distance Brushing')
                    
                end
                try
                    toDel = params.cropind(logical(get(findobj('Tag','t_cvd'),'BrushData')));
                    display ('CurveVsDistance Brushing')
                    
                end
                
                if ~isempty(toDel);
                    delContact(toDel);
                end
                
                contacts = getappdata(getappdata(0,'hParamBrowserGui'),'contacts');
                params.xlim =  get(subplot(4,3,[1 2  4 5]),'xlim');
                params.ylim =  get(subplot(4,3,[1 2  4 5]),'ylim');
                
            case 'recalc'
                [contacts params] = autoContactAnalyzerSi(array, params, contacts, 'recalc');
                set(0,'CurrentFigure',hParamBrowserGui);
                
            case 'flagOn'
                contacts{params.sweepNum}.passiveTouch = 1;
                setappdata(hParamBrowserGui,'contacts', contacts);
                
            case 'flagOff'
                contacts{params.sweepNum}.passiveTouch = 0;
                setappdata(hParamBrowserGui,'contacts', contacts);
                
            case 'floatOn'
                
                if ~isfield(params,'floatingBaseline');
                    [contacts params] = autoContactAnalyzerSi(array, params, contacts, 'recalc');
                end
                
                params.floatingBaseline = 1;
                set(0,'CurrentFigure',hParamBrowserGui);
                
            case 'floatOff'
                params.floatingBaseline = 0;
                
            case 'zoomOut'
                
                params.zoomOut = 1;
                set(hs_1,'Xlim',[0 4.5],'YLim',[-.5 8])
                
            case 'zoomIn'
                params.zoomOut = 0;
                set(hs_1,'Xlim',[0 4.5],'YLim',[-.3 .5])
                
            case 'save'
                assignin('base','contacts',contacts);
                assignin('base','params',params);
                uisave( {'contacts', 'params'},['ConTA_' array.mouseName '_' array.sessionName '_' array.cellNum '_' array.cellCode])
                display('Saved Contacts and Parameters')
                
            case 'jumpToSweep'
                if isempty(params.trialList)
                    nsweeps = array.length;
                    params.trialList = cell(1,nsweeps);
                    for k=1:nsweeps
                        params.trialList{k} = [int2str(k) ': trialNum=' int2str(params.trialNums(k))];
                    end
                end
                [selection,ok]=listdlg('PromptString','Select a sweep:','ListString',...
                    params.trialList,'SelectionMode','single');
                if ~isempty(selection) && ok==1
                    params.sweepNum = selection;
                end
                
            case 'adjPlots'
                prompt = {'Maximum bins for plots'};
                dlg_title = 'Plotting Parameters';
                num_lines = 1;
                def = {num2str(params.maxBins)};
                plotParams = inputdlg(prompt,dlg_title,num_lines,def);
                
                params.maxBins=str2num(plotParams{1});
                
            case 'adjSpikes'
                prompt = {'Window size of spike integration (s)', 'Estimated synaptic delay between spikes and whiskers (s)'};
                dlg_title = 'Spike Rate Parameters';
                num_lines = 1;
                def = {num2str(params.spikeRateWindow), num2str(params.spikeSynapticOffset)};
                spikeParams = inputdlg(prompt,dlg_title,num_lines,def);
                params.spikeRateWindow=str2num(spikeParams{1});
                params.spikeSynapticOffset=str2num(spikeParams{2});
                
            case 'adjContacts'
                prompt = {'Trajectory ID :','Pole delay from onset till in range (s)','Pole delay from offset till out of range (s)',...
                    'Contact distance thresholds (go/pro, go/ret, nogo/pro, nogo/ret)', 'Go pro/ret curvature threshold',...
                    'Nogo pro/ret curvature threshold','Curve Multiplier','Noise Multiplier','Baseline Curve go/nogo'};
                dlg_title = 'Contact Parameters';
                num_lines = 1;
                def = {num2str(params.tid), num2str(params.poleOffset), num2str(params.poleEndOffset),...
                    num2str(params.touchThresh), num2str(params.goProThresh),num2str(params.nogoProThresh),...
                    num2str(params.curveMultiplier), num2str(params.noiseMultiplier), num2str(params.baselineCurve)};
                dlgout = inputdlg(prompt,dlg_title,num_lines,def);
                
                if ~isempty(dlgout)
                    params.tid= str2num(dlgout{1});
                    params.poleOffset=str2num(dlgout{2});
                    params.poleEndOffset=str2num(dlgout{3});
                    params.touchThresh = str2num(dlgout{4}); %Touch threshold for go (protraction, retraction), no-go (protraction,retraction). Check with Parameter Estimation cell
                    params.goProThresh = str2num(dlgout{5}); % Mean curvature above this value indicates probable go protraction, below it, a go retraction trial.
                    params.nogoProThresh = str2num(dlgout{6});
                    params.curveMultiplier = str2num(dlgout{7});
                    params.noiseMultiplier = str2num(dlgout{8});
                    params.baselineCurve = str2num(dlgout{9});
                    
                    disp('Recalculating session contact data')
                    [contacts, params]=autoContactAnalyzerSi(array, params, contacts);
                    setappdata(hParamBrowserGui,'contacts',contacts);
                    setappdata(hParamBrowserGui,'params',params);
                    
                    assignin('base','contacts',contacts);
                    figure(hParamBrowserGui);
                else
                    disp('Contact Parameter Adjustment Cancelled')
                end
                
                
            case 'adjTrials'
                prompt = {'Trial Range'};
                dlg_title = 'Trial Range';
                num_lines = 1;
                def = {num2str(params.trialRange)};
                trialParams = inputdlg(prompt,dlg_title,num_lines,def);
                
                params.trialRange=str2num(trialParams{1});
                
            case 'all'
                params.displayType = 'all'
                
            case 'contactsOnly'
                params.displayType = 'contactsOnly'
                disp('Updating Time Period, please wait')
                
            case 'excludeContacts'
                params.displayType = 'excludeContacts'
                disp('Updating Time Period, please wait')
                
            case 'poleToDecision'
                params.displayType = 'poleToDecision'
                disp('Updating Time Period, please wait')
                
            case 'contactToDecision'
                params.displayType = 'contactToDecision'
                disp('Updating Time Period, please wait')
                
            case 'postDecision'
                params.displayType = 'postDecision'
                disp('Updating Time Period, please wait')
                
            case 'postPole'
                params.displayType = 'postPole'
                disp('Updating Time Period, please wait')
                
            case 'arbitrary'
                params.displayType = 'arbitrary'
                prompt = {'Enter starting time (in ms):','Enter ending time (in sec)'};
                dlg_title = 'Select a timeperiod for analysis';
                num_lines = 1;
                def = {'0','4.500'};
                disp('Updating Time Period, please wait')
                params.arbTimes = inputdlg(prompt,dlg_title,num_lines,def);
                
            case 'STA'
                params.summarize = 'STA'
                
            case 'clusts'
                params.summarize = 'clusts'
                
            case 'tuning'
                params.summarize = 'tuning'
                
            case 'contacts'
                params.summarize = 'contacts'
                
            case 'fit'
                params.summarize = 'fit'
                
            case 'videoOn'
                if isempty(getappdata(hParamBrowserGui,'videoDir'))
                    videoDir = uigetdir;
                    setappdata(hParamBrowserGui,'videoDir', videoDir);
                else
                    videoDir = getappdata(hParamBrowserGui,'videoDir');
                    
                end
                if  isfield(get(findobj('Tag','t_d')),'BrushData');
                    brushedData = find(get(findobj('Tag','t_d'),'BrushData'));
                    fr = round(1/array.trials{params.sweepNum}.whiskerTrial.framePeriodInSec);
                    toPlay = round(array.trials{params.sweepNum}.whiskerTrial.time{1}(brushedData)*fr)+1;
                    loadWhiskerVideo(array.trialNums(params.sweepNum), toPlay, videoDir);
                    params = getappdata(hParamBrowserGui,'params');
                    contacts = getappdata(hParamBrowserGui,'contacts');
                else 
                   display('No datapoints found, please brush points before calling video')
                end
                

                
                
                
            otherwise
                error('Invalid string argument.')
        end
    end
end
                hParamBrowserGui = getappdata(0,'hParmBrowserGui');

if isfield(params,'showVideo')
    if params.showVideo == 1
        videoDir = getappdata(hParamBrowserGui,'videoDir');
        loadWhiskerVideo(array.trialNums(params.sweepNum), toPlay, videoDir);
    end
end


if ~isfield(params,'spikeDataType')
    
    if sum(ismember(fieldnames(array.trials{params.sweepNum}),'shanksTrial'))
        params.spikeDataType = 'silicon';
        params.shankNum  = array.shankNum;
    elseif sum(ismember(fieldnames(array.trials{params.sweepNum}),'spikesTrial'))
        params.spikeDataType = 'singleUnit';
    else
        params.spikeDataType = 'none';
    end
end

% properly populate flag exclusion toggle state from contacts
% h_flag = findobj(1,'TooltipString','Flag trial for exclusion'); % Get handle for the exclusion flag toggle
% 
% if isfield(contacts{params.sweepNum},'passiveTouch')
%     if contacts{params.sweepNum}.passiveTouch == 0
%         set(h_flag,'State','off');
%     else
%         set(h_flag,'State','on');
%     end
% else
%     contacts{params.sweepNum}.passiveTouch = 0;
%     set(h_flag,'State','off');
% end
% setappdata(hParamBrowserGui,'contacts', contacts);
% setappdata(hParamBrowserGui,'params', params);


% Shorthand notation

time=array.trials{params.sweepNum}.whiskerTrial.time{1}; % All times in current trial
cT=array.trials{params.sweepNum};
cW=array.trials{params.sweepNum}.whiskerTrial;
cB=array.trials{params.sweepNum}.behavTrial;

if strcmp(params.spikeDataType,'silicon')
    
    cS=array.trials{params.sweepNum}.shanksTrial;
    % Calculate the spike rate across trials
    sampleRate=cS.sampleRate;
    
end

if strcmp(params.spikeDataType,'singleUnit')
    
    cS=array.trials{params.sweepNum}.spikesTrial;
    % Calculate the spike rate across trials
    sampleRate=cS.sampleRate;
    
end

if strcmp(params.spikeDataType,'Vm')
    
    cS=array.trials{params.sweepNum}.spikesTrial;
    % Calculate the spike rate across trials
    sampleRate=cS.sampleRate;
    
end
% Select relevant frame periods

switch params.displayType
    
    case 'all'
        params.framesUsed = 1:length(time);
        
    case 'contactsOnly'
        params.framesUsed = contacts{params.sweepNum}.contactInds{1};
        
    case 'excludeContacts'
        params.framesUsed = ones(size(time));
        params.framesUsed(contacts{params.sweepNum}.contactInds{1})=0;
        params.framesUsed= find(params.framesUsed);
        
    case 'poleToDecision'
        if isempty(cB.answerLickTime)==0
            params.framesUsed = find(time > cT.pinDescentOnsetTime+params.poleOffset &...
                time < cB.answerLickTime);
        else
            params.framesUsed = find(time > cT.pinDescentOnsetTime+params.poleOffset &...
                time < params.meanAnswerTime);
        end
        
    case 'contactToDecision'
        if isempty(contacts{params.sweepNum}.contactInds{1})==0
            params.framesUsed = find(time > time(contacts{params.sweepNum}.contactInds{1}(1)) &...
                time < params.meanAnswerTime);
        else
            params.framesUsed=[];
        end
        
    case 'postDecision'
        
        if isempty(cB.answerLickTime)==0;
            params.framesUsed = find(time > cB.answerLickTime);
        else
            params.framesUsed = find(time> params.meanAnswerTime);
        end
        
    case 'postPole'
        params.framesUsed = find(time > cT.pinAscentOnsetTime);
        
    case 'arbitrary'
        params.framesUsed = find(time > str2num(params.arbTimes{1}) & time < str2num(params.arbTimes{2}));
        
    otherwise
        error('Invalid string argument.')
end

% Contact discrimination parameters

% spikeIndex=zeros(100000,1);
if isempty(cW)==1
    subplot(4,3,1)
    text(0,0,'Whisker Data Missing for Trial');
else
    
    
    %     for i=1:length(cS.clustData)
    %     try
    %         spikeIndex{i}(cS.clustData{i}.spikeTimes)=1;
    %     end
    %
    %     spikeRate{i}=smooth(spikeIndex{i},params.spikeRateWindow*sampleRate)*sampleRate;
    %
    %     spikeRateUsed{i}=spikeRate{i}(params.framesUsed*10+round((array.whiskerTrialTimeOffset+params.spikeSynapticOffset)*sampleRate));
    %     end
    
    
    params.cropind=[];   cind=[];   y1=[];   x1=[];    y2=[];   x2=[];
    params.cropind=find(cW.time{1} > params.poleOffset+cB.pinDescentOnsetTime & cW.time{1} < params.poleEndOffset+cB.pinAscentOnsetTime);
    cind=contacts{params.sweepNum}.contactInds{1};
    y1=cW.distanceToPoleCenter{1}(params.cropind);
    x1=cW.kappa{1}(params.cropind);
    y2=cW.distanceToPoleCenter{1}(cind);
    x2=cW.kappa{1}(cind);
    tmax=max(cW.time{1});
    
    % Plot contact detection parameters
    hs_2 = subplot(4,3,[3 6]);hold off;
    plot(x1,y1,'.k','Tag','t_cvd'); hold on
    axis([min(x1)-.02 max(x1)+.02 min(y1)-.3 max(y1)+1])
    
    plot(x2,y2,'.r');
    title('Contact Parameters')
    axis tight
    xlabel('Curvature (\kappa)')
    ylabel('Dist to pole (mm)')
    
    % Plot Trial info
    subplot(4,3,12);hold off;
    
    plot([0 1],[0 1],'.');
    set(gca,'Visible','off');
    
    text(.1,1,[int2str(params.sweepNum) '/' int2str(array.length) ...
        ', Trial=' int2str(params.trialNums(params.sweepNum))]);
    
    text(.1,.9, ['\fontsize{10}' array.trials{params.sweepNum}.trialOutcome]);
    text(.1,.5, ['\fontsize{10}' 'Mean Answer Time : ' num2str(params.meanAnswerTime) ' (s)']);
    text(.1,.3, ['\fontsize{10}' 'Mouse : ' array.mouseName]);
    text(.1,.2, ['\fontsize{10}' 'Cell : ' params.cellNum ' ' array.cellCode]) ;
    
    % Distance to pole center
    hs_1 = subplot(4,3,[1 2  4 5]);
    current_x = get(hs_1,'xlim');
    current_y = get(hs_1,'ylim');
    hParamBrowserGui = getappdata(0,'hParamBrowserGui');
    setappdata(hParamBrowserGui,'current_x',current_x)
    setappdata(hParamBrowserGui,'current_y',current_y)
    
    hold off;
    plot(cW.time{1},cW.distanceToPoleCenter{1},'.-k','Tag','t_d')
    hold on
      
    plot(cW.time{1}(cind),cW.distanceToPoleCenter{1}(cind),'.r')
    
    title(strcat('Distance to pole center #',num2str(params.trialNums(params.sweepNum))),'FontSize',10)
    ylabel('Distance (mm)');
    hold on;
    if isfield(params,'zoomOut')
        if params.zoomOut
            set(gca,'Xlim',[0 tmax],'YLim',[-.5 8]);
        else
            set(gca,'Xlim',[0 tmax],'YLim',[-.3 .5]);
            
        end
    else
        set(gca,'Xlim',[0 tmax],'YLim',[-.3 .4]);
        
    end
    % Curvature
    hs_3 = subplot(4,3,[7 8]);
    hold off;
    set(gca,'XLim',[0 tmax]);
    
    plot(cW.time{1},cW.deltaKappa{1},'.-k')
    hold on
    
    plot(cW.time{1}(cind),cW.deltaKappa{1}(cind),'.r')
    title(strcat('Change in curvature #',num2str(params.trialNums(params.sweepNum))))
    ylabel('Curvature (K)');
    hold on;
    
    % Plot M0 with contacts scored
    
    M0combo=cW.M0I{1};
    M0combo(abs(M0combo)>1e-7)=NaN;
    M0combo(cind)=cW.M0{1}(cind);
    
    hs_4 = subplot(4,3,[10 11]);
    cla;hold on
    set(gca,'XLim',[0 tmax],'YLim', [-5 5]*1e-7,'Color','k');
    %     set(gca,'YLim', [-5 5]*1e-7,'Color','k');
    title(strcat('Forces associated with trial #',num2str(params.trialNums(params.sweepNum))))
    
    linkaxes([hs_1 hs_3 hs_4],'x');
    set(hs_1,'XLim',current_x,'YLim',current_y);
    
    if ~isfield(params,'floatingBaseline')
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1},contacts{params.sweepNum}.M0combo{1},'-w.','MarkerSize',6)
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1}(cind),cW.M0{1}(cind),'r.','MarkerSize',8)
        
    elseif ~params.floatingBaseline
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1},contacts{params.sweepNum}.M0combo{1},'-w.','MarkerSize',6)
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1}(cind),cW.M0{1}(cind),'r.','MarkerSize',8)
        
    elseif params.floatingBaseline
        
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1},contacts{params.sweepNum}.M0comboAdj{1},'-w.','MarkerSize',6)
        plot(array.trials{params.sweepNum}.whiskerTrial.time{1}(cind),contacts{params.sweepNum}.M0comboAdj{1}(cind),'r.','MarkerSize',8)
        
        
    else
    end
    
    
    % Plot silicon probe spikes if present
    if strcmp(params.spikeDataType,'silicon')
        
        
        for i = 1:length(cS.clustData)
            if length(array.whiskerTrialTimeOffset)>1;
                try
                    plot(double(cS.clustData{i}.spikeTimes)/cS.sampleRate-array.whiskerTrialTimeOffset(params.sweepNum),.5e-7+5e-8*i,'.','color',params.colors(i,:))
                end
                
            else
                try
                    plot(double(cS.clustData{i}.spikeTimes)/cS.sampleRate-array.whiskerTrialTimeOffset,.5e-7+5e-8*i,'.','color',params.colors(i,:))
                end
                
            end
            text(tmax*.95,.5e-7+5e-8*i,[num2str(params.shankNum(i)) num2str(params.cellNum(i))],...
                'FontSize',6,'color',params.colors(i,:))
            
        end
    end
    
    % Plot cell attached spikes if present
    
    if strcmp(params.spikeDataType,'singleUnit')
        
        try
            plot(double(cS.spikeTimes)/cS.sampleRate-array.whiskerTrialTimeOffset,.5e-7+5e-8,'c.')
            
        end
        
    end
    
    % Plot Vm attached spikes if present
    
    if strcmp(params.spikeDataType,'Vm')
        
        try
            plot(double(cS.spikeTimes)/cS.sampleRate-array.whiskerTrialTimeOffset,.5e-7+5e-8,'c.')
            
        end
        
    end
    try
        plot(array.trials{params.sweepNum}.behavTrial.beamBreakTimes,.5e-7,'m*')
    end
    text(tmax*.95,.5e-7,'Lick','FontSize',6,'color','m')
    
    ylabel('M0 (N*m) red=contact');
    
end

% Old code to call external contact summary routines, may reimplement in
% future versions -SAH
%
% switch params.summarize
%     case 'STA'
%         params.summarize = 'off'; % switches the summarize flag off
%         summarizeSTA(array,contacts, params);  % calls the STA summary function
%
%     case 'spikes'
%         params.summarize = 'off'; % switches the summarize flag off
%         summarizeClusts(array,contacts, params);  % calls the STA summary function
%
%     case 'tuning'
%         params.summarize = 'off';
%         summarizeTuningSi(array,contacts, params);
%
%     case 'contacts'
%         params.summarize = 'off';
%         summarizeContactsSi(array,contacts, params);
%
%     case 'fit'
%         params.summarize = 'off';
%         summarizeFit;
%
%     otherwise
%
% %        error('Invalid string argument.')
%
% end

assignin('base','params', params);
setappdata(hParamBrowserGui,'params', params);

assignin('base','contacts',contacts);
assignin('base','params',params);
save([autoSaveDir, 'ConTA_',  num2str(array.projectDetails.cellNumberForProject)], 'contacts', 'params')
display('Saved Contacts and Parameters')
end


function  r = loadWhiskerVideo(videoNum,toPlay,videoDir)
% Display rasters of video frames from brushed data

hParamBrowserGui = getappdata(0,'hParamBrowserGui');

obj = getappdata(hParamBrowserGui);
contactTimes = obj.array.trials{obj.params.sweepNum}.whiskerTrial.time{1}(obj.contacts{obj.params.sweepNum}.contactInds{1});
fr = round(1/obj.array.trials{obj.params.sweepNum}.whiskerTrial.framePeriodInSec);


% d = dir([videoDir filesep '*.mp4']);
% find_video = strfind([d(:).name], ['_' sprintf('%04d',videoNum) '_']);
% video_idx = ceil(find_video/length(d(1).name));
% bar = load([videoDir filesep d(video_idx).name(1:end-4) '.bar']);
 bar = load([videoDir filesep  obj.array.trials{obj.params.sweepNum}.whiskerTrial.trackerFileName '.bar']);
if isempty(toPlay)
%     video = mmread([videoDir filesep d(video_idx).name]);
     video = mmread([videoDir filesepobj.array.trials{obj.params.sweepNum}.whiskerTrial.trackerFileName '.mp4']);

    barSelected = bar(:,2:3,:)
    
else
    
    video = mmread([videoDir filesep obj.array.trials{obj.params.sweepNum}.whiskerTrial.trackerFileName '.mp4'],toPlay);
    barSelected = bar(toPlay,2:3,:);
    
end

poleWindow = [-50:50];
video.isContact = zeros(length(toPlay),1)
[~,brushedContactIdx,~] = intersect(toPlay, round(contactTimes*fr)+1);
video.isContact(brushedContactIdx) = 1;


[poleCropVideoCat poleCropVideoSub] = buildPoleCropVideos(video,barSelected,poleWindow);

h_videofig = figure(5);
clf

subplot(2,1,1)
colormap(gray(256));
h_cropimg = image(poleCropVideoCat);
axis off
for i = 1:length(toPlay)
    text(length(poleWindow)*(i-1),5,num2str((toPlay(i)-1)/fr),'color','y','fontsize',8)
end
text(0,-2,'Left click to add contact, Right click delete, Enter to save','color','y')

subplot(2,1,2)
h_diffimg = imagesc(poleCropVideoSub);
axis off
for i = 1:length(toPlay)
    text(length(poleWindow)*(i-1),5,num2str((toPlay(i)-1)/fr),'color','y','fontsize',8)
end
text(0,-10,'Contact','color','k')
text(0,-5,'No Contact','color','w')

% figure(hParamBrowserGui);
%video = mmread(sweepNum,videoDir)
[x,y,button] = ginput

toAddSubIdx = unique(ceil(x(button == 1)/length(poleWindow)));
toDelSubIdx = setdiff(unique(ceil(x(button == 3)/length(poleWindow))),toAddSubIdx);

toAddSubIdx = toAddSubIdx(toAddSubIdx > 0 & toAddSubIdx <= length(toPlay));
toDelSubIdx = toDelSubIdx(toDelSubIdx > 0 & toDelSubIdx <= length(toPlay));

toAddTimes = toPlay(toAddSubIdx);
toDelTimes = toPlay(toDelSubIdx);

[~, toAddIdx,~] = intersect(round(obj.array.trials{obj.params.sweepNum}.whiskerTrial.time{1}*fr)+1,toAddTimes);
[~, toDelIdx,~] = intersect(round(obj.array.trials{obj.params.sweepNum}.whiskerTrial.time{1}*fr)+1,toDelTimes);

toAddIdx = toAddIdx';
toDelIdx = toDelIdx';


if ~isempty(toAddIdx);
    addContact(toAddIdx);
    for i = toAddSubIdx
        video.isContact(i) = 1;
    end
 
end

if ~isempty(toDelIdx);
 
    delContact(toDelIdx);
    for i = toDelSubIdx
        video.isContact(i)= 0;
    end

end

[poleCropVideoCat poleCropVideoSub] = buildPoleCropVideos(video,barSelected,poleWindow);

figure(h_videofig);
subplot(2,1,1)
h_cropimg = image(poleCropVideoCat);
axis off
for i = 1:length(toPlay)
    text(length(poleWindow)*(i-1),5,num2str((toPlay(i)-1)/fr),'color','y','fontsize',8)
end


setappdata(h_videofig,'h_cropimg',h_cropimg)
setappdata(h_videofig,'h_diffimg',h_diffimg)

ap5 = getappdata(h_videofig)

figure(hParamBrowserGui);
end

function [poleCropVideoCat poleCropVideoSub] = buildPoleCropVideos(video,barSelected, poleWindow)

poleCropVideo = zeros(length(poleWindow),length(poleWindow),length(barSelected));
poleCropVideoCat = [];
poleCropVideoSub = [];

if size(video.frames(1).cdata,2) <  max(barSelected(1,1)+poleWindow) || size(video.frames(1).cdata,1) < max(barSelected(1,2)+poleWindow);
   poleWindow = poleWindow - max([max(barSelected(1,1)+poleWindow)-size(video.frames(1).cdata,2)  max(barSelected(1,2)+poleWindow)-size(video.frames(1).cdata,1)]);
end

for i = 1:length(barSelected)
        
    poleCropVideo(:,:,i) = video.frames(i).cdata(barSelected(i,2)+poleWindow,barSelected(i,1)+poleWindow,1);
 

end
for i = 1:length(barSelected)
        if video.isContact(i) == 0;

    poleCropVideoCat = cat(2,poleCropVideoCat,cat(1,video.frames(i).cdata(barSelected(i,2)+poleWindow,barSelected(i,1)+poleWindow,1),repmat(255,10,length(poleWindow))));
       else
    poleCropVideoCat = cat(2,poleCropVideoCat,cat(1,video.frames(i).cdata(barSelected(i,2)+poleWindow,barSelected(i,1)+poleWindow,1),repmat(0,10,length(poleWindow))));
        end
    poleCropVideoSub = cat(2,poleCropVideoSub, mean(poleCropVideo,3)-poleCropVideo(:,:,i));
end
end


function params = reset_axes(params)

hParamBrowserGui = getappdata(0,'hParamBrowserGui');
params = getappdata(hParamBrowserGui,'params');
figure(hParamBrowserGui)
hs_1 = subplot(4,3,[1 2  4 5]);

params.xlim =  get(subplot(4,3,[1 2  4 5]),'xlim');
params.ylim =  get(subplot(4,3,[1 2  4 5]),'ylim');

if isfield(params,'zoomOut')
    if params.zoomOut
        set(hs_1,'YLim',[-.5 8]);
    else
        set(gca,'YLim',[-.3 .5]);
    end
else
    set(gca,'YLim',[-.3 .5]);
    
end
end

%% Optional Extra Plotting section

% figure
%     % Plot M0 with contacts scored
%     M0combo=cW.M0I{1};
%     M0combo(abs(M0combo)>1e-7)=NaN;
%     M0combo(cind)=cW.M0{1}(cind);
%     set(gca,'XLim',[0 tmax]);
%
%     cla;
%     plot(array.trials{params.sweepNum}.whiskerTrial.time{1},M0combo,'-k.')
%     title(strcat('Forces associated with trial #',num2str(params.trialNums(params.sweepNum))))
%     hold on;
%     plot(array.trials{params.sweepNum}.whiskerTrial.time{1}(cind),cW.M0{1}(cind),'.r')
%     %plot(cS.spikeTimes/cS.sampleRate+array.whiskerTrialTimeOffset,5e-8,'.')
%     ylabel('M0 (N*m) red=contact');
%     set(gca,'XLim',[0 tmax]);
%     set(gcf,'PaperOrientation','landscape','PaperPosition',[.25 .25 10.75 3])
%
%

