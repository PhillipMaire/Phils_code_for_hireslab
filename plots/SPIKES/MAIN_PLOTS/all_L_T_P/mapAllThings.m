%% miniUbuilder

allDirs = dirFinder('C:\Users\maire\Documents\PLOTS\sigTest4_color');
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

%%
saveLoc = ['C:\Users\maire\Documents\PLOTS\all_L_T_P_smooth\'];
mkdir(saveLoc)
smoothVar = 10;
%               varName3'
kNums = [4 3 5 6 1 2]; %1:length(varName3)
for kk = 1:length(xyxColor)
    disp(num2str(kk))
    SP1 = 3; %subplot indice 1
    SP2 = 2; %subplot indice 2 
    subplotMakerNumber = 4 ; subplotMaker
    for k = kNums
        evalString = [];
        xyxColorEVAL = ['xyxColor = Var.' varName3{k} '.allTraces;'];
        eval(xyxColorEVAL);
        ColMapEVAL = ['ColMap = Var.' varName3{k} '.colorMapCell;'];
        eval(ColMapEVAL);
        
        subplotMakerNumber = 2 ; subplotMaker
        hold on
        x = xyxColor{kk}(1,:);
        y = xyxColor{kk}(2,:);
        z = xyxColor{kk}(3,:);
        col = xyxColor{kk}(4,:);
        y = smooth(y, smoothVar)';
        surface([x;x],[y;y],[z;z],[col;col],...
            'facecol','no',...
            'edgecol','interp',...
            'linew',2, 'FaceAlpha',0.0001);
        toColorMap = ColMap{1};
        %         toColorMap = toColorMap(1:50, :);
        toColorMap(floor(linspace(1, length(toColorMap), 5)), :);
        test = gca;
        colormap(test, toColorMap);
        xlim([-100 , 200]);
        
        
        
        
    end
    keyboard
    generalName = [num2str(kk), ' P_u-d_T_p-r_L_all-ans'] ;
    filename =  [saveLoc, generalName];
    saveas(gcf,filename,'png')
    savefig(filename)
end

%% all on a single plot color coded 
saveLoc = ['C:\Users\maire\Documents\PLOTS\all_L_T_P_smooth\'];
mkdir(saveLoc)
smoothVar = 10;
varName3'
allColors5forEach = [0.968627450980392,0.988235294117647,0.960784313725490;0.900960741532397,0.961941434415622,0.881706143962623;0.788535538826604,0.916999028025004,0.761248740349804;0.645975227251591,0.857541423944342,0.621668533998042;0.462771230793144,0.772174187131252,0.467733519497025;0.968627450980392,0.988235294117647,0.960784313725490;0.900960741532397,0.961941434415622,0.881706143962623;0.788535538826604,0.916999028025004,0.761248740349804;0.645975227251591,0.857541423944342,0.621668533998042;0.462771230793144,0.772174187131252,0.467733519497025;1.00000000000000,0.960784313725490,0.921568627450980;0.996251969612609,0.903924073646517,0.812109271599140;0.992275605727568,0.822512011595108,0.647574527260135;0.991784510264188,0.694714566428809,0.438541717120922;0.992944086826071,0.558328140267459,0.242235998720294;0.988235294117647,0.984313725490196,0.992156862745098;0.939172863503933,0.931242538940142,0.961805380532665;0.861108239152778,0.860408544601122,0.924333338654349;0.748267928583596,0.753315783836646,0.869455308608010;0.624458462360098,0.608792187601125,0.786926556764122;0.968627450980392,0.984313725490196,1.00000000000000;0.873074974258069,0.923545110095955,0.969343005337437;0.783636062522545,0.862361996233453,0.940002740649136;0.636494455771335,0.800058046120998,0.886949644452653;0.427406211792390,0.686902923998760,0.841242633246428;1,0.960784313725490,0.941176470588235;0.996317647356175,0.882121222868142,0.828697351894151;0.988515653331714,0.742964325023006,0.643323844631906;0.988138237076458,0.586876077500047,0.462734903409073;0.984804886283496,0.422453441971893,0.295937430731941];

startNum = 5;
colorVars = allColors5forEach(startNum:5:length(allColors5forEach), :);

kNums = [4 3 5 6 1 2]; %1:length(varName3)
subplotMakerNumber = 1 ; subplotMaker
transparentVal = 0.8;

for kk = 1:length(xyxColor)
    disp(num2str(kk))
    subplotMakerNumber = 2 ; subplotMaker
    %     SP1 = 3; %subplot indice 1
    %     SP2 = 2; %subplot indice 2
    for k = kNums
        xyxColorEVAL = ['xyxColor = Var.' varName3{k} '.allTraces;'];
        eval(xyxColorEVAL);
        ColMapEVAL = ['ColMap = Var.' varName3{k} '.colorMapCell;'];
        eval(ColMapEVAL);
        
        hold on
        x = xyxColor{kk}(1,:);
        y = xyxColor{kk}(2,:);
        %         z = xyxColor{kk}(3,:);
        col = xyxColor{kk}(4,:);
        selectRegion = find(col< .4);
        
        
        if ~isempty(selectRegion)
            x = smooth(x, smoothVar);
            y = smooth(y, smoothVar);
            
            x(selectRegion)= nan;
            y(selectRegion)= nan;
            
            tmpP = plot(x, y, 'r');
            tmpP.Color = [ colorVars(k,:), transparentVal];
        end
        
        
        %         toColorMap = ColMap{1};
        %         %         toColorMap = toColorMap(1:50, :);
        %         toColorMap(floor(linspace(1, length(toColorMap), 5)), :);
        %         test = gca;
        %         colormap(test, toColorMap);
        xlim([-100 , 200]);
        %         figure
    end
    keyboard
end
%%




























kNums = 1:length(varName3);
% kNums = 1:2
kkNums = 1: length(xyxColor);
for kk = kkNums
    %%
    for k = kNums
        evalString = [];
        xyxColorEVAL = ['xyxColor = Var.' varName3{k} '.allTraces;'];
        eval(xyxColorEVAL);
        ColMapEVAL = ['ColMap = Var.' varName3{k} '.colorMapCell;'];
        eval(ColMapEVAL);
        
        %
        %         close all
        %         mainFin = figure
        hold on
        x = xyxColor{kk}(1,:);
        y = xyxColor{kk}(2,:);
        z = xyxColor{kk}(3,:);
        col = xyxColor{kk}(4,:);
        num = length(x);
        if k ==kNums(1)
            allVars2Plot = nan([4, num,length(kNums)]);
        end
        allVars2Plot( 1, :, k) = x;
        allVars2Plot( 2, :, k) = y;
        allVars2Plot( 3, :, k) = z;
        allVars2Plot( 4, :, k) = col+k - 1;
        
        toColorMap = ColMap{1};
        toColorMap = toColorMap(1:50, :);
        numColorsPer = 5;
        toColorMap = toColorMap(floor(linspace(1, length(toColorMap), numColorsPer)), :);
        if k == 1
            
            toColorMapAll = toColorMap;
        else
            toColorMapAll(size(toColorMapAll,1)+1:size(toColorMapAll,1) + numColorsPer , 1:3) = toColorMap;
        end
        
    end
    %%
    figure
    L = allVars2Plot;
%     plot(allVars2Plot(:,:,1),allVars2Plot(:,:,2),allVars2Plot(:,:,3),allVars2Plot(:,:,4))
    
%     plot(allVars2Plot(1,:,
    
    
    colormap(toColorMapAll)
    %         xlim([-100 , 200])
    %         pause(1)
    %%
    
end








