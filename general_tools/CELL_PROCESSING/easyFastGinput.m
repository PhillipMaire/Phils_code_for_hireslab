    function [XclickCoords, YclickCoords, typeOutput] = easyFastGinputNESTED(figName, varargin)
        % spikeH = get(figName,'parent');
        %%% alt is right click
        %%%stayinside a loop until leftclick right click or enter is pressed
        if nargin >= 2
            numLoops = varargin{1};
        else
            numLoops = 1;
        end
        
        
        enterButtonClosesEverything = true
        
        for k = 1: numLoops
            while enterButtonClosesEverything
                iskey = waitforbuttonpress;
                switch iskey;
                    case 1 % (keyboard press)
                        key = get(gcf,'currentcharacter');
                        switch key
                            case 13%enter key pressed
                                if ~exist('XclickCoords')
                                    typeOutput = [];
                                    XclickCoords = [];
                                    YclickCoords = [];
                                end
                                enterButtonClosesEverything = false;
                                break
                        end
                    case 0 %is a click
                        typeOutput{k, 1} = figName.SelectionType;
                        %is a left of right click (not middle)
                        test1 = strcmp(typeOutput{k}, 'normal') || strcmp(typeOutput{k}, 'alt');
                        switch test1
                            case true
                                xy = get(gca,'CurrentPoint');
                                XclickCoords(k, 1) = xy(1,1);
                                YclickCoords(k, 1) = xy(1,2);
                                break
                        end
                end
            end
        end
        
        
    end
