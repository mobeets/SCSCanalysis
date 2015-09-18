function out = pmf(y)
%% psychometric function
%   * only valid trials
%   * only trials with change

% ix0 = [y.ChangeLocation] == 1;
ix = ~[y.IsInstruction] & [y.IsValid] & ~[y.IsCatchTrial];
y = y(ix);
% y0 = y(ix & ix0);

% 1 = hit, 4 = miss, 21/24 = hits/miss @ invalid, 9 = false alarm
% question: could i just filter on 1/4 and then ChangeLocation for pmf?

figure(1); hold on;
xlabel('Orientation change');
ylabel('% correct');

figure(2); hold on;
xlabel('Orientation change');
ylabel('# trials');

out = cell(2,3);
for jj = 1:2    
    y0 = y([y.ChangeLocation] == jj);
    xs = unique([y0.ThisOrientationChange]);
    ys = nan(size(xs));
    zs = nan(size(xs));
    for ii = 1:numel(xs)
        y1 = y0([y0.ThisOrientationChange] == xs(ii));
        hit = y1([y1.Outcome] == 1);
        mis = y1([y1.Outcome] == 4);
%         disp([xs(ii) numel(hit) numel(mis)])
        ys(ii) = numel(hit)/(numel(hit)+numel(mis));
        zs(ii) = numel(hit) + numel(mis);
    end
    figure(1); hold on;
    scatter(xs, ys);
    plot(xs, ys);
    figure(2); hold on;
    scatter(xs, zs);
    plot(xs, zs);
    
    out{jj,1} = xs;
    out{jj,2} = ys;
    out{jj,3} = zs;
end
end
