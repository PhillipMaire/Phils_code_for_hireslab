        function [startScale, endScale] = scalePlot(trialstart, trialend, percentToCut) 
        trialstartSorted = sort(trialstart);%sort small to large
         trialendSorted = sort(trialend);
         if  length(trialstartSorted) == 1
             startScale = trialstart;
             endScale = trialend;
         else
         indexStartScale = round( percentToCut * numel(trialstartSorted));
         indexEndScale = round((1-percentToCut) * numel(trialendSorted));
         startScale = trialstartSorted(indexStartScale);
         endScale = trialendSorted(indexEndScale);
         end
        end