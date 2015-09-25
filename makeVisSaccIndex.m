function inds = makeVisSaccIndex(y, RChs, D, option)
% x = load('../../Doug/SCSCproject/20150915/st150915task0001_reduceddata.mat');
% y = x.ReducedDataSet;
% [R, LChs, RChs] = loadResponses(y,0);
% D = load('../../Doug/SCSCproject/20150915/st150915map0001_reduceddata.mat');

if nargin < 4
    option = 0; % compare vis/sacc
    % options 1 and 2 are for vis- or motor-only
end

% drop first 10 trials for finding the stimulus used
Xs = unique(cell2mat({y(10:end).StimulusX}'), 'rows'); % [-300 -100]
Ys = unique(cell2mat({y(10:end).StimulusY}'), 'rows'); % [-200 300]
T1 = [Xs(1) Ys(1)];
T2 = [Xs(2) Ys(2)];
FixX = unique([y(10:end).FixX]);
FixY = unique([y(10:end).FixY]);
Fix = [FixX FixY];
T1 = -(T1-Fix);
T2 = -(T2-Fix);
targPrefs = targPrefsForAllChannels(RChs);
[Ys, Ys0, Ysb] = getVisSaccRespsFromMap(D, T1, T2, targPrefs);

f = @(a,b) (a-b)./(a+b);
if option == 1
    inds = f(Ys{1}, Ysb);
elseif option == 2
    inds = f(Ys{2}, Ysb);
else
    inds = f(Ys{1}, Ys{2});
end

tt = false(1,64);
tt(newIndicesForGoodChannels()) = true;
inds = inds(tt); % 1 = more vis, -1 = more sacc

end
