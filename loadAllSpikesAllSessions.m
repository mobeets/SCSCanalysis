
datadir = '../../Doug/SCSCproject';
fns = dir(fullfile(datadir, '2015*'));
ds = struct([]);
for ii = 1:numel(fns)
    dt = fns(ii).name;
    curdir = fullfile(datadir, dt);
    fns2 = dir(fullfile(curdir, '*task*_reduceddata.mat'));
    
    for jj = 1:numel(fns2)
        fn = fullfile(curdir, fns2(jj).name);
        disp(fn);

        x = load(fn);
        y = x.ReducedDataSet;
        [R, LChs, RChs] = loadResponses(y,0);

        d.R = R; d.LChs = LChs; d.RChs = RChs;
        d.filename = fn;
        ds = [ds d];
    end
end

save('../SCData/allSpikes.mat', ds);
