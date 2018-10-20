%%

gcf

title('pole-up modulation')

xlabel('modulation index (post-pole firing rate/pre-pole fireing rate)') % x-axis label
ylabel('depth (microns)') % y-axis label
grid on
%%

title('cumulative spike rate of S2 neurons')


xlabel('spikes/sec') % x-axis label
ylabel('cumulative percentage of cells') % y-axis label
legend('Post-pole onset','Pre-pole onset','Location','southeast')
%%

title('S2 neurons modulation by depth')


xlabel('spikes/sec') % x-axis label
ylabel('depth(microns)') % y-axis label
legend('negatively modulated cell','','','positively modulated cell','Location','southeast')

%%


set(gca,'FontSize',16)