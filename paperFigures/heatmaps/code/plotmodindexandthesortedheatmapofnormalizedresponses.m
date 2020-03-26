% %% plot mod index and the sorted heatmap of normalized responses

V = {}; % this program must run first to prevent V from being cleared
smoothByForMaxResp = 3;
saveNames = {...
    'poleUp exc'...
    'poleUp inh'...
    'poleDown exc'...
    'poleDown inh'...
    'touch exc'...
    'touch inh'...
    }





for k = theseCells(:)'
    for eachType = 1:3
        %% set up
        if eachType == 1
            look4signalRange = 8:200
            var1= pole{k}.up;
            sig = var1.SIG;
            BL = var1.BL;
            plotRange = var1.plotRange;
            E = var1.sigEcite;
            I = var1.sigInhibit;
            isTooLowSPK = var1.isTooLowSPK;
        elseif eachType == 2
            look4signalRange = 8:200
            var1= pole{k}.down;
            sig = var1.SIG;
            BL = var1.BL;
            plotRange = var1.plotRange;
            E = var1.sigEcite;
            I = var1.sigInhibit;
            isTooLowSPK = var1.isTooLowSPK;
        elseif eachType == 3
            look4signalRange = 8:80
            var1 = allCellsTouch{k};
            sig = var1.SIG;
            BL = var1.BL;
            plotRange = var1.plotRange;
            E = var1.sigEcite;
            I = var1.sigInhibit;
            isTooLowSPK = var1.isTooLowSPK;
            V{eachType, k}.protractionTouches = var1.protractionTouches;
            V{eachType, k}.sigEcite = var1.sigEcite;
            V{eachType, k}.sigInhibit = var1.sigInhibit;
            V{eachType, k}.segments = var1.segments;
            %             if k == 29
            %                 keyboard
            %             end
            
        end
        zeroInd = find(plotRange==0);
        y = nanmean(sig, 2);
        y2 = y(zeroInd+1:end);
        V{eachType, k}.EnotCont = E;
        V{eachType, k}.InotCont = I;
        E = min(E):max(E);% if there are points in between we want those for finding peakszeroInd
        I = min(I):max(I);% if there are points in between we want those for finding peakszeroInd
        %% Change E and I to limit the response to the selected region
        E = intersect(E,  look4signalRange-plotRange(1));
        I = intersect(I,  look4signalRange-plotRange(1));
        %%
        inaRowStruct = findInARowFINAL(I);
        if ~isempty(fieldnames(inaRowStruct))
            V{eachType, k}.Ifirst = I(inaRowStruct.startInds(1): inaRowStruct.endInds(1))
        else
            V{eachType, k}.Ifirst = [];
        end
        inaRowStruct = findInARowFINAL(E);
        if ~isempty(fieldnames(inaRowStruct))
            V{eachType, k}.Efirst = E(inaRowStruct.startInds(1): inaRowStruct.endInds(1))
        else
            V{eachType, k}.Efirst = [];
        end
        
        
        
        V{eachType, k}.sig = sig;
        V{eachType, k}.plotRange = plotRange;
        V{eachType, k}.E = E;
        V{eachType, k}.I = I;
        V{eachType, k}.BL = BL;
        %% is significant (each stim type)
        V{eachType, k}.isSig = 0;
        if ~isTooLowSPK
            if ~isempty([E(:); I(:)])
                V{eachType, k}.isSig = 1;
            end
        end
        %% get modulation index for plotting signify the significant cells (each stim type)
        V{eachType, k}.MI = (nanmax(y2) - nanmean(BL(:)))./(nanmax(y2) + nanmean(BL(:)));
        %% is it non-monotonic (each stim type) %% biggest modulation direction (each stim type)
        look4signalRange-plotRange(1)
        
        %%
        if (V{eachType, k}.isSig == 0) || ( isempty(E) && isempty(I)) % not modulated
            V{eachType, k}.ModDirection = 0;
        elseif ~isempty(E) && ~isempty(I)
            [~, Eseg] = findInARowFINAL(E);
            [~, Iseg] = findInARowFINAL(I);
            if max(Eseg(:, end)) ~= max(Iseg(:, end)) %largest continious portion
                [~, Mind] = max([max(Eseg(:, end)),  max(Iseg(:, end))]);
                V{eachType, k}.ModDirection = ((Mind*2)-3)*-2; %turn 1 into 2 and 2 into -2
            elseif length(I) ~= length(E) %if equal then largest total portion
                [~, Mind] = max([length(E),  length(I)]);
                V{eachType, k}.ModDirection = ((Mind*2)-3)*-2; %turn 1 into 2 and 2 into -2
            else % if equal then first instance
                [~, Mind] = min([E(1), I(1)]);
                V{eachType, k}.ModDirection = ((Mind*2)-3)*-2; %turn 1 into 2 and 2 into -2
            end
        elseif ~isempty(E) %modulated only upwards
            V{eachType, k}.ModDirection = 1;
        elseif ~isempty(I)%modulated only downwards
            V{eachType, k}.ModDirection = -1;
        end
        %%  sorted by peak E/I seperate use biggest modulation direction to determine E/I
        if V{eachType, k}.ModDirection == 0
            V{eachType, k}.onset = nan;
        elseif V{eachType, k}.ModDirection >0
            V{eachType, k}.onset = E(1)-zeroInd;
        elseif V{eachType, k}.ModDirection <0
            V{eachType, k}.onset = I(1)-zeroInd;
        end
        %%  sorted by peak E/I seperate use biggest modulation direction to determine E/I
        if V{eachType, k}.ModDirection == 0
            V{eachType, k}.onsetMAX = nan;
        elseif V{eachType, k}.ModDirection >0
            [~, t2] =  max(smoothTrimEdges(y(E), smoothByForMaxResp));
            V{eachType, k}.onsetMAX =E(t2);
        elseif V{eachType, k}.ModDirection <0
            [~, t2] =  min(smoothTrimEdges(y(I), smoothByForMaxResp));
            V{eachType, k}.onsetMAX =I(t2);
        end
    end
end

%% plot it
crush
smoothBy = smoothByForMaxResp;
h = {};
counter = 0;
normTYPE = 2
for k = 1:3
    
    var1 = V(k,:);
    for kk = 1:2
        counter = counter+1;
        if kk == 1
            Eind = find(cellfun(@(x) x.ModDirection, var1)>0);
        else
            Eind = find(cellfun(@(x) x.ModDirection, var1)<0);
        end
        onsets = cellfun(@(x) x.onsetMAX, var1);
        Eonsets = onsets(Eind);
        [sortE, SindE] = sort(Eonsets);
        %%
        
        E = cell2mat(cellfun(@(x)  nanmean(x.sig, 2), var1(Eind), 'UniformOutput', false));
        E = nansmooth(E, smoothBy, 'mat');
        E = smoothEdgesNan(E, smoothBy);
        if normTYPE == 1 % range
            E = normalize(E, 'range');
        elseif normTYPE == 2 %div by max
            E = E./nanmax(E);
        end
        E = (E(:, SindE))';
        Eind = Eind(SindE);
        h{end+1} = figure;
        if nanmax(E)~= nan
            imagescnan(E);
            ylim([0, 30]) % this way every imagesc is on the same sclae
            %         title((Eind))
            hold on
            plot(((-E')+(repmat(2:size(E, 1)+1, size(E, 2), 1))))
            colorbar
            y1 = ylim;
            x1 = xlim;
            tmp2= (1:size(E, 1))+.5;
            textNumArray(zeros(size(tmp2)), tmp2, Eind)
            %         keyboard
            %         text(zeros(size(tmp1))', tmp1', num2str(Eind)')
            %         text(1, 1, 1)
            title(saveNames{counter});
            plot(sortE, 1:length(sortE), '*r')
            xticklabels(xticks-find(var1{1, 1}.plotRange==0)+1);
            xlim(x1)
            ylim(y1)
            colormap(turbo(1000))
        else
            imagescnan(1)
        end
    end
end
%%

% MI = cellfun(@(x) x.MI, V);
% isSig = cellfun(@(x) x.isSig, V);
% h2 = figure;
% imagesc(MI);
% colormap('gray');
% colorbar
% [y, x]= find(~isSig);
% hold on
% plot(x, y, 'sr')
%%


PU_PD_T_AMP = cellfun(@(x) x.ModDirection, V);
PU_PD_T_AMP = [PU_PD_T_AMP;(Whisk.allMods(3, :)>Whisk.mod2beat(3, :))];
% num2color = 5;
%% make simply 3 colors
PU_PD_T_AMP(PU_PD_T_AMP>1) = 1;
PU_PD_T_AMP(PU_PD_T_AMP<-1) = -1;
% num2color = 3;
%% make 2 colors
% % % % PU_PD_T_AMP(PU_PD_T_AMP~=0) =1;
% % % % % num2color = 2;
%%

[inds1, sortedMat] = sortMulti((abs(PU_PD_T_AMP+.1))', [1 2 3 4]);
inds1 = flip(inds1);
% [inds1, sortedMat] = sortMulti((PU_PD_T_AMP-10)', [1 2 3 4]);
% [~, sort1] = sort(abs(PU_PD_T_AMP(3, :)+.1));
PU_PD_T_AMPtoPlot = PU_PD_T_AMP(:, (inds1));
h{end+1} = figure;
imagescnan(PU_PD_T_AMPtoPlot, true)
hold on
for k = 1:4
    textNumArray((1:length(inds1))+.25, ones(size(inds1))*(k+.5), inds1)
end
savedIndsFortheResponsePropMap = inds1
colormap(brewermap(5, 'RdBu'))
colorbar('XTickLabel', {'I notMono' 'I Mono' '' 'E Mono' 'E notMono'},'XTick', -2:2)
yticks(1:size(PU_PD_T_AMPtoPlot, 1))
yticklabels({'poleUp' 'poleDown' 'touch' 'amp'})
%%

if saveOn
    saveNames = {'poleUpHeatExcite' 'poleUpHeatInhibit' 'poleDownHeatExcite' 'poleDownHeatInhibit'...
        'touchHeatExcite' 'touchHeatInhibt' 'isModulatedMap'}
    for k = 1:length(h)
        cd(saveDir)
        fullscreen(h{k})
        fn = [saveNames{k}, '_', dateString1];
        saveFigAllTypes(fn, h{k}, saveDir, 'plotmodindexandthesortedheatmapofnormalizedresponses.m');
    end
end
%%
%{

dateString1 = datestr(now,'yymmdd_HHMM');

cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures')
upEI_downEI_touchEI= hibernatescript('plotmodindexandthesortedheatmapofnormalizedresponses.m');
for k = 1:6;
cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\ALL')
fullscreen(h{k})
pause(6)

fig2svg([saveNames{k}, '_', dateString1, '.svg'], h{k})

end
% fig2svg(['modIndex_', dateString1, '.svg'], h2)
export_fig(h2,  ['modIndex_', dateString1, '.svg'])

save(['upEI_downEI_touchEI', dateString1], 'upEI_downEI_touchEI')
cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures')
% revivescript(funcString)
%}