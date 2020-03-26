function hf2 = CloneFig(inFigNum,varargin)
% this program copies a figure to another figure
% example: CloneFig(1,4) would copy Fig. 1 to Fig. 4
% Matt Fetterman, 2009
% pretty much taken from Matlab Technical solutions:
% http://www.mathworks.com/support/solutions/en/data/1-1UTBOL/?solution=1-1UTBOL
% edited by phil. allow figure number or handdle input for each input also allows for only one input
% so that it will make a new figure if only one input
if isnumeric(inFigNum)
    hf1=figure(inFigNum);
else
    hf1 =   inFigNum;
end



if nargin>=2
    OutFigNum = varargin{1};
    if isnumeric(OutFigNum)
        hf2=figure(hf2);
    else
        hf2 = OutFigNum;
        figure(hf2);
    end
elseif nargin==1
    hf2 = figure;
    figure(hf2);
end




clf;
compCopy(hf1,hf2);

function compCopy(op, np)
%COMPCOPY copies a figure object represented by "op" and its % descendants to another figure "np" preserving the same hierarchy.

ch = get(op, 'children');
if ~isempty(ch)
    nh = copyobj(ch,np);
    for k = 1:length(ch)
        nh(k) = ch(k);
        %         compCopy(ch(k),nh(k))
    end
end;
return;