
%% TRIAL INFO
% 
% 
% 

fn = 'data/ST150914task0002_reduceddata.mat';
x = load(fn);
X1 = x.ReducedDataSet;
% Xs = io.dropNonstimFields(X);
X = io.filterExp(X1, false);
[~, Chs] = io.newIndicesForGoodChannels();
Y = io.loadSpikeCounts(X, Chs);

%% CELL INFO

[tm,~,~, YL, YR] = io.loadResponses(X, false); % correct trials only

%% DAILY SUMMARIES
% 
% * pmfs
% * correlation between areas
% * cell summaries (e.g., variance, attention indices, etc.)
% 
