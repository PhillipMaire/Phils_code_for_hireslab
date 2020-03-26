function [x, y, evalXaxis, evalYaxis] = logify(x, y, varargin)

if nargin==3
    base1 = varargin{1};
else
    base1 = 10; % default log 10
end

x = logWithNegs(x, base1);
y = logWithNegs(y, base1);



evalXaxis = ['xt = get(gca, ''XTick''); set (gca, ''XTickLabel'', ' num2str(base1) '.^xt)'];
evalYaxis = ['xt = get(gca, ''YTick''); set (gca, ''YTickLabel'', ' num2str(base1) '.^xt)'];


    function tmp1 = logWithNegs(x2, base2)
        zeroInd = x2==0;
        negInd = -2*(x2<0) + 1;
        tmp1 = abs(log(x2)./log(base2));
        tmp1 = tmp1.*negInd;
        tmp1(zeroInd) = 0;
        
    end
end
