function [xs, Ys, Ys0] = showMapData(D, ystrs, cellind)
    if nargin < 2 || isempty(ystrs)
        ystrs = {'VisRespstimcounts', 'SaccRespstimcounts'};
    end
    
    fs = {'Orientation', 'SpatialFrequency', 'Contrast', ...
        'PhaseVelocity', 'StimRadius'};
    for ii = 1:numel(fs)
        fstr = fs{ii};
        assert(numel(unique(D.(fstr))) == 1);
    end
    
    xss = [D.StimX; D.StimY];
    xs = unique(xss', 'rows');
    Ys = cell(numel(ystrs),1);
    Ys0 = cell(numel(ystrs),1);
    figure; title(['cell #' num2str(cellind)]);
    for ii = 1:numel(ystrs)
        subplot(numel(ystrs),1,ii);
        ystr = ystrs{ii};
        ys = getMeanResp(D, xs, D.(ystr));
        y0 = nanmean(D.BaselineRespstimcounts,2);
        ys0 = ys - repmat(y0', size(ys,1), 1);
        plotMeanResp(xs, ys0, cellind);
        xlabel(ystr);
        Ys{ii} = ys;
        Ys0{ii} = ys0;
    end

end

function ys = getMeanResp(D, xs, Y)
    ys = nan(size(xs,1), size(Y,1));
    for ii = 1:size(xs,1)
        x = xs(ii,:);
        ix = D.StimX == x(1) & D.StimY == x(2);
        ys(ii,:) = nanmean(Y(:,ix),2);
    end
end

function plotMeanResp(xs, ys, ii)
    nx = numel(unique(xs(:,1)));
    ny = numel(unique(xs(:,2)));
%     imagesc(reshape(ys(:,ii), ny, nx));
    imagesc(xs(:,1), xs(:,2), reshape(ys(:,ii), ny, nx));
    colorbar;
    colormap gray;
end