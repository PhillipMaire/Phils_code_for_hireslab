%% miniUbuilder

allDirs = dirFinder('C:\Users\maire\Documents\PLOTS\sigTest4_color');
% allDirs = dirFinder('C:\Users\maire\Documents\PLOTS\sigTest2_incluseBLinSIG');
clear Var
allMats = [];
varName = [];
counter = 0 ;
for dirITER = 1:length(allDirs)
    tmpDir = dir(allDirs{dirITER});
    for matITER = 1:length(tmpDir)
        if ~isempty(strfind(tmpDir(matITER).name, '.mat'))
            counter = counter +1;
            allMats{counter} = [tmpDir(matITER).folder filesep tmpDir(matITER).name];
            varName{counter} = tmpDir(matITER).name ;
        end
    end
    
end

% V = struct;

for k = 1:length(varName)
    %     disp(k)
    varName2 = varName{k};
    varName2(strfind(varName2, ' ')) = '';
    tmpInd = strfind(varName2, '.mat');
    varName2(tmpInd:tmpInd+3) = '';
    varName3{k} = varName2
    eval(['Var.' varName2 ' = load(allMats{k});']);
    
end

%% plot 6 variables for each cell
allColors5forEach = [0.968627450980392,0.988235294117647,0.960784313725490;0.900960741532397,0.961941434415622,0.881706143962623;0.788535538826604,0.916999028025004,0.761248740349804;0.645975227251591,0.857541423944342,0.621668533998042;0.462771230793144,0.772174187131252,0.467733519497025;0.968627450980392,0.988235294117647,0.960784313725490;0.900960741532397,0.961941434415622,0.881706143962623;0.788535538826604,0.916999028025004,0.761248740349804;0.645975227251591,0.857541423944342,0.621668533998042;0.462771230793144,0.772174187131252,0.467733519497025;1.00000000000000,0.960784313725490,0.921568627450980;0.996251969612609,0.903924073646517,0.812109271599140;0.992275605727568,0.822512011595108,0.647574527260135;0.991784510264188,0.694714566428809,0.438541717120922;0.992944086826071,0.558328140267459,0.242235998720294;0.988235294117647,0.984313725490196,0.992156862745098;0.939172863503933,0.931242538940142,0.961805380532665;0.861108239152778,0.860408544601122,0.924333338654349;0.748267928583596,0.753315783836646,0.869455308608010;0.624458462360098,0.608792187601125,0.786926556764122;0.968627450980392,0.984313725490196,1.00000000000000;0.873074974258069,0.923545110095955,0.969343005337437;0.783636062522545,0.862361996233453,0.940002740649136;0.636494455771335,0.800058046120998,0.886949644452653;0.427406211792390,0.686902923998760,0.841242633246428;1,0.960784313725490,0.941176470588235;0.996317647356175,0.882121222868142,0.828697351894151;0.988515653331714,0.742964325023006,0.643323844631906;0.988138237076458,0.586876077500047,0.462734903409073;0.984804886283496,0.422453441971893,0.295937430731941];

startNum = 5;
colorVars = allColors5forEach(startNum:5:length(allColors5forEach), :);


% varNameCell = {'Tpro' 'Tret' 'Pup' 'Pdown' 'Lall' 'Lans'};
% colorCell = {'Blues' 'Reds' 'Purples' 'Oranges' 'Greens' 'Greens' };

colorCell = {'Greens' 'Greens'  'Oranges' 'Purples'  'Blues' 'Reds' };
colorIntesnityMat = [80 80 70 80 80 70];% up to 100

winSize = 5; %use the same as the one to create the mat files used here
saveLoc = ['C:\Users\maire\Documents\PLOTS\OverlapTouch\'];
mkdir(saveLoc)
smoothVar = 5;
sigVal = 0.05;
lineSizeSet = 1.5;
%               varName3'
varToPlotNums = [4 3 5 6 1 2];%[5 6 ]% 5 6 1 2]; %1:length(varName3)
timeWin = -100 :200;
signalTime = Var.medianPval_Lall_plotVars.signalIndex;
startLookSignif = find(timeWin(signalTime)== 5);%5 mas after basline

isModulated = ones(length(varToPlotNums), length(xyxColor));
subplotMakerNumber = 1 ; subplotMaker
for k = varToPlotNums
    for kk = 1:length(xyxColor)
        if k == varToPlotNums(1)
            subplotMakerNumber = 2 ; subplotMaker
        else
            subplotMakerNumber = 3 ; subplotMaker
        end
        disp(num2str(kk))
        
        
        %     SP1 = 3; %subplot indice 1
        %     SP2 = 2; %subplot indice 2
        
        evalString = [];
        xyxColorEVAL = ['xyxColor = Var.' varName3{k} '.allTraces;'];
        eval(xyxColorEVAL);
        ColMapEVAL = ['ColMap = Var.' varName3{k} '.colorMapCell;'];
        eval(ColMapEVAL);
        pSigValsEVAL = ['pSigVals = Var.' varName3{k} '.PsigTimeAll;'];
        eval(pSigValsEVAL);
        signalIndexEVAL = ['signalIndex = Var.' varName3{k} '.signalIndex;'];
        eval(signalIndexEVAL);
        
        
        hold on
        x = xyxColor{kk}(1,:);
        y = xyxColor{kk}(2,:);
        z = xyxColor{kk}(3,:);
        col = xyxColor{kk}(4,:);
        y = smooth(y, smoothVar)';
        %         surface([x;x],[y;y],[z;z],[col;col],...
        %             'facecol','no',...
        %             'edgecol','interp',...
        %             'linew',2, 'FaceAlpha',0.0001);
        %         toColorMap = ColMap{1};
        %         toColorMap = toColorMap(1:50, :);
        %         toColorMap(floor(linspace(1, length(toColorMap), 5)), :);
        %         test = gca;
        %         colormap(test, toColorMap);
        
        sigTransVal = 0.1;
        
        %%%
        brewCol =   brewermap(100, colorCell{k});
        brewCol = brewCol(colorIntesnityMat(k), :);
        transparentVal = (1 - sigTransVal)./winSize;
        tmpPlot = plot(x,y);
        tmpPlot.Color = [brewCol , transparentVal];
        
        tmpPlot.LineWidth = lineSizeSet;
        pSigValsTMP = pSigVals{kk};
        timeSig = find(pSigValsTMP<sigVal);
        
        for kforPlot = 1:length(timeSig)
            %             keyboard
            sigSegmentTmp = timeSig(kforPlot) :timeSig(kforPlot) + winSize;
            sigSegmentTmp = signalIndex(sigSegmentTmp);
            %             sigSegmentTmp = sigSegmentTmp;
            tmpSigSegmentPlot = plot(indexTime(sigSegmentTmp), y(sigSegmentTmp), 'r');
            tmpSigSegmentPlot.Color = [brewCol , transparentVal];
            tmpSigSegmentPlot.LineWidth = lineSizeSet;
            
            %    tmpRec =  rectangle('Position', posTMP);
            
        end
        xlim([timeWin(1) , timeWin(end)]);
        
        test2 = smooth(pSigValsTMP, 1);
        test2 = test2( startLookSignif: end);
        test2 = find(test2 <= .01);
        
        
        
        if numel(test2) <1
            %                     set(gca,'Color',[0.5 0.5 0.5 0.5]);
            isModulated(k, kk) = 0;
        end
    end
    
    
end
% % keyboard
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
% generalName = ['T_p-r_overlap_thick'] ;
% filename =  [saveLoc, generalName];
% saveas(gcf,filename,'png')
% 
% %         export_fig(gcf, [filename,'.png'])
% savefig(filename)
%         close all

%%




