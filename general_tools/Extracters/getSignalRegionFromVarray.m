function V3 = getSignalRegionFromVarray(V2, varargin)% V2 is a single array
% 2nd argument is extractRange or plotRange just so we can get the intersect to fin where the signal
% is in terms of the extract/plot range
V3.excitedResponse = nan;
V3.OGsigExtract = nan;
%% get the signal region
if V2.ModDirection ~= 0
    if V2.ModDirection >0
        V3.SIGinds = V2.plotRange(V2.E(1):V2.E(end));
        V3.excitedResponse = 1;
        V3.OGsigExtract = V2.E;
    elseif V2.ModDirection <0
        V3.SIGinds = V2.plotRange(V2.I(1):V2.I(end));
        V3.excitedResponse = 0;
        V3.OGsigExtract = V2.I;
    end
else
    V3.SIGinds = nan;
end
if nargin >=2
    if isnan(V3.SIGinds)
        V3.SIGindsExtractRange = nan;
    else
        extractRange = varargin{1};
        [~, V3.SIGindsExtractRange, ~] = intersect(extractRange, V3.SIGinds);
    end
end