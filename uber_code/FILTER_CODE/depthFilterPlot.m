%% depthFilterPlot
percentageVAR = 10;

%% first get the current data setup
for k = thesetrialTypes
    dataTMP = selectRespNormTT{k}; % not smoothed yet
    LdataTMP = length(dataTMP);
    if  contains(baslineType, 'minus')
        %% next boil down the cell to one number for when the 'baslineType' is 'minus'
        switch variableToBeNamed
            
            
            case 'topPercent'
               smoothSize=  round((percentageVAR ./ 100).*(LdataTMP));
                dataTMP2= smooth(dataTMP, smoothSize);
                dataTMP2(1:smoothSize) = nan;
                
        end
    elseif sontains(baslineType, 'divide')
        %% next boil down the cell to one number for when the 'baslineType' is 'divide'
        
    else
        error(' invalid vasline instructions')
    end
    
    
    U{cellStep}.details.depth
    
    
    
    
    
    %% need to incorporate a 'no filter' for the basline so it doest subtract
    %% the basline. so for divide by it should equal 1 and subtract should equal 0
    %% or can alternitively just make the string 'noFilter' for the basline trigger somthing so that
    %% it never subtracts or divides.
    
    
end
%% TESTING AREA
dataTMPsmooth = smooth(dataTMP, 30);
S = stepinfo(dataTMPsmooth)

%%

figure(2);plot(dataTMPsmooth)