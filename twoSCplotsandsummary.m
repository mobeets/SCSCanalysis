function Summary = twoSCplotsandsummary(ReducedDataSet)
% this file was built from MTSCplotsandsummary.m
% 
% ReducedDataSet = load([ filename '_reduceddata.mat'], 'ReducedDataSet');
% Summary = twoSCplotsandsummary(ReducedDataSet);
% save([filename 'SummaryMTSCatt'],'Summary','SCclassify');
% 

%now it will make some plots from the recordings with 2 V probes in each
%Colliculus.

%right now, in SCSCcorrelationAttPlotProbe, for att indices i'm defining:
% ch 1:24 as left probe (right RF) and att 2 is att in
% ch 25:48 as right probe (leftt RF) and att 1 is att in
%everywhere else im sticking with att 1 and att 2

%classify sc channels
[SCclassify] = ClassifySCTypes(ReducedDataSet, ...
    [1:17 19:2:31 ([1:17 19:2:31]+32)]);

% handle indexing here
% right now, i've hard coded which channels are mt and sc and ive indexed
% out the dead channels below...
% index it, both probes are SC
% get the counts for each condition
EACHchRESP = GetAvgRates(ReducedDataSet, 0);
EACHchRESPidx = [EACHchRESP{[1:17 19:2:31 ([1:17 19:2:31]+32)]}];

%if i've indexed above, this is correct:
SCChsLeft = 1:24;
SCChsRight = 25:48;
 
% i may want to incorporate something about probe order here...
% vprobe, plugged in straight.
% a=[16 14 12 10 8 6 4 2 31 29 27 25 23 21 19 17 15 13 11 9 7 5 3 1];

% get SC and MT correlations and rates
sorted = true;  %because structure changed
[Summary] = SCSCcorrelationAttPlotProbe(EACHchRESPidx, ReducedDataSet, ...
    sorted);
[Summary] = WithinAndAcrossrSC(EACHchRESPidx, Summary, ReducedDataSet, ...
    SCChsLeft, SCChsRight, SCclassify, sorted);

end
