function fn = mapFileFromTaskFile(taskFile)

[dr,fn0] = fileparts(taskFile);
fns = dir(fullfile(dr, '*map*reduceddata.mat'));

[~,ix] = max([fns.datenum]);
if numel(fns) > 1
    warning(['Multiple map files found for task file "' fn0 ...
        '". Picking newest.']);
    % ex: ../../Doug/SCSCproject/20150909/ST150909task0001_reduceddata.mat
else
    ix = 1;
end

fn = fullfile(dr, fns(ix).name);

end
