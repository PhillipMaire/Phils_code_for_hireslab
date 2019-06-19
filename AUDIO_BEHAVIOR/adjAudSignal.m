function [audOUT] = adjAudSignal(z, fs, m, pointsInFilter)
%% adjAudSignal(audIN, fs, filtDesign)
%% make the filter
f = linspace(0,1,length(m));
numCoef = 30;
[b,a] = yulewalk(numCoef,f(:),m(:));

%% display the filter vs input data 
figure
pointsInFilter = length(m);
[h,w] = freqz(b,a,1024)
plot(f,m,w/pi,abs(h))
xlabel 'Radian frequency (\omega/\pi)', ylabel Magnitude
legend('Ideal','Yule-Walker'), legend boxoff
%%




% [z,fs]=audioread('/Users/phillipmaire/Dropbox/HIRES_LAB/AUDIO_BEHAVIOR/testingAudioFilters/linearSweep.wav');
bfil=fft(z); %fft of input signal
fvtool(b,a);% disply the filter 
f=filter(b,a,z);
afil=fft(f);
subplot(2,1,1);plot(real(bfil));
title('frequency respones of input signal');
xlabel('frequency');ylabel('magnitude');
subplot(2,1,2);plot(real(afil));
title('frequency respones of filtered signal');
xlabel('frequency');ylabel('magnitude');

% %%
afilSIG = ifft(afil);

figure
plot(normalize(afilSIG, 'range'));hold on;plot(normalize(z, 'range'))
















