figure;
nr = ceil(sqrt(numel(ds)));
nc = 2*ceil(numel(ds)/nr);
ix = cell(numel(ds),1);
for ii = 1:numel(ds)
    d = ds(ii);    
    disp(d.filename);
    [~,fn] = fileparts(d.filename);
    
    x = load(d.filename);
    mp = load(mapFileFromTaskFile(d.filename));
    inds = makeVisSaccIndex(x.ReducedDataSet, d.RChs, mp);
    
    subplot(nr, nc, 2*(ii-1)+1); hold on;
    hist(inds(d.LChs));
    xlabel([fn(1:6) '-L']);
    subplot(nr, nc, 2*(ii-1)+2); hold on;
    hist(inds(d.RChs));
    xlabel([fn(1:6) '-R']);
    ix{ii} = inds;
end
