%%
% philsClassifier
% cd('C:\Users\maire\Downloads')
%{


startDir = 'C:\testingClass\New folder';
 philsClassifier_TESTING(startDir)

%}
%% jus to save info, should always be the same
function [] = philsClassifier_TESTING()
% for dummy1 = 1
startDir = 'C:\testingClass\';
trackingINfoSaveDir =  'Y:\Whiskernas\Data\Video\PHILLIP\';
dateString1 = datestr(now,'yymmdd_HHMM');
%% get all the files from every dir
% startDir = 'Y:\Whiskernas\Data\Video\PHILLIP\AH0718\';
dirs = regexp(genpath(startDir),['[^;]*'],'match');
% % % dirs = {startDir} %################################################remove
Lthresh = 100; %length threshold. whisker must be larger than this
% threshMISSforceLargest = 1; % automatically classify the largest whiskeras %***********************
% centerOfMassJumpPrevention = 1%***********************
maxCenterOfMassChange = 4;% mean distance of x and y of previous whisker min distance to all points of testing whisker 
% if the value is larger than this then it can not be classified as the correct whisker
wskrNUM = 0; %whisker class label in mease and whisker files
FramesInVid = 4000; % frames in video for me it will always be the same but for lily or jinho they can read video and get actual fram numbers and set this iteratively
forceReClass = 1; %classify everything using this method
Fnums = (0:FramesInVid-1)';% frmae numbers for the given total framses set above
allLessThan4000 = [];
allClassifierInfo = {};
for Ds = 1:length(dirs)
    curDur = dirs{Ds};
    measF = dir([curDur filesep '*.measurements']);
    wskF = dir([curDur filesep '*.whiskers']);
    barF = dir([curDur filesep '*.bar']);
    test1 =  [length(measF) length(wskF) length(barF)];
    didRun = 0;
    for k =  1:length(measF)
        if all(test1) && length(measF)>0
            didRun = 1;
            
            while 1
                nameF = measF(k).name;
                [measurmentMat, fieldNamesM, measurmentstruct] = loadMeasurementsMat([curDur filesep nameF]);
                IDandTIME_M = measurmentMat(:,[2, 1]);% for aligning later
                [~, baseName, ~] = fileparts([curDur filesep nameF]);
                dashLoc = find(baseName =='-', 1);
                numLoc = baseName(dashLoc+1:end);
                baseName = baseName(1:dashLoc);
                allDataDir = struct2cell(dir([curDur filesep baseName, '*']));
                
                listAll =  allDataDir(1,:);
                findStrings = {...
                    [baseName numLoc '.measurements']...
                    [baseName numLoc '.whiskers']...
                    [baseName numLoc '.bar']...
                    };
                M_W_Bdirs = {};
                fprintf('%s%d%s%d%s%s%s%d%s%d%s%s\n', 'Directory ', Ds, ' of ',length(dirs), ' ', baseName,'num ', k, ' of ', length(measF), ' trial/file number ', numLoc);
                for eachFile = 1:length(findStrings) % I now realize this is not needed I can just use the file name
                    tmp = findStrings{eachFile};
                    ind1 = find((strncmp(listAll,tmp , length(tmp))));
                    M_W_Bdirs{eachFile, 1} = [allDataDir{2, ind1}, filesep, allDataDir{1, ind1}];
                end
                [whiskerstruct, whiskerMat,IDandTIME_W, fieldNames] = loadWhiskersMat(M_W_Bdirs{2});% now we need the whisker mat to look at the whiskers
                barPosXY = load(M_W_Bdirs{3});
                barPosXY = barPosXY(1,2:3);
                %%
                fid = measurmentMat(:,1);
                L = measurmentMat(:,6);
                Lind = find(L>=Lthresh);
                eachFrame = length(unique(fid(Lind)))-FramesInVid; %if negative then frames missing with large enough whiske if possitive you have multiple large enough whiskers per frame.
                if all(measurmentMat(Lind, 3)==wskrNUM) && length(Lind) == FramesInVid && eachFrame==0 && forceReClass == 0
                    % they match the whisker number
                    %the length is the same as the video number
                    % eachFrame is testing if each one of the 4000 frames are unique (as opposed to 2
                    % whiskers being classified in the same frame and nome in the next (this will catch
                    % that)
                    break
                end
                
                for AllNeg1 = 1:size(measurmentstruct, 1)
                    measurmentstruct(AllNeg1).label = int32(-1);
                end
                
                % measurmentstruct.label = -ones(size(measurmentstruct, 1), 1);
                %trigger redo calssification
                %             classPart1()
                %              eachFrame = length(unique(fid(Lind))) == length(fid(Lind));
                
                if length(Lind) == 4000  && ~all(measurmentMat(Lind, 3)) && eachFrame==0% just use the largest whiskers
                    % ######### use the largest whisker
                    % jsut let it run through no need for this catch
                    %                     keyboard
                end
                
                %
                %                 if eachFrame < 0 %trigger not enought frames with a whisker that long, need to use alternitive method for classifying
                %                     % too few frames
                %                     disp('short')
                %                     break
                %
                %                     keyboard
                %
                %                 else % there are to whiskers greater than that length figure out which ones
                %                     use closest to pole metric in case of double whisker
                %                     % too many frames
                measurmentMat2 = measurmentMat;
                
                tmpU = unique(measurmentMat2(:,1));%tqak unique time points (whiskers that are too short are naned) 
                tmpU = tmpU(~isnan(tmpU));
                indBack = L>=Lthresh;
                measurmentMat2(~indBack, :) = nan; %(whiskers that are too short are naned) 
                tmpU2 = unique(measurmentMat2(:,1));
                tmpU2 = tmpU2(~isnan(tmpU2));
                
                %                       measurmentMat2 = measurmentMat2(find(~isnan(measurmentMat2)), :);
                %                 [segmentsTMP] = findInRow(idx2(:));
                %                 testSets = [segmentsTMP(:,1)-1, segmentsTMP(:,2)];% the first ind is why I put a -1 in there
                for kk = 1:length(tmpU2)
                    %                     if tmpU(kk) == 951
                    %                         keyboard
                    %                     end
                    theseOnes = find(measurmentMat2(:,1) == tmpU2(kk));
                    if length(theseOnes)>1
                        
                        
                        %                     theseOnes =testSets(kk,1):testSets(kk,2);% from the meas mat different than the whisk locaitons
                        distMinLastW = [];distMinBar = [];IDnumsW = [];
%                         whiskCell = struct2cell(whiskerstruct);
                        
%                valuetofind = 0 ;
% 
%                         find(arrayfun(@(s) ismember(valuetofind, whiskerstruct.id), id))
%                         
                        
              
                        
                         correctLabel = ([whiskerstruct.id] == wskrNUM);
                        timeBefore = ([whiskerstruct.time] <= tmpU2(kk));
                        
%                         timeBefore = cell2mat(whiskCell(2,:)) < tmpU2(kk);
%                         correctLabel = cell2mat(whiskCell(1,:)) == wskrNUM;
                        tmpwWbefore = [];
                        
                        lastWhiskerInd = find(correctLabel.*timeBefore);
                        if isempty(lastWhiskerInd)
                            lastWhiskerInd = flip(find(correctLabel));
                        end
                        counterWB = 0 ;
                        while isempty(tmpwWbefore)
                        tmpwWbefore = whiskerstruct(lastWhiskerInd(end-counterWB));
                        counterWB = counterWB + 1;
                        end
                        for kkk = 1:length(theseOnes)
                            IDnumsM = IDandTIME_M(theseOnes(kkk), :);
                            IDnumsW(kkk) = find(all(IDandTIME_W == IDnumsM, 2));
                            tmpW = whiskerstruct(IDnumsW(kkk));
                            
                            
                            
                            try
                                tmpWbeforeCenterOfMass = [nanmean(tmpwWbefore.x), nanmean(tmpwWbefore.y)];
                            catch
                                tmpWbeforeCenterOfMass = [inf, inf];
                            end
                            
                            
                            distMinBar(kkk) = min(sqrt((tmpW.x-barPosXY(1)).^2 + (tmpW.y-barPosXY(2)).^2));
                            distMinLastW(kkk) = min(sqrt((tmpW.x-tmpWbeforeCenterOfMass(1)).^2 + (tmpW.y-tmpWbeforeCenterOfMass(2)).^2));
                        end
                        
                        possibleINds = find(distMinLastW<=maxCenterOfMassChange);
                        [~, sortedIndsBar ] = sort( distMinBar);
                        closestW = sortedIndsBar(possibleINds);
                         for kkk = 1:length(theseOnes) %replace the clasification in the struct to save later GOOD JOBO
                            measurmentstruct(theseOnes(kkk)).label = -1; %remove all labels (set to - 1)
                        end
                        if ~isempty(closestW)
                            closestW =  closestW(1);
                              closestW = theseOnes(closestW); % classified whisker ind
                               measurmentstruct(closestW).label = 0; % replace just the one you want with the correct whisker number
                        end
                        
                      
                       
                       
                    else % just set the largest whisker
                        
                        measurmentstruct(theseOnes).label = 0;
                    end
                end
                %                 end
                if eachFrame ==0  % same numb of frames and same matching frames
                    if  all(Fnums(:)== tmpU2(:))
                        break % end the loop at the end
                    else
                        warning('same number of frames but not the same frame numbers, make sure the set frames match the video frames, if you''re a 4000 frame folk then you forgot to run the remove non 4000 fram video program');
                        keyboard
                    end
                elseif eachFrame>0 % this shoiuld not happen ever if it does then figure it out when it comes
                    warning('this shoiuld not happen ever if it does then figure it out when it comes')
                    keyboard
                elseif eachFrame<0
                    disp('this file has some whiskers that dont meet the threshhold and those frames will not have an identified whisker in it')
                    allLessThan4000(end+1, 1) = str2num(numLoc);
                    allLessThan4000(end, 2) = eachFrame;
                    break
                    % DO SHIT TO MAKE THE SHORTER WHISKER WORK
                end
            end
            SaveMeasurements(M_W_Bdirs{1}, measurmentstruct)
            
        elseif isempty(measF)
            allLessThan4000 = nan;
            didRun = 0;
        else
            for blah = 1:30;
                warning('num of bar whisker and measurement files didnt match. SKIPPING') ;
            end
            didRun = 0;
            nameF = measF(k).name;
            [measurmentMat, fieldNamesM, measurmentstruct] = loadMeasurementsMat([curDur filesep nameF]);
            IDandTIME_M = measurmentMat(:,[2, 1]);% for aligning later
            [~, baseName, ~] = fileparts([curDur filesep nameF]);
            baseName = baseName(1:dashLoc)
            
            pause(2)
        end
    end
    if didRun ==1
        svName = [curDur filesep baseName(1:end-1) '_classifier_info'];
        save(svName, 'curDur', 'allLessThan4000', 'didRun') 
        allClassifierInfo{k, 1} = load(svName);
        allClassifierInfo{k, 2} = svName;
    end
end

save( [trackingINfoSaveDir filesep 'allClassifierInfo_' dateString1], 'allClassifierInfo');
try
    yay
catch
    disp('DONE')
end
end




