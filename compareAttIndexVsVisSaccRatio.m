pulseIdx = -1;

for jj = 1:numel(ds)
    R = ds(jj).R;
    ix0 = ix{jj};
    
    [RY, RX] = assessSpikesPerPulse(R, ds(jj).LChs, ds(jj).RChs, ...
        false, false);
    A = nanmean(RY(:,2:5),2);
    B = nanmean(RY(:,6:end),2);
%     A = nanmean(RY(:,6:8),2);
%     B = nanmean(RY(:,9:end),2);
    ix1 = (B-A)./(B+A);
    
    R2 = addResponsesForFixedPulse(R, pulseIdx);
    
    figure;
    subplot(2,2,1);
    Rates = attentionIndices(R2, pulseIdx);
    atts = Rates.AttIndex;
    xlabel('attention index');
    ylabel('# units');
    view([-90 90]);
    yl = xlim;
    
    subplot(2,2,4);
    [n,c] = hist(ix0);
    h = bar(c, n);
    set(h, 'facecolor', 'black');
    xlabel('Vis/Sacc ratio');
    ylabel('# units');
    view([-180 90]);
    set(gca, 'XDir', 'reverse');
    xl = xlim;
    
    subplot(2,2,2);
    scatter(ix0, atts);
%     scatter(ix0, ix1);
%     scatter3(ix0, atts, ix1);
%     zlabel('spike slope');
    xlabel('Vis/Sacc ratio');
    ylabel('attention index');
    xlim(xl);
%     ylim(yl);
    [~,fn] = fileparts(ds(jj).filename);
    title(fn(1:8));
    
%     saveas(gcf, fullfile('..', 'SCPlots', 'AttVsVisSacc', ...
%         [fn(1:8) '.png']));
end
