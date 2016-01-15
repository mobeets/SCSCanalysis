function [ix, X0, Y0] = getTrialInds(X, Y, cellInds, pulseInd, oriChange)

if nargin < 3 || isempty(cellInds)
    cellInds = true(numel(Y),1);
end
if nargin < 3
    pulseInd = nan;
end
if nargin < 4
    oriChange = nan;
end

trialInds = [Y(1).tix];
X0 = X(trialInds);

ixTrue = true(numel(trialInds),1);
ixPulse = ixTrue;
ixOrient = ixTrue;

if ~isnan(pulseInd)
    pulseInds = [Y(1).pix];
    ixPulse = pulseInds == pulseInd; % trials with same pulse indices
end
if ~isnan(oriChange)
    ixOrient = cellfun(@(x) sum(sum(x)), ...  % trial with given difficulty
        {X0.OrientationChange}) == oriChange;
end
ixChange = [X0.IsValid]; % valid trials only

ix = ixPulse' & ixOrient & ixChange;
X0 = X0(ix);

Yc = cell2mat({Y.Y}');
Yc = Yc(cellInds,:);
Y0 = Yc(:,ix);

end
