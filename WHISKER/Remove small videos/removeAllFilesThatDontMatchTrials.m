
function  removeAllFilesThatDontMatchTrials(input1 , input2)
% valid input examples are like these below...
% filelist_measurements=dir([d '*.measurements']);
% filelist_whiskers=dir([d '*.whiskers']);
% filelist_mp4=dir([d '*.mp4']);
% filelist_bar=dir([d '*.bar']);
% one for each input
% should look something like below 
% removeAllFilesThatDontMatchTrials(dir([d '*.mp4']), dir([d '*.measurements']))
% removeAllFilesThatDontMatchTrials(dir([d '*.mp4']), dir([d '*.whiskers']))


cd(input1(1).folder);
currentDir = pwd;
[trialNums1] = getTrialNumFromFileList(input1);
[trialNums2] = getTrialNumFromFileList(input2);
if length(trialNums1) >= length(trialNums2)
    [~, extraFilesNoMatchInd] = setdiff(trialNums1, trialNums2);
    whichOne = 1;
else
    [~, extraFilesNoMatchInd] = setdiff(trialNums2, trialNums1);
    whichOne = 2;
end
if isempty(extraFilesNoMatchInd)
    display('all match already')
else
extraFilesNoMatchInd = reshape(extraFilesNoMatchInd, [1, length(extraFilesNoMatchInd)]);
counter = 0;
for k = extraFilesNoMatchInd
    counter = counter +1;
    if whichOne == 1;
        fileNamesToMove{counter} = input1(k).name;
    elseif whichOne == 2;
        fileNamesToMove{counter} = input2(k).name;
    end
end
%string for messsage
if whichOne == 1
    fileEnd1 = num2str(input1(1).name(strfind(input1(1).name, '.'):end));
    fileEnd2 = num2str(input2(1).name(strfind(input2(1).name, '.'):end));
    
elseif whichOne == 2
    fileEnd2 = num2str(input1(1).name(strfind(input1(1).name, '.'):end));
    fileEnd1 = num2str(input2(1).name(strfind(input2(1).name, '.'):end));
end

findThis = '\Data\Video\';
lengthFindThis = length(findThis);
makeDirStart = strfind( currentDir, findThis);
test4 = makeDirStart+lengthFindThis;
test3 = strfind(currentDir(test4:end), '\');
test3 = test3(1)+test4 -1;;

part1newDir = currentDir(1:test3);
AddFolder = 'removedExtraFiles';
part2newDir = currentDir(test3:end);
newDirName = [part1newDir, AddFolder, part2newDir];

meassageString = ['there are ', num2str(length(fileNamesToMove)), ' files with ending ''', fileEnd1, ...
    ''', to be moved based on not matching file type ''', fileEnd2, '''. Want to copy them to a mirror directory ', newDirName ];

trigger = 0;
while trigger == 0
    button = questdlg( meassageString, 'title', 'yes', 'no', 'tickle me', 'Yes');
    switch button
        case 'yes'
            mkdir(newDirName)
            for k = 1:length(fileNamesToMove)
                moveCommand = ['move ',fileNamesToMove{k} , ' ', newDirName];
                system(moveCommand);
            end
            trigger =1;
        case 'no'
            display('nothing was moved, except really the whole universe is moving so only true for files on this pc');
            trigger =1;
        case 'tickle me'
            yayNESTED
    end
end
end


    function [trialNums1] = getTrialNumFromFileList(input1)
        locDash = find(input1(1).name=='-');
        locStartNum1 = length(input1(1).name(1:locDash))+1;
        for k = 1:length(input1)
            test2 = input1(k).name;
            locEndNum = find(test2 == '.') - 1;
            trialNums1(k) = str2num(test2(locStartNum1:locEndNum));
        end
    end

    function yayNESTED
        
        
        display('	                                               `.-:/+syhhyyyyso+:.                                  								')
        display('	                                       `:+shdmmmhyo+:.`        ./yds:                               								')
        display('	                                `..-/oo+:-.```                    `:sdo.                            								')
        display('	                            -ohNNNNds-                               `:ss.                          								')
        display('	                         .omds/:-.``                                    `/+.                        								')
        display('	                       `oNm/`                                             `:+`                      								')
        display('	                      /mMy`                                                 dd:                     								')
        display('	                    -hMd/                                                   :mNs.                   								')
        display('	                  `oNNo`                                       `:://:-.      .yMm+`                 								')
        display('	                 :dNy.                                        `hNhmdosyho-     sMMm+`               								')
        display('	               .yNd:                                         `yMNy:`   .+my-   .oymMd.              								')
        display('	             `+mm+`                                         -hmo-     `-:yMNy.  `hosNm`             								')
        display('	            /dNy.                                         -sh/`      `hNMMMMMNo` sNo/Ns             								')
        display('	      .   -hNh:                                         .sy:`        +MMMMMMMMMd:`+mshN`            								')
        display('	      h`-yNm/`                                         +m+`          oMMMMMMMMhyNo`.yNM/            								')
        display('	     `NsNNo`            ``.....``                     sN:            .odmmNNNNo /mh. /mm`           								')
        display('	     oMNs.         `.:ossooosyhddyo:.                .Ms                `...-.`  .md. .dh`          								')
        display('	    -NMo         .+hds:.      `:yNMMmy:`             :M+                          -Nd` .mh.         								')
        display('	    dMMs       `omd/`            -yMMMMh.            `dd`                          +M+  :Mm:        								')
        display('	.. /NMM/      .dMh/.`              /mN/-hs`           .dh`                         `Nm   yMN+       								')
        display('	hm osdm`     `mMMMMMmo              `+y-hM/            `yd-                         mN   .NNdy`     								')
        display('	hM-`-N:      oMMMMMMMM+                `sM-              +mo`                      .Ny    sM/dd`    								')
        display('	hM:`do       hMMMMMMMM/                `md                .sms:`                  .hh`    `Nd.dd`   								')
        display('	hM:hd        sMMMMMNh:                .dm.                  .+hmhs/-``         `:sd+       +Ms.Nh   								')
        display('	hMyM-        `dMo.`                  :mh`                       .:+oyyyyyyyyyhdds:          hM/+M:  								')
        display('	hMdN          `mo                  `yNo                                                     .NN:My  								')
        display('	hNyh           +d                 +Nd.                                                       /MdMm  								')
        display('	hmss           +M+              /mm/                                                          hMMM  								')
        display('	hys+           `oNy.         `+mmo`                                                           .MMM` 								')
        display('	ho+:             `/yhs+/::/+yNd+`                                                              yMM. 								')
        display('	hoh:                `-/+ooo+:.`                                                                .MM. 								')
        display('	hMM:                                                                                            dM. 								')
        display('	hMM:                                                 LOL                                        oM. 								')
        display('	hMMo                                              HAHA...ha                                      +M` 								')
        display('	hMNN-                                               he he         .ys.                          /N  								')
        display('	+MoMm.                                                            +MMh                          +h  								')
        display('	`NosM/                                                            +MMM                          o+  								')
        display('	 hd`No                                       .                    :MMM`                         s+  								')
        display('	 /M.+h                                      /Nh.                  .MMM                          sh` 								')
        display('	 `Ms`m/                                     oMMh                  .MMN                          oMd:								')
        display('	  dN.oN.                                    .mMMo`                /MMm                          -MMh								')
        display('	  /Ny`md`                                    .hMMd+-.`       ``.:yNMd:                           NMh								')
        display('	   -d++Ms                                     `/hNMMmdhyyyyyhhmNMMd+`                            NMy								')
        display('	    `hsdM:                                       ./shmmmNNNNNmmho:`                             +Md 								')
        display('	     `dNMh                                            ``.....`                                 oMN- 								')
        display('	      .NMN`                                                                                  `yMM+  								')
        display('	       oMMd-                                                                                 yMMs   								')
        display('	       `mdsmo`                                                                              /MMy    								')
        display('	        /N`.hm+`                                                                           `mMh     								')
        display('	         ds  /Nmo`                                                                         +Md`     								')
        display('	         :N-  `oNNy/`                                                                     `NN.      								')
        display('	          yh     -+sdy/.                                                                  sm/      								')
        
        
    end
end