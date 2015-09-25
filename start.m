
%% TRIAL INFO
% 
% 
% 

fn = '../SCData/ST150914task0002_reduceddata.mat';
x = load(fn);
X = x.ReducedDataSet;
Xs = io.dropNonstimFields(X);

%% CELL INFO

[~,~,~, YL, YR] = io.loadResponses(X, false); % correct trials only

%% DAILY SUMMARIES
% 
% * pmfs
% * correlation between areas
% * cell summaries (e.g., variance, attention indices, etc.)
% 
