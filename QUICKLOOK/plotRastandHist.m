%% plot histogram and spikes
crush
figure;

for k = 1:length(U) 
%     k = 1
tmpU = U{k}

figure;

spikes = find(tmpU.R_ntk);
trials = ceil(spikes./4000);
spikeTimes = mod(spikes, 4000);

subplot(10, 1, 1:8)
plot(spikeTimes,trials, 'k.')
subplot(10, 1, 9:10)
plot(smooth(nanmean( tmpU.R_ntk, 3), 10), 'r-')
keyboard
close all hidden 
end

