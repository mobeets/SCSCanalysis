function fn = mapFileFromTaskFile(taskFile, enforceMoreThanTwoStims)

if nargin < 2
    enforceMoreThanTwoStims = false;
end

[dr,fn0] = fileparts(taskFile);
fns = dir(fullfile(dr, '*map*reduceddata.mat'));

if numel(fns) > 1
    ixs = [];
    if enforceMoreThanTwoStims
        for ii = 1:numel(fns)
            fn = fullfile(dr, fns(ii).name);
            D = load(fn);
            if numel(unique(D.StimX)) > 2
                ixs = [ixs ii];
            end
        end
        fns = fns(ixs);
        extrastr = ' with more than two stims';
    else
        extrastr = '';
    end
    [~,ix] = max([fns.datenum]);
    warning(['Multiple map files found for task file "' fn0 ...
        '". Picking newest' extrastr '.']);
    % ex: ../../Doug/SCSCproject/20150909/ST150909task0001_reduceddata.mat
else
    ix = 1;
end

disp(['Loaded map file "' fns(ix).name '"']);
fn = fullfile(dr, fns(ix).name);

end
