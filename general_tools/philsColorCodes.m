% %% PHILS COLOR CODES
% numColors = 10
% colorNameStr= 'green1'
function [setColor] = philsColorCodes (numColors, colorNameStr)
figure(11)
hold on
colorNameStr = lower(colorNameStr);
setColor  = nan(numColors, 3);

switch colorNameStr
    
    
    case 'green1'
        originalColor = [.1 .4 0];
        moreDark= 0;
        moreLight = 0;
        addColor = linspace(moreLight,1-max(originalColor)-moreDark, numColors);
        for iters = 1:numColors
            lineName =  plot(1:10, ones(1,10).*iters.*1);
            lineName.LineWidth = 10;
            setColor(iters, :) = originalColor +addColor(iters) ;
            lineName.Color = setColor(iters, :);
        end
        
        
    case 'blue1'
        %%
        mainColorInd = 3;
        originalColor = [.1 .1 .4];
        moreDark= -.2;
        moreLight = .15;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1:numColors
            lineName =  plot(1:10, ones(1,10).*iters.*1);
            lineName.LineWidth = 10;
            setColor(iters, :) = originalColor + addColor(iters) ;
            setColor(iters, setColor(iters, :)>1) = 1;
            setColor(iters, :)
            lineName.Color = setColor(iters, :);
        end
        %%
        
        
        
        % DARK RED TO BRIGHT RED
    case 'red1'
        %%
        mainColorInd = 1;
        
        originalColor = [.3 -2 -2];
        moreDark= -.0;
        moreLight = .15;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1:numColors
            lineName =  plot(1:10, ones(1,10).*iters.*1);
            lineName.LineWidth = 10;
            setColor(iters, :) = originalColor + addColor(iters) ;
            setColor(iters, setColor(iters, :)>1) = 1;
            setColor(iters, setColor(iters, :)<0) = 0;
            setColor(iters, :)
            lineName.Color = setColor(iters, :);
        end
        %%
        
        
        % BRIGHT RED TO LIGHT RED
    case 'red2'
        %%
        mainColorInd = 1;
        
        originalColor = [.3 0 0];
        moreDark= -.1;
        moreLight = -.1;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1:numColors
            lineName =  plot(1:10, ones(1,10).*iters.*1);
            lineName.LineWidth = 10;
            setColor(iters, :) = originalColor + addColor(iters) ;
            setColor(iters, setColor(iters, :)>1) = 1;
            setColor(iters, setColor(iters, :)<0) = 0;
            setColor(iters, mainColorInd) = 1;%THIS KEEPS THE MAIN COLOR CONSTANT NORMALL WILL KEEP THIS HIGH
            setColor(iters, :)
            lineName.Color = setColor(iters, :);
        end
        %%
        
        
        % BRIGHT RED TO LIGHT RED
    case 'red3'
        numColors = numColors./2;
        if round(numColors)~= numColors
            error('for this color input number must be even')
        end
        
        
        mainColorInd = 1;
        originalColor = [.35 -2 -2];
        moreDark= .2;
        moreLight = 0;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1:numColors
            lineName =  plot(1:10, ones(1,10).*iters.*1);
            lineName.LineWidth = 10;
            setColor(iters, :) = originalColor + addColor(iters) ;
            setColor(iters, setColor(iters, :)>1) = 1;
            setColor(iters, setColor(iters, :)<0) = 0;
            %             setColor(iters, mainColorInd) = 1;%THIS KEEPS THE MAIN COLOR CONSTANT NORMALL WILL KEEP THIS HIGH
            lineName.Color = setColor(iters, :);
        end
        
        
        originalColor = [.8 0 0];
        moreDark= -.6;
        moreLight = .1;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1 : numColors
            lineName =  plot(1:10, ones(1,10).*(iters.*1+numColors));
            lineName.LineWidth = 10;
            setColor(iters+numColors, :) = originalColor + addColor(iters) ;
            setColor(iters+numColors, setColor(iters+numColors, :)>1) = 1;
            setColor(iters+numColors, setColor(iters+numColors, :)<0) = 0;
%             setColor(iters+numColors, mainColorInd) = 1;%THIS KEEPS THE MAIN COLOR CONSTANT NORMALL WILL KEEP THIS HIGH
            lineName.Color = setColor(iters+numColors, :);
        end
        setColor
        %%
    case 'blue3'
        numColors = numColors./2;
        if round(numColors)~= numColors
            error('for this color input number must be even')
        end
        
        %DARKER PORTION
        mainColorInd = 3;
        originalColor = [-2 -2 .35];
        moreDark= .2;
        moreLight = 0;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1:numColors
            lineName =  plot(1:10, ones(1,10).*iters.*1);
            lineName.LineWidth = 10;
            setColor(iters, :) = originalColor + addColor(iters) ;
            setColor(iters, setColor(iters, :)>1) = 1;
            setColor(iters, setColor(iters, :)<0) = 0;
            %             setColor(iters, mainColorInd) = 1;%THIS KEEPS THE MAIN COLOR CONSTANT NORMALL WILL KEEP THIS HIGH
            lineName.Color = setColor(iters, :);
        end
        
        %LIGHTER PORTION
        originalColor = [0 0 .8];
        moreDark= -.6;
        moreLight = .1;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1 : numColors
            lineName =  plot(1:10, ones(1,10).*(iters.*1+numColors));
            lineName.LineWidth = 10;
            setColor(iters+numColors, :) = originalColor + addColor(iters) ;
            setColor(iters+numColors, setColor(iters+numColors, :)>1) = 1;
            setColor(iters+numColors, setColor(iters+numColors, :)<0) = 0;
%             setColor(iters+numColors, mainColorInd) = 1;%THIS KEEPS THE MAIN COLOR CONSTANT NORMALL WILL KEEP THIS HIGH
            lineName.Color = setColor(iters+numColors, :);
        end
        setColor
        
        
        %%
        
    case 'green3'
        numColors = numColors./2;
        if round(numColors)~= numColors
            error('for this color input number must be even')
        end
        
        %DARKER PORTION
        mainColorInd = 2;
        originalColor = [-2 .35 -2];
        moreDark= .2;
        moreLight = 0;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1:numColors
            lineName =  plot(1:10, ones(1,10).*iters.*1);
            lineName.LineWidth = 10;
            setColor(iters, :) = originalColor + addColor(iters) ;
            setColor(iters, setColor(iters, :)>1) = 1;
            setColor(iters, setColor(iters, :)<0) = 0;
            %             setColor(iters, mainColorInd) = 1;%THIS KEEPS THE MAIN COLOR CONSTANT NORMALL WILL KEEP THIS HIGH
            lineName.Color = setColor(iters, :);
        end
        
        %LIGHTER PORTION
        originalColor = [0 .8 0];
        moreDark= -.6;
        moreLight = .1;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1 : numColors
            lineName =  plot(1:10, ones(1,10).*(iters.*1+numColors));
            lineName.LineWidth = 10;
            setColor(iters+numColors, :) = originalColor + addColor(iters) ;
            setColor(iters+numColors, setColor(iters+numColors, :)>1) = 1;
            setColor(iters+numColors, setColor(iters+numColors, :)<0) = 0;
%             setColor(iters+numColors, mainColorInd) = 1;%THIS KEEPS THE MAIN COLOR CONSTANT NORMALL WILL KEEP THIS HIGH
            lineName.Color = setColor(iters+numColors, :);
        end
        setColor
        
        %%
    case 'black3'
        
        mainColorInd = 1;
        
        originalColor = [0 0 0];
        moreDark= .12;
        moreLight = 0;
        addColor = linspace(moreLight,1-originalColor(mainColorInd)-moreDark, numColors);
        for iters = 1:numColors
            lineName =  plot(1:10, ones(1,10).*iters.*1);
            lineName.LineWidth = 10;
            setColor(iters, :) = originalColor + addColor(iters) ;
            setColor(iters, setColor(iters, :)>1) = 1;
            setColor(iters, setColor(iters, :)<0) = 0;
%             setColor(iters, mainColorInd) = 1;%THIS KEEPS THE MAIN COLOR CONSTANT NORMALL WILL KEEP THIS HIGH
            lineName.Color = setColor(iters, :);
        end
        
        %%
        
end
end