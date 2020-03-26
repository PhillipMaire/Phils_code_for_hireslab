%%


%% get spikes per sec within a region


%% plot all cells with depth

%% blue are excited red are inhibited
%% V will do touch and poles


%% whisking simple method uses allWhiskingVar

%%
crush

thresh1 = 1-.975;
varNames = {'poleUP' 'poleDOWN' 'touch' 'whisking'}
isSig = cellfun(@(x) x.isSig, V);
ModDirection = cellfun(@(x) x.ModDirection, V);
isSig(end+1, :) = cellfun(@(x) x.Ttest<thresh1, allWhiskingVar);
try
depth1 = cellfun(@(x) x.details.depth, U);
catch
  depth1 = cellfun(@(x) x.meta.depth , U); 
end

timeWin = 1:4000;
spkPerSec = 1000.*cellfun(@(x) nanmean(nanmean(x.R_ntk(:,timeWin, :))),  U);


ModDirection(end+1, :) = cellfun(@(x) x.ModDirection, allWhiskingVar).*isSig(end, :);

h = {};
figs1 = {}
for k = 1:4
    figs1{end+1} = figure;hold on
    isSigtmp = logical(isSig(k, :));
    h{end+1} = plot(depth1(isSigtmp),  spkPerSec(isSigtmp), 'ko')
    h{end}.MarkerFaceColor = 'k';
    h{end+1} = plot(depth1(~isSigtmp),  spkPerSec(~isSigtmp), 'ko')
    legend({'significant' 'insignificant'}, 'Location', 'northwest');
    
    
    figs1{end+1} = figure;hold on
    isSigEXCITE = ModDirection(k, :)>0;
    isSigINHIBIT = ModDirection(k, :)<0;
    neither1 = ~isSigEXCITE & ~isSigINHIBIT;
    h{end+1} = plot(depth1(isSigEXCITE),  spkPerSec(isSigEXCITE), 'bo')
    try
    catch
        h{end}.MarkerFaceColor = 'b';
    end
    h{end+1} = plot(depth1(isSigINHIBIT),  spkPerSec(isSigINHIBIT), 'ro')
    try
    catch
        h{end}.MarkerFaceColor = 'r';
    end
    h{end+1} = plot(depth1(neither1),  spkPerSec(neither1), 'ko')
    legend({'significantly excited' 'significantly inhibited' 'insignificant'}, 'Location', 'northwest');
end

title1 = {'poleUP' 'poleDOWN' 'touch' 'whisking';'poleUP' 'poleDOWN' 'touch' 'whisking' };
for k = 1:length(figs1)
    figure(figs1{k});
    title(title1{k})
    ylabel('Spikes/Sec')
    xlabel('Depth')
    
end
%%
if saveOn
    saveNames = {'poleUP_spkVSdepth' 'poleDOWN_spkVSdepth' 'touch_spkVSdepth' 'whisking_spkVSdepth'...
        ;'poleUP_spkVSdepth' 'poleDOWN_spkVSdepth' 'touch_spkVSdepth' 'whisking_spkVSdepth'};
    
    for k = 2:2:length(figs1)
        cd(saveDir)
        fullscreen(figs1{k})
        fn = [saveNames{k}, '_', dateString1];
        saveFigAllTypes(fn, figs1{k}, saveDir, 'spikerateVSdepth.m');
    end
    winopen(saveDir)
end


