%%

T = U{1}

spks = squeeze(T.R_ntk);
A.spkPerS = round(mean(spks(:))*1000,2) ;
%%
[xSPK, ySPK]= find(spks>0);
flatSpks = mean(spks, 2);
figure; plot(xSPK, ySPK, '.k')
hold on; plot(smooth(flatSpks*max(xSPK), 10))
%%

dtmp = datestr(date, 'yymmdd_MM');
% clearvars -except allCells allCells2  allCells3 errorMes dtmp
% crush
dateString = datestr(now,'yymmdd_HHMM');

cellLoc =1:83;
PhysiologyDataLOC = 'C:\Users\maire\Dropbox\HIRES_LAB\PHYSIOLOGY_RECORDS';

sheetName = 'S1_for_JON';
ephusBase = 'C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\EPHUS';
%         ephusBase = 'Z:\Users\Phil\Data\EPHUS'
videoloc    = 'X:\Video\PHILLIP';%%
behavArrayLoc ='C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\BehaviorArrays';% for saving after built
behavFileLoc = 'C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\Behavior';% actual behav data directory
behaviorProtocalName = '@pole_contdiscrim_obj';%protocol name

cd(PhysiologyDataLOC)
physDat = struct2cell(dir('Physiology Data *'));
[~, tmpInd] = max(cell2mat(physDat(end, :)));
fileName = physDat{1, tmpInd};% get Phys data file name
%% load all the info form teh excell sheeet

PhysSpreadSheet = readtable(fileName,'Sheet',sheetName, 'range', 'A2:BX85'); %A2 means data starts at A3
PhysSpreadSheet2= table2cell(PhysSpreadSheet);
% cellNumberForProject = num2str(PhysSpreadSheet2{cellLoc, 3 });
% projectName = upper(sheetName);
% mouseName  =  PhysSpreadSheet2{cellLoc, 5 };
% sessionName =datestr(PhysSpreadSheet2{cellLoc, 10 }, 'yymmdd');
% code        = PhysSpreadSheet2{cellLoc, 7 };
% cellnum     = PhysSpreadSheet2{cellLoc, 8 };

depth =  cell2mat(PhysSpreadSheet2(:, 20));  % in um from pia
% depth = round(depth, 1);
E_I_NA = cell2mat(PhysSpreadSheet2(:, 75))
%%
binSize = 20;
EDGES = -1000:binSize:-500
cd('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\plots\S1DataForJon\depth counts')
svName = 'allCells'
crush
dateString1 = datestr(now,'yymmdd_HHMM')
h = figure; hold on 
ylabel('Depth (microns)')
xlabel('number of cells')
sdf(gcf, 'default18')
h.Units = 'normalized'
h.Position = [1 0 .8, .8]

% [counts,bins] = hist(depth*-1, 20); %# get counts and bin locations
rectangle('Position', [0, -588-3, 100, 6 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -708-4, 100, 8 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -890-5, 100, 10 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])

text(11, -571, 'L4', 'FontSize',24)
text(11, -690, 'L5A', 'FontSize',24)
text(11, -873, 'L5B', 'FontSize',24)
text(11, -925, 'L6', 'FontSize',24)

[counts,EDGES] = histcounts(-depth,EDGES)

ylim([-975, -550]);
bins = EDGES(1:end-1)+(.5*binSize)
xlim([0 max(counts)+4])
barh(bins,counts);
saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])
%%
%%
silentInds = [8 9 11 12 16 33 37 56 57 77 79];
length(silentInds)
svName = 'silentCells'
binSize = 20;
EDGES = -1000:binSize:-500
cd('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\plots\S1DataForJon\depth counts')

crush
dateString1 = datestr(now,'yymmdd_HHMM')
h = figure; hold on 
ylabel('Depth (microns)')
xlabel('number of cells')
sdf(gcf, 'default18')
h.Units = 'normalized'
h.Position = [1 0 .8, .8]

% [counts,bins] = hist(depth*-1, 20); %# get counts and bin locations
rectangle('Position', [0, -588-3, 100, 6 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -708-4, 100, 8 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -890-5, 100, 10 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])

text(11, -571, 'L4', 'FontSize',24)
text(11, -690, 'L5A', 'FontSize',24)
text(11, -873, 'L5B', 'FontSize',24)
text(11, -925, 'L6', 'FontSize',24)




[counts,EDGES] = histcounts(-depth,EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts);

ylim([-975, -550]);
xlim([0 max(counts)+4])

[counts,EDGES] = histcounts(-depth(silentInds),EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts, 'r');

% saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])

%%
likelyTouch = [1 2 6 10 13 14 18 19 20 21 23 26 27 31 32 35 38 42 43 45 48 50 52 53 54 61 62 66 68 69 70 71 72 74 75 76 81 82 83];
length(likelyTouch)
binSize = 20;
EDGES = -1000:binSize:-500
cd('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\plots\S1DataForJon\depth counts')
svName = 'likely touch'
crush
dateString1 = datestr(now,'yymmdd_HHMM')
h = figure; hold on 
ylabel('Depth (microns)')
xlabel('number of cells')
sdf(gcf, 'default18')
h.Units = 'normalized'
h.Position = [1 0 .8, .8]

% [counts,bins] = hist(depth*-1, 20); %# get counts and bin locations
rectangle('Position', [0, -588-3, 100, 6 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -708-4, 100, 8 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -890-5, 100, 10 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])

text(11, -571, 'L4', 'FontSize',24)
text(11, -690, 'L5A', 'FontSize',24)
text(11, -873, 'L5B', 'FontSize',24)
text(11, -925, 'L6', 'FontSize',24)




[counts,EDGES] = histcounts(-depth,EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts);

ylim([-975, -550]);
xlim([0 max(counts)+4])

[counts,EDGES] = histcounts(-depth(likelyTouch),EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts, 'g');


% saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])
%%
medAndFastMyabeTaskMod = [14 15 17 22 34 47 49 58 63 64 67 80];
length(medAndFastMyabeTaskMod)
binSize = 20;
EDGES = -1000:binSize:-500
cd('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\plots\S1DataForJon\depth counts')
svName = 'medAndFastMyabeTaskMod'
crush
dateString1 = datestr(now,'yymmdd_HHMM')
h = figure; hold on 
ylabel('Depth (microns)')
xlabel('number of cells')
sdf(gcf, 'default18')
h.Units = 'normalized'
h.Position = [1 0 .8, .8]

% [counts,bins] = hist(depth*-1, 20); %# get counts and bin locations
rectangle('Position', [0, -588-3, 100, 6 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -708-4, 100, 8 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -890-5, 100, 10 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])

text(11, -571, 'L4', 'FontSize',24)
text(11, -690, 'L5A', 'FontSize',24)
text(11, -873, 'L5B', 'FontSize',24)
text(11, -925, 'L6', 'FontSize',24)




[counts,EDGES] = histcounts(-depth,EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts);

ylim([-975, -550]);
xlim([0 max(counts)+4])

[counts,EDGES] = histcounts(-depth(medAndFastMyabeTaskMod),EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts, 'k');


% saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])
%%
lowSpikeRateCells = [3 5 7 24 25 28 29 30 36 39 40 41 44 46 51 55 59 60 78 65 73];
length(lowSpikeRateCells)
binSize = 20;
EDGES = -1000:binSize:-500
cd('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\plots\S1DataForJon\depth counts')
svName = 'lowSpikeRateCells'
crush
dateString1 = datestr(now,'yymmdd_HHMM')
h = figure; hold on 
ylabel('Depth (microns)')
xlabel('number of cells')
sdf(gcf, 'default18')
h.Units = 'normalized'
h.Position = [1 0 .8, .8]

% [counts,bins] = hist(depth*-1, 20); %# get counts and bin locations
rectangle('Position', [0, -588-3, 100, 6 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -708-4, 100, 8 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -890-5, 100, 10 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])

text(11, -571, 'L4', 'FontSize',24)
text(11, -690, 'L5A', 'FontSize',24)
text(11, -873, 'L5B', 'FontSize',24)
text(11, -925, 'L6', 'FontSize',24)




[counts,EDGES] = histcounts(-depth,EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts);

ylim([-975, -550]);
xlim([0 max(counts)+4])

[counts,EDGES] = histcounts(-depth(lowSpikeRateCells),EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts, 'y');


saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])
%%



interNeurons = find(E_I_NA==2) %10
length(interNeurons)
NotIdentified = find(E_I_NA==3)% 18 
length(NotIdentified)
Ecells = find(E_I_NA==1) %55
length(Ecells)
binSize = 20;
EDGES = -1000:binSize:-500
cd('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\plots\S1DataForJon\depth counts')
svName = 'interNeuronsYellow_NA_cyan'
crush
dateString1 = datestr(now,'yymmdd_HHMM')
h = figure; hold on 
ylabel('Depth (microns)')
xlabel('number of cells')
sdf(gcf, 'default18')
h.Units = 'normalized'
h.Position = [1 0 .8, .8]

% [counts,bins] = hist(depth*-1, 20); %# get counts and bin locations
rectangle('Position', [0, -588-3, 100, 6 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -708-4, 100, 8 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])
rectangle('Position', [0, -890-5, 100, 10 ], 'FaceColor', [1 0 1 .3], 'EdgeColor', [1 0 1 .3])

text(11, -571, 'L4', 'FontSize',24)
text(11, -690, 'L5A', 'FontSize',24)
text(11, -873, 'L5B', 'FontSize',24)
text(11, -925, 'L6', 'FontSize',24)




[counts,EDGES] = histcounts(-depth(Ecells),EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts);

ylim([-975, -550]);
xlim([0 max(counts)+4])

[counts,EDGES] = histcounts(-depth(interNeurons),EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts, .5, 'y');



[counts,EDGES] = histcounts(-depth(NotIdentified),EDGES)
bins = EDGES(1:end-1)+(.5*binSize)
barh(bins,counts, .2, 'r');
saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])





