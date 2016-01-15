function [mA, mB] = createAttentionAxis(X, Y, cellInds, pulseInd, ...
    oriChange)
% X (struct array) - ReducedDataSet
% Y (struct) - YL or YR from loadResponses, correct trials only
% cellInds - only use these cell indices (indexes Y.AttIn, e.g.)
% pulseInd - only use trials with this pulse index
% oriChange - only use trials with this orientation change
% 
% * pick difficulty level
% * use correct trials only 
% * use valid trials only
% * use trials on pulse_n only
% * pick cell type (e.g., only motor cells)
% * L = mean(spikes(ChangeLocation == 1)), ...
%    R = mean(spikes(ChangeLocation == 2))

if isempty(cellInds)
    cellInds = true(numel(Y.AttIn),1);
end

mA = findMeanSpikeCounts(X, Y.AttIn, cellInds, pulseInd, oriChange);
mB = findMeanSpikeCounts(X, Y.AttOut, cellInds, pulseInd, oriChange);

end

function m = findMeanSpikeCounts(X, Y, cellInds, pulseInd, oriChange)

% Yc = cell2mat({Y.Y}');
% Yc = Yc(cellInds,:);
% 
% ix = getTrialInds(X, Y, pulseInd, oriChange, changeLoc);
% spikeCounts = Yc(:,ix);

[~, ~, Y0] = getTrialInds(X, Y, cellInds, pulseInd, oriChange);
m = mean(Y0,2);

end
