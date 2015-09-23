x = load('../../Doug/SCSCproject/20150915/st150915task0001_reduceddata.mat');
y = x.ReducedDataSet;

Xs = unique(cell2mat({y(10:end).StimulusX}'), 'rows'); % [-300 -100]
Ys = unique(cell2mat({y(10:end).StimulusY}'), 'rows'); % [-200 300]
T1 = [Xs(1) Ys(1)];
T2 = [Xs(2) Ys(2)];

D = load('../../Doug/SCSCproject/20150915/st150915map0001_reduceddata.mat');
targPrefs = targPrefsForAllChannels(RChs);
[Ys, Ys0] = getVisSaccRespsFromMap(D, T1, T2, targPrefs);

%%

% now for a given cell need to choose which target is pref
% then take ratio of responses in those locations
