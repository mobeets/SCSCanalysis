function [Ys, Ys0] = getVisSaccRespsFromMap(D, T1, T2, targPrefs)
% D is the loaded map file
% targPrefs is a vector of 1/2 specifying preferred stimulus for each cell
% 

[xs, ys, ys0] = showMapData(D, {}, nan);

dfcn = @(x) (@(a) sqrt(sum((a-x).^2)));
T1d = cellfun(dfcn(T1), num2cell(xs,2));
T2d = cellfun(dfcn(T2), num2cell(xs,2));
[~,ix1] = min(T1d);
[~,ix2] = min(T2d);
% T1x = xs(ix1,:); % closest location to T1
% T2x = xs(ix2,:); % closest location to T2

Ys = cell(size(ys));
Ys0 = cell(size(ys0));
for ii = 1:numel(ys)
    Ys{ii} = nan(size(ys{ii},2),1);
    Ys0{ii} = nan(size(ys0{ii},2),1);
end
for ii = 1:numel(ys)
    y = ys{ii};
    y0 = ys0{ii};
    for jj = 1:size(y,2) % neurons
        if targPrefs(jj) == 1 % pref targ1
            Ys{ii}(jj) = y(ix1, jj);
            Ys0{ii}(jj) = y0(ix1, jj);
        else
            Ys{ii}(jj) = y(ix2, jj);
            Ys0{ii}(jj) = y0(ix2, jj);
        end
    end
end

end
