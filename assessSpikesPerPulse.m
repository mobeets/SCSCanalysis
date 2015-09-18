function assessSpikesPerPulse(R, LChs, RChs)
% slope in response
figure(1); hold on;
xlabel('pulses before change');
ylabel('avg (over trials): spikes on pulse relative to mean across pulses');

R0 = R;
zs = nan(numel(R0),1);
zs2 = nan(numel(R0),1);
for ii = 1:numel(R0)
    r = R0(ii);
    ma = nanmean(r.A1resp);
    mb = nanmean(r.A2resp);
    isL = sum(ii == LChs) > 0;
    if isL
        ry = r.A2resp;
        iy = r.A2_trialIdx;
        jy = r.A2_pulseIdx;
    else
        ry = r.A1resp;
        iy = r.A1_trialIdx;
        jy = r.A1_pulseIdx;
    end
    [xss, yss] = spikesPerPulse(ry, iy, jy);
    ys0 = nanmean(yss');
    zs(ii) = (ys0(end)-ys0(6))/ys0(6);
    zs2(ii) = (mean(r.A1resp) - mean(r.A2resp));
    if isL
        zs2(ii) = -zs2(ii)/mean(r.A2resp);
        clr = 'b';
    else
        zs2(ii) = zs2(ii)/mean(r.A1resp);
        clr = 'r';
    end
    
    xs0 = -abs(min(jy)):-1;
%     ys0 = (ys0 - ys0(end))/ys0(end);
% 	plot(xs0(6:end), ys0(6:end));
    figure(1); hold on;
    plot(xs0(6:end), ys0(6:end) - mean(ys0(6:end)), clr);
    figure(2); hold on;
    scatter(zs(ii), zs2(ii), 20, clr);
end

end

function [xss, yss] = spikesPerPulse(ry, iy, jy)

ry = ry';
ts = unique(iy);
xss = nan(abs(min(jy)),numel(ts));
yss = nan(abs(min(jy)),numel(ts));
for jj = 1:numel(ts)
   ry0 = ry(iy == ts(jj));
   jy0 = jy(iy == ts(jj));
   [~, ix] = sort(jy0);
   xs = jy0(ix);
   ys = ry0(ix);
   xss(end-numel(xs)+1:end,jj) = xs';
   yss(end-numel(ys)+1:end,jj) = ys';% - mean(ys))';
end

end
