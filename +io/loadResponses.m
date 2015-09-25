function [EACHchRESPidx, LChs, RChs, YL, YR] = loadResponses(...
    ReducedDataSet, includeMiss)
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
EACHchRESP = io.GetAvgRates(ReducedDataSet, includeMiss);
EACHchRESPidx = [EACHchRESP{io.newIndicesForGoodChannels()}];

%if i've indexed above, this is correct:
LChs = 1:24;
RChs = 25:48;

% i may want to incorporate something about probe order here...
% vprobe, plugged in straight.
% a=[16 14 12 10 8 6 4 2 31 29 27 25 23 21 19 17 15 13 11 9 7 5 3 1];

R = EACHchRESPidx;
S.A1 = struct('Y', {R.A1resp}, 'tix', {R.A1_trialIdx}, ...
    'pix', {R.A1_pulseIdx}, 'rpix', {R.A1_revPulseIdx});
S.A2 = struct('Y', {R.A2resp}, 'tix', {R.A2_trialIdx}, ...
    'pix', {R.A2_pulseIdx}, 'rpix', {R.A2_revPulseIdx});
YL.AttIn = S.A1(LChs); YL.AttOut = S.A2(LChs);
YR.AttOut = S.A1(RChs); YR.AttIn = S.A2(RChs);
YL.Baseline = cell2mat({R(LChs).BASELINE}');
YR.Baseline = cell2mat({R(RChs).BASELINE}');

% Y = struct([]);
% for ii = 1:numel(R)
%     clear y;
%     y.isLCh = any(ii == LChs);
%     if y.isLCh
%         y.Y_AttIn = R(ii).A1resp;
%         y.Y_AttOut = R(ii).A2resp;
%     else
%         y.Y_AttIn = R(ii).A2resp;
%         y.Y_AttOut = R(ii).A1resp;
%     end
%     y.Y_Baseline = R(ii).BASELINE;
%     y.Y_AttIn_
%     Y = [Y y];
% end

end
