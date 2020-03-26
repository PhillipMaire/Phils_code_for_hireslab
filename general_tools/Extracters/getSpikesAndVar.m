function [sig1, spkSIG] = getSpikesAndVar(C, VAR1, extractINDS, makeTheseNANS)
if ~exist('makeTheseNANS')
   makeTheseNANS = [];
   display('''makeTheseNANS'' is empty no numbers will be replaced by NANs');
end

sig1 = squeeze(VAR1(extractINDS));
sig1(makeTheseNANS) = nan;

spkSIG = squeeze(C.R_ntk(extractINDS));
spkSIG(makeTheseNANS) = nan;
