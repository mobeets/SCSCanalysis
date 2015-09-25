
fn = '../SCData/ST150914task0002_reduceddata.mat';
x = load(fn);
y = x.ReducedDataSet;
D = load(mapFileFromTaskFile(fn, true));

%%

Xs = unique(cell2mat({y(10:end).StimulusX}'), 'rows'); % [-300 -100]
Ys = unique(cell2mat({y(10:end).StimulusY}'), 'rows'); % [-200 300]
FixX = unique([y(10:end).FixX]);
FixY = unique([y(10:end).FixY]);
Fix = [FixX FixY];
T1 = [Xs(1) Ys(1)];
T2 = [Xs(2) Ys(2)];

%%

[R, LChs, RChs] = loadResponses(y,0);
