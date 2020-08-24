%%
% philsClassifier
% cd('C:\Users\maire\Downloads')
%{

% startDir = 'X:\Video\PHILLIP\AH1014 on 190709


%%

tic
startDir = 'X:\Video\PHILLIP\AH1014';
 philsClassifier_2(startDir, 80)
startDir = 'X:\Video\PHILLIP\AH1015';
 philsClassifier_2(startDir, 160)
startDir = 'X:\Video\PHILLIP\AH1016';
 philsClassifier_2(startDir, 150)
startDir = 'X:\Video\PHILLIP\AH1017';
 philsClassifier_2(startDir, 150)

toc

startDir = 'C:\testingClass2';
 philsClassifier_2(startDir, 100)




% parfor is not faster

%}
%% jus to save info, should always be the same
function [] = philsClassifier_2(startDir, Lthresh)
trackingINfoSaveDir =  'C:\Users\maire\Downloads\tmpdir';
dateString1 = datestr(now,'yymmdd_HHMM');
%% get all the files from every dir
pickClosestToPole = false;% for double whisker touch detection
pickClosestToFolicleIfWlengthsAreSimilar = true; % ONLY ONE OF THESE SHOULD BE TRUE
allDistances = [];
maxDistFromMostRecentFollice = 10; %if more than this then it is not the correct whisker
numNearestWhiskersInTime = 1;% number of follicels (and whisker tips) to extract to test for the correct whisker
% follicel is taken from the "numNearestWhiskersInTime" number of follices closest to the time point in question
% BOTH CAN BE FALSE THOUGH
if all([pickClosestToPole,  pickClosestToFolicleIfWlengthsAreSimilar])
    error('user must pick either closest to pole or closest to folicle or neither but not both' )
end
%%
ONLY_RECLASSIFY_EMPTY_FRAMES = true;
% startDir = 'Y:\Whiskernas\Data\Video\PHILLIP\AH0718\';
dirs = regexp(genpath(startDir),['[^;]*'],'match');
% % % dirs = {startDir} %################################################remove
% Lthresh = 100; %length threshold. whisker must be larger than this
% threshMISSforceLargest = 1; % automatically classify the largest whiskeras %***********************
% centerOfMassJumpPrevention = 1%***********************
wskrNUM = 0; %whisker class label in mease and whisker files
FramesInVid = 4000; % frames in video for me it will always be the same but for lily or jinho they can read video and get actual fram numbers and set this iteratively
forceReClass = 1; %classify everything using this method -----outdated keep as 1
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
    
    
% % % %     %% get follicle average position
% % % %     if all(test1) && length(measF)>0
% % % %         timeRegion = [1000:3000];
% % % %         allEndsX = []; allEndsY = [];
% % % %         userSetNumberVidsToExtractFol = 10;
% % % %         if length(measF)>= userSetNumberVidsToExtractFol
% % % %         else
% % % %             userSetNumberVidsToExtractFol = length(measF);
% % % %         end
% % % %         for k = 1:userSetNumberVidsToExtractFol%get 10 iteration of whisker folicels to test against
% % % %             nameF = measF(k).name;
% % % %             [measurmentMat, fieldNamesM, measurmentstruct] = loadMeasurementsMat([curDur filesep nameF]);
% % % %             
% % % %             measurmentMat = measurmentMat(measurmentMat(:, 3)==wskrNUM ,:);
% % % %             [~, keepInd, keepInd2] = intersect(measurmentMat(:, 1), timeRegion);
% % % %             measurmentMat = measurmentMat(keepInd, :);
% % % %             allEndsX(end+1:end+length(measurmentMat(:,1))) = measurmentMat(:, 10);
% % % %             allEndsY(end+1:end+length(measurmentMat(:,1))) = measurmentMat(:, 11);
% % % %         end
% % % %         medFolPosition = [nanmedian(allEndsX), nanmedian(allEndsY) ];
% % % %     end
    
    
    %%
    
    
    for k =  1:length(measF)
        if all(test1) && length(measF)>0
            didRun = 1;
            
            while 1
                nameF = measF(k).name;
                [measurmentMat, fieldNamesM, measurmentstruct] = loadMeasurementsMat([curDur filesep nameF]);
                IDandTIME_M = measurmentMat(:,[2, 1]);% for aligning later
                saveOn = true;
                if sum(measurmentMat(:, 3) == wskrNUM)==FramesInVid && ONLY_RECLASSIFY_EMPTY_FRAMES
                    saveOn = false ;
                    break
                end
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
                
                
                
                % measurmentstruct.label = -ones(size(measurmentstruct, 1), 1);
                %trigger redo calssification
                %             classPart1()
                %              eachFrame = length(unique(fid(Lind))) == length(fid(Lind));
                
                if length(Lind) == FramesInVid  && ~all(measurmentMat(Lind, 3)) && eachFrame==0% just use the largest whiskers
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
                
                tmpU = unique(measurmentMat2(:,1));
                tmpU = tmpU(~isnan(tmpU)); %all tracked frames with at least one classified frame
                indBack = L>=Lthresh;
                measurmentMat2(~indBack, :) = nan;
                tmpU2 = unique(measurmentMat2(:,1)); tmpU2 = tmpU2(~isnan(tmpU2));
                
                %                       measurmentMat2 = measurmentMat2(find(~isnan(measurmentMat2)), :);
                %                 [segmentsTMP] = findInRow(idx2(:));
                %                 testSets = [segmentsTMP(:,1)-1, segmentsTMP(:,2)];% the first ind is why I put a -1 in there
                
                for kk = 1:length(tmpU2)
                    
                    if isempty(find((measurmentMat2(:, 1) == tmpU2(kk)) .* (measurmentMat2(:, 3) == wskrNUM))) && ONLY_RECLASSIFY_EMPTY_FRAMES
                        %identify frames with no whisker tracked
                        
                        
                        % (measurmentMat2(:, 1) == tmpU2(kk)
                        % this compared the tracked frame in tmpU2(kk) to
                        % ALL of the frame IDs in the the entire meas file
                        % also measurmentMat2 has only info on the whiskers
                        % that were long enough 
                        % so this...
                        % find((measurmentMat2(:, 1) == tmpU2(kk)))
                        % gives you all you indices in the measurmentMat2 
                        % variable that are 1) long enough and 2) in the
                        % frame we are interested in
                        % while this...
                        % find((measurmentMat2(:, 3) == wskrNUM))
                        % is a much bigger array which give you all the
                        % lables that are labled with our whisker number
                        % and are long enough 
                        
                        
                        theseOnes = find(measurmentMat2(:,1) == tmpU2(kk));
                        if length(theseOnes)>1
                            %% find teh nearest whisker follicles 
                            findNearestWs = abs((1:FramesInVid) - kk);
                            findNearestWs(kk) = inf;
                            [~, allNearestFrameInds] = sort(findNearestWs);
                            wiskIndex = find(measurmentMat(:, 3) == wskrNUM);
                            availFrame = measurmentMat(wiskIndex);
                            [~, ~, nearestFrameNums] = intersect(allNearestFrameInds-1, availFrame,'stable' );
                            index2nearestWhiskers = wiskIndex(nearestFrameNums(1:numNearestWhiskersInTime));
                            xPoints =  measurmentMat(index2nearestWhiskers, [10, 12]);
                            yPoints =  measurmentMat(index2nearestWhiskers, [11, 13]);
                            measurmentMat(index2nearestWhiskers, :);
                            BLpoints = [xPoints(:), yPoints(:)];
             
                            
                            %%
                            
                            %                     theseOnes =testSets(kk,1):testSets(kk,2);% from the meas mat different than the whisk locaitons
                            distMin = [];IDnumsW = [];distdistMinFolMin = [];distMinFolMinNearest = [];
                            allLengths = [];
                            for kkk = 1:length(theseOnes)
                                IDnumsM = IDandTIME_M(theseOnes(kkk), :);
                                IDnumsW(kkk) = find(all(IDandTIME_W == IDnumsM, 2));
                                tmpW = whiskerstruct(IDnumsW(kkk));
                                allLengths(kkk) = length(tmpW.x);
                                distMin(kkk) = min(sqrt((tmpW.x-barPosXY(1)).^2 + (tmpW.y-barPosXY(2)).^2));
%                                 distdistMinFolMin(kkk) = min(sqrt((tmpW.x-medFolPosition(1)).^2 + (tmpW.y-medFolPosition(2)).^2));
                                distMinFolMinNearest(kkk) = min(min(findDistance(BLpoints, [ tmpW.x, tmpW.y]))); 
                            end
                            for kkk = 1:length(theseOnes) %replace the clasification in the struct to save later GOOD JOBO
                                measurmentstruct(theseOnes(kkk)).label = int32(-1); %remove all labels (set to - 1)
                            end
                            if pickClosestToPole == true
                                [minPOleDist, closestW] = (min(distMin));
                                closestW = theseOnes(closestW); % classified whisker ind
                                measurmentstruct(closestW).label = int32(0); % replace just the one you want with the correct whisker number
                            elseif pickClosestToFolicleIfWlengthsAreSimilar
                                allDistances(end+1:end+length(distMinFolMinNearest)) = distMinFolMinNearest;
                                if sum( distMinFolMinNearest<maxDistFromMostRecentFollice)>1%2 or more close to teh follice (or tip) take the longest
                                    [~, bestW] = max(allLengths);
                                    bestW = theseOnes(bestW);
                                    measurmentstruct(bestW).label = int32(0);
                                elseif sum( distMinFolMinNearest<maxDistFromMostRecentFollice) == 1 % if only 1 meets the criteria use it 
                                    [minDist, bestW] = (min(distMinFolMinNearest));
                                    bestW = theseOnes(bestW); % classified whisker ind
                                    measurmentstruct(bestW).label = int32(0);
                                end
                            else
                                [~, largestW] = max(allLengths);
                                largestW = theseOnes(largestW); % classified whisker ind
                                measurmentstruct(largestW).label = int32(0); % replace just the one you want with the correct whisker number
                                
                            end
                        else % just set the largest whisker
                            
                            measurmentstruct(theseOnes).label = int32(0);
                        end
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
            if saveOn == true
                SaveMeasurements(M_W_Bdirs{1}, measurmentstruct)
            else
                saveOn = true;
                didRun = 0;
            end
            
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




