figure;
nr = ceil(sqrt(numel(ds)));
nc = ceil(numel(ds)/nr);
for ii = 1:numel(ds)
    d = ds(ii);
    subplot(nr, nc, ii); hold on;
    assessSpikesPerPulse(d.R, d.LChs, d.RChs, false);
    plot(xlim, [0 0], 'k', 'LineWidth', 2);
    xlim([1, 10])
    [a,b,c] = fileparts(d.filename);
    title(b);
    f = gcf;
    saveas(f, ['../SCPlots/spikesPerPulse/' b '.png'], 'png');
%     assessSpikesPerPulse(d.R, d.LChs, d.RChs, false);
%     title(d.filename);
end
