x = load('../../Doug/SCSCproject/20150915/st150915task0001_reduceddata.mat');
y = x.ReducedDataSet;

Xs = unique(cell2mat({y(10:end).StimulusX}'), 'rows'); % [-300 -100]
Ys = unique(cell2mat({y(10:end).StimulusY}'), 'rows'); % [-200 300]
T1 = [Xs(1) Ys(1)];
T2 = [Xs(2) Ys(2)];

D = load('../../Doug/SCSCproject/20150915/st150915map0001_reduceddata.mat');
[xs, ys, ys0] = showMapData(D, {}, 1);

%%

dfcn = @(x) (@(a) sqrt(sum((a-x).^2)));
T1d = cellfun(dfcn(T1), num2cell(xs,2));
T2d = cellfun(dfcn(T2), num2cell(xs,2));
[~,ix1] = min(T1d);
[~,ix2] = min(T2d);
T1x = xs(ix1,:); % closest location to T1
T2x = xs(ix2,:); % closest location to T2

disp([T1 T1x])
disp([T2 T2x])

%%

% now for a given cell need to choose which target is pref
% then take ratio of responses in those locations
