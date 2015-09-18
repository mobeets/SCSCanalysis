%% all pmfs

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
        out = pmf(y);

        clear d;
        d.dt = dt;
        d.fnm = fn;
        d.isLeft = true;
        d.xs = out{1,1};
        d.ys = out{1,2};
        d.zs = out{1,3};
        d.ntrials = sum(d.zs);
        ds = [ds d];
        
        clear d;
        d.dt = dt;
        d.fnm = fn;
        d.isLeft = false;
        d.xs = out{2,1};
        d.ys = out{2,2};
        d.zs = out{2,3};
        d.ntrials = sum(d.zs);
        ds = [ds d];
        
    end
end
