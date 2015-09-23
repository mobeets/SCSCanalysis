function [EACHchRESPidx, LChs, RChs] = loadResponses(ReducedDataSet, ...
    includeMiss)
%
% right now, in SCSCcorrelationAttPlotProbe, for att indices i'm defining:
%  ch 1:24 as left probe (right RF) and att 2 is att in
%  ch 25:48 as right probe (leftt RF) and att 1 is att in
% everywhere else im sticking with att 1 and att 2

% handle indexing here
% right now, i've hard coded which channels are mt and sc and ive indexed
% out the dead channels below...
% index it, both probes are SC
% get the counts for each condition
EACHchRESP = GetAvgRates(ReducedDataSet, includeMiss);
EACHchRESPidx = [EACHchRESP{newIndicesForGoodChannels()}];

%if i've indexed above, this is correct:
LChs = 1:24;
RChs = 25:48;

% i may want to incorporate something about probe order here...
% vprobe, plugged in straight.
% a=[16 14 12 10 8 6 4 2 31 29 27 25 23 21 19 17 15 13 11 9 7 5 3 1];

end
