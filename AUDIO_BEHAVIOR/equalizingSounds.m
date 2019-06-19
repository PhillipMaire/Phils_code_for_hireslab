

cd('C:\Users\maire\Dropbox\HIRES_LAB\AUDIO_BEHAVIOR\testingAudioFilters');
[y,Fs] = audioread('linearSweep.wav');
s.x2 = y;
cd('C:\Users\maire\Dropbox\HIRES_LAB\AUDIO_BEHAVIOR\AudioCheckDotNet');
[y,fs] = audioread('audiocheck.net_hdsweep_1Hz_48000Hz_-3dBFS_30s.wav');
s.x1 = y;

%%
shiftCut = 336136
cutINDS = shiftCut:(30*fs+ shiftCut);
s.x3 = s.x2(cutINDS) ;
s.bl = s.x2(1:3*fs);
% runAll = 0; %only need to change when cahning baseline or OG sound file
%{
figure
 pspectrum(s.x3,fs)

%}
%%
% test = pspectrum(S.ogData, S.ogDataFS);
timeRes = 0.0256/4;
tic
if true
    
    % figure
    [P1,F1,T1] = pspectrum(s.x1,fs,'spectrogram', ...
        'TimeResolution',timeRes,'Overlap',86,'Leakage',0.875); %OG sound file
    
    % figure
    [P2,F2,T2] = pspectrum(s.x3,fs,'spectrogram', ...
        'TimeResolution',timeRes,'Overlap',86,'Leakage',0.875);% recorded sound (based on idex I used above)
    
    % figure
    [P3,F3,T3] = pspectrum(s.bl,fs,'spectrogram', ...
        'TimeResolution',timeRes,'Overlap',86,'Leakage',0.875);% baseline period based on idex above (to subtract out noise
    
else
    
    % figure
    [P2,F2,T2] = pspectrum(s.x3,fs,'spectrogram', ...
        'TimeResolution',timeRes,'Overlap',86,'Leakage',0.875);% recorded sound (based on idex I used above)
    
end
toc

%% og signal
crush
figure
p1b = pow2db(P1);
tmp = imagesc(p1b);
tmp.Parent.YDir = 'normal';
colorbar
% recorded signal
figure
p2b = pow2db(P2);
tmp = imagesc(p2b);
tmp.Parent.YDir = 'normal';
colorbar
% noise

figure
p3b = pow2db(P3);
tmp = imagesc(p3b);
tmp.Parent.YDir = 'normal';
colorbar
p3bmean = mean(p3b,2);

% recorded signal - noise
figure
% shft = log10(p3bmean -min(p3bmean));
shft = p3bmean/1;
p2c = p2b-shft;
tmp = imagesc(p2c);
tmp.Parent.YDir = 'normal';
colorbar



%%

G = gcd(size(p2c,1),size(p2c,2))
[h1, l1] = size(p2c);
cutBy = 1;



s1mat = (p1b(1:h1/cutBy, 1:l1/cutBy));
s2mat = (p2c(1:h1/cutBy, 1:l1/cutBy));
% s1mat = p1b;
% s2mat = p2c;


% s1mat = s1mat-min(s1mat)./max(s1mat-min(s1mat));
% s2mat = s2mat-min(s2mat)./max(s2mat-min(s2mat));
[SPout] = SPmaker(3, 1);
% pad1 = size(s2mat,2) - size(s1mat,2);
% s1matC = [s1mat, zeros(size(s1mat,1),pad1)];
[SPout] = SPmaker(SPout);tmp = imagesc(s1mat);tmp.Parent.YDir = 'normal';colorbar
[SPout] = SPmaker(SPout);tmp = imagesc(s2mat);tmp.Parent.YDir = 'normal';colorbar
alignedAndSubtracted = meanNorm(meanNorm(s2mat) - meanNorm(s1mat));
[SPout] = SPmaker(SPout);tmp = imagesc(alignedAndSubtracted);tmp.Parent.YDir = 'normal';colorbar

%%
[~, max1 ]= max(s1mat);
[~, max2 ]= max(s2mat);
s1 = (max1);
s2 = (max2);
figure;
plot(s1);hold on;plot(s2)
%%  set the for loop base don how far your signals are
crush
test10 = [];
% figure(100);hold on
% figure(101);hold on
s11 = [s1];
s22 = [s2, zeros(1, length(s2))];
% s11 = [s1];
% s22 = [s2];
length(s11)
for k = 1:100%length(s11)
    disp(k)
    tmp = (circshift(s22,k-1));
    tmp2 = tmp(1:length(s11))' - s11(:);
    test10(k, 1:length(tmp2))   = (tmp2);
end
toc
%% get teh lag shift value
tmp10 = sum(abs(test10),2);

figure;plot(tmp10)
[sdfkj, shiftVAL] = min(tmp10)
shiftVAL = shiftVAL-1;

if  shiftVAL == 0
    totShiftVal = 0
else
    totShiftVal =  T1(shiftVAL)*fs
end


%% cutting out the correct portion of the filter
tmp = (sort(s1mat)) ;
tmp2 = tmp(round(1*numel(tmp)));

s1INDS = s1mat>=tmp2;
figure;imagesc(s1INDS)
%%  only if you need smoothing
%  sensitivity1 = .58;
%  winChunckSize = [31, 31];
% 
% newFrame = adaptthresh(double(s1INDS),sensitivity1,'Statistic','mean','NeighborhoodSize',winChunckSize);
% figure;imagesc(newFrame)
% image(newFrame)
% %
% % tmp2 = newFrame(round(.999*length(newFrame)));
% s1INDS = newFrame>=1;
% 
% figure;imagesc(s1INDS)
%% fit the line 
spreadBy =9;
shiftSpreadBy = +7
%limit the percentage of the array to look through because of edge effects
A = round([.2 .8] * size(s1INDS,1));
B = round([.2 .8] * size(s1INDS,2));
[y,x] = find(s1INDS(A(1):A(2), B(1):B(2)));
plot(x, y, 'b*-', 'LineWidth', 2, 'MarkerSize', 15);
% Then get a fit
coeffs = polyfit(x, y, 1);
% Get fitted values
fittedX = linspace(1, size(s1INDS,2),size(s1INDS,2) );
fittedY_A = polyval([coeffs(1),coeffs(2)+spreadBy], fittedX)+shiftSpreadBy;
fittedY_B = polyval([coeffs(1),coeffs(2)-spreadBy], fittedX)+shiftSpreadBy;
% Plot the fitted line
hold on;
plot(fittedX, fittedY_A, 'r-', 'LineWidth', 3);
plot(fittedX, fittedY_B, 'r-', 'LineWidth', 3);

%%
filtLog = zeros(size(s1INDS));

fittedY_A2 = round(fittedY_A);
fittedY_B2 = round(fittedY_B);

allY = arrayfun(@colon, fittedY_B2, fittedY_A2, 'Uniform', false);
allY = vertcat(allY{:})';
allY(allY<1) = 1;
allY(allY>size(filtLog, 1)) = 1;

allX = repmat(fittedX, [size(allY,1), 1]);
allX(allX<1) = 1;
allX(allX>size(filtLog, 2)) = 1;


getFiltInds = sub2ind(size(filtLog),allY(:), allX(:));
filtLog(getFiltInds) = 1;
figure;imagesc(filtLog)
%%
crush
alignedAndSubtracted2 = (s2mat) - (s1mat);% get the non normalized version 
% alignedAndSubtracted2 = alignedAndSubtracted;
alignedAndSubtracted2(~filtLog) = nan;
figure;tmp = imagesc(alignedAndSubtracted2);tmp.Parent.YDir = 'normal';colorbar
%
test = nanmean(alignedAndSubtracted2,2);
figure;plot(test)
%%% then I use a brush tool to make the high pitch dips form subtracting out the motor sound into NAN values
%make sure to link your plot to you data in tools then link then use brush tool and right click and make into nans

test2 = test;
nanInds = find(isnan(test2))
test(nanInds) = nan;
finalFilterBias = smooth(test, 100);

%%%
crush
figure;plot(finalFilterBias)
finalFilterBias2 = finalFilterBias*-1
hold on; plot(finalFilterBias2)

%%


figure;tmp = imagesc(s2mat);tmp.Parent.YDir = 'normal';colorbar

filt3 = normalize(finalFilterBias2(:), 'range')

filt4 = (filt3*range(s2mat(:))) +min(s2mat(:));
figure;plot(filt4)

%%
s2matFilt = s2mat + filt4*.5;
% figure;plot(filt4)

% %%
figure;tmp = imagesc(s2matFilt);tmp.Parent.YDir = 'normal';colorbar;title('recreated sound signal with filter')
%%
filt5 =  ( .5+normalize(filt4, 'range')).^1;
figure;plot(filt5)
%%
s2matFilt = s2mat .*filt5;
% figure;plot(filt4)

% %%
figure;tmp = imagesc(s2matFilt);tmp.Parent.YDir = 'normal';colorbar;title('recreated sound signal with filter')
%%






