%%%Set directory to a folder with subfolders named after your mouse (mice)
%%%names "AH0000" for example and all the behavioral data for that mice in
%%%those folders then hit run.
%%%then once it is finished, run plotBhaviorPerformance.m file to plot yo
%%%plots. NOTE: this program calls processBehavior.m and relies on it to
%%%function. -psm


clear all


S.baseFolder = 'Z:\Users\Phil\Data\Behavior\LESION_EXPERIMENTS\';
cd(S.baseFolder)
dirinfo = dir(S.baseFolder);
for k = 1:length(dirinfo(:,1))
indexDir(k) = dirinfo(k).isdir;
end
dirinfo = dirinfo(indexDir, :)

TotSessions = 0; %set Automatically later

numberOfMice= length(dirinfo)-2; %based on folder names.in S.baseFolder
%subtract 2 due to the '.' and '..' when using dir.
fName = {};
m = struct;
for kk = 3 : length(dirinfo)
    k = kk-2;
    uniqueMouseNames{k} = dirinfo(kk).name;
    fName{k} = strcat('mouse', num2str(k));
    
    mTMP= dir([S.baseFolder filesep uniqueMouseNames{k}]);
    
    m3 = arrayfun(@(x) x.name, mTMP, 'UniformOutput', false);
    m4 = strfind(m3, 'data_@pole_contdiscrim');
    m5 = find(~cellfun(@isempty, m4));
    
    
    m.(fName{k}) = mTMP(m5);
    TotSessions(k) = length(m.(fName{k}));
    
    
    %Let's allocate some shit.
    
    % TotSessions=2; %Need to know the total number of sessions. One day...
    mouseName=cell(1,TotSessions(k));
    behavFile=cell(1,TotSessions(k));
    
    % % % for i = 1:numberOfMice
    
    % % % m1 = m.(fName{i});
    % % % % m3 = arrayfun(@(x) x.name, m1, 'UniformOutput', false);
    % % % % m4 = strfind(m3, 'data_@pole_contdiscrim');
    % % % % m5 = find(~cellfun(@isempty, m4));
    % % %
    % % %
    % % %
    % % % % m1 = m1(arrayfun(@(x) x.name(1), m1) ~= '.');
    m1=struct2cell(m.(fName{k}));
    m1d=m1(1,:);%first row all names of behavior files
    m1d=regexprep(m1d,'.mat',''); %remove the . mat
    
    sessionLength = length(m1d);
    startInd = sum(sessionLength)-sessionLength(end)+1;
    endInd   = sessionLength(end)+startInd-1;
    behavFile(1,startInd:endInd) = m1d;
    mouseName(1,startInd:endInd) = uniqueMouseNames(k);
    % % % % end
    
    
    %
    %
    
    
    %mouseName = unique(allMouseNames);
    % Add appropriate mice in the order that they'll correspond to the behavior
    % files that you're going to add below.
    %mouseName(1,1:length(m1d))= mouse;
    
    
    % You need to change this section based upon the number of mice you have.
    % Should be pretty intuitive.
    
    
    
    
    
    
    % Next, we're going to actually add the trials we intend to use. In
    % general, what's listed here is from the second trial onward (excepting
    % the first days, since the beginning of those is generally utter garbage).
    % You might even want to further subdivide the early versus middle versus
    % late training periods for more informative progress graphs...
    
    %{Mouse1...
    %Mouse2...
    %Mouse3}
    
    % goodTrials = {[2:100],[2:100]};
    
    %^As a note for the above section, I'm probably going to set it up so that
    %this is pulled from an excel file to a table, thus eliminating the need to
    %alter this in any significant way. Ideally, I'll add some sort of
    %conditional to allow automating sectioning depending on how many mice are
    %being analyzed.
    clear o 
    for i = 1:TotSessions(k)
        AHloc = strfind(m1d{i},'AH');
        if isempty(AHloc)
            AHloc = strfind(m1d{i},'PM');
        end
        underscoreLoc = strfind(m1d{i}, '_');
        dateLocation = find(underscoreLoc > AHloc); %not yet date loc
        dateLocation(end +1) = dateLocation; %so lat if only one number will work as an array not double
        dateLocation = (underscoreLoc(dateLocation(1))+1):(underscoreLoc(dateLocation(1))+7);
        dateOfSes = m1d{i}(dateLocation(1):end);
        protocalName =  m1d{i}(7:AHloc-1);
        
   
        
        
        
        
        S.behavFile{1} = behavFile{i}; % Fill up S
        S.mouseName{1} = mouseName{i};
        output = processBehavior(S, protocalName); % Send it off to fight
        %     performing_cutoff = max([find(output.trialResults(:,2).*output.trialResults(:,7),1,'last'),...
        %     find(output.trialResults(:,3).*output.trialResults(:,7),1,'last')]);
        %     output.trialResults = output.trialResults(1:performing_cutoff,:); % Watch it come back in a body bag
        %     output.trialResults(:,17) = i;
        %     output.S = S;
        %     output.trialResultsNames = {'Trial number', 'R_trials', 'L_trials', 'Abs_trials', 'L_or_R_miss',...
        %     'All_incorrect', 'L_or_R_hit', 'Abs_corrRej', 'R_hits', 'R_incorr',...
        %     'L_hits', 'L_incorr', 'Abs_corrRej', 'Abs_incorr', '......','......', 'session'};
        %         %%%go trial vs no trial (exact opposite)
        %         %%% trials correct vs incorrect (errors) mirror vectors.
        output.trialResults.Session = m1d{i};
        output.trialResults.Date = dateOfSes;
        o{i, 1} = output.trialResults ;
        o{i, 2} = output.trialResults.Session;
        o{i, 3} = output.trialResults.Date;
        i
    end
    [~, indSort] = sort(o(:,3));% sort by the date name
    
    o = o(indSort, :)
    UB{k, 1} = o;
    UB{k, 2} = S.mouseName{1};
    
end

%% save o array
dateTime1= datestr(now,'yymmdd_HHMM');
save(['UB_array_', dateTime1], 'UB')
% %% Build Behavior
% sessionName = 160229;
% fn='data_@pole_contdiscrim_obj_AH0360_160229a.mat';
% b = Solo.BehavTrialArray(fn, sessionName); b.trim = [1 0];  b.performanceRegion = [1 225];
% giveMin=min(b.trialNums)
% giveMax=max(b.trialNums)
% figure; b.plot_scored_trials;
% pc = performance(b);
