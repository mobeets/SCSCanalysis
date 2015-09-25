x = load('../SCData/ST150914task0002_reduceddata.mat');
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

R = ds(end-1).R;
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

% 1. pick difficulty level
% 2. use correct trials only 
% 3. use trials on pulse_-1 only
% 4. pick cells (e.g., only motor cells)
% 5. L = mean(spikes(ChangeLocation == 1)), ...
%    R = mean(spikes(ChangeLocation == 2))

%% correlation between behavioral effect and attention axis
% see Fig. 2B, 2C
