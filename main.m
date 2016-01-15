x = load('data/ST150914task0002_reduceddata.mat');
y = x.ReducedDataSet;
[R, LChs, RChs] = io.loadResponses(y,0);

%% behavioral effect

%% attention index
% 1. pick difficulty level
% 2. use correct trials only
% 3. use trials on pulse_-1 only
% 4. L = mean(spikes(ChangeLocation == 1)), ...
%    R = mean(spikes(ChangeLocation == 2))
% 5. (L-R)/(L+R)

% [R, LChs, RChs] = loadResponses(y,0); % 0 means ignore misses

% R = ds(end-1).R;
% ns = -7:7;
ns = -1;
atts = nan(numel(ns),1);
Atts = cell(numel(ns), 1);
for ii = 1:numel(ns)
    R2 = addResponsesForFixedPulse(R, ns(ii));
    Rates = attentionIndices(R2, ns(ii));
    Atts{ii} = Rates.AttIndex;
    atts(ii) = mean(Rates.AttIndex);
end
figure; hold on;
plot(ns, atts); scatter(ns, atts);
xlabel('pulse index used to compute attention indices');
ylabel('mean attention index');

%% attention IN decreases noise correlations within a hemisphere,
%   and low correlations in general across hemispheres
% see Fig 3 of twoSCplotsandsummary

%% correlation between mean attention index and behavioral effect
% scatter

%% attention axis

% [~, LChs, RChs, YL, YR] = io.loadResponses(y,0);

pulseInd = 2; % 2:?
oriChange = 4; % [2 4 8 15 30]
[mLA, mLB] = createAttentionAxis(X, YL, [], pulseInd, oriChange);
[mRA, mRB] = createAttentionAxis(X, YR, [], pulseInd, oriChange);

figure;
subplot(2,1,1); hold on;
scatter(mLA, mLB);
ml1 = min([xlim; ylim]); ml2 = max([xlim; ylim]);
xlim([ml1(1) ml2(2)]); ylim(xlim);
plot(xlim, ylim, 'k--');
axis square;
xlabel('AttIn'); ylabel('AttOut'); title('L channel');

subplot(2,1,2); hold on;
scatter(mRA, mRB);
ml1 = min([xlim; ylim]); ml2 = max([xlim; ylim]);
xlim([ml1(1) ml2(2)]); ylim(xlim);
plot(xlim, ylim, 'k--');
axis square;
xlabel('AttIn'); ylabel('AttOut'); title('R channel');

%% correlation between behavioral effect and attention axis
% see Fig. 2B, 2C
%   http://www.marlenecohen.com/pubs/cohenmaunsell2010.pdf

% * consider only valid trials of single orientation change
% * project all trials (correct/incorrect) onto axis
% * scale so that -1 = mean correct L detection, 1 = mean correct R
%       detection
% * two histograms: for L(R) change, histogram of projections for 
%       correct vs. incorrect
% * proportion correct vs. binned projection, split by change
% 

% [~, LChs, RChs, YLa, YRa] = io.loadResponses(y,1);
[XLInProj, YLInProj] = projectAttentionAxis(X, YL.AttIn, mLA, mLB, ...
    pulseInd, oriChange);
[XLOutProj, YLOutProj] = projectAttentionAxis(X, YL.AttOut, mLA, mLB, ...
    pulseInd, oriChange);
[XRInProj, YRInProj] = projectAttentionAxis(X, YR.AttIn, mRA, mRB, ...
    pulseInd, oriChange);
[XROutProj, YROutProj] = projectAttentionAxis(X, YR.AttOut, mRA, mRB, ...
    pulseInd, oriChange);

% isCorrect = [X2.Outcome] == 1;

