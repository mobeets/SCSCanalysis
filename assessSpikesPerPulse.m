function assessSpikesPerPulse(R, LChs, RChs, doRevPulse)
if nargin < 4
    doRevPulse = true;
end

% slope in response
xlabel('pulse index');
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
        if doRevPulse
            jy = r.A2_revPulseIdx;
        else
            jy = r.A2_pulseIdx;
        end
    else
        ry = r.A1resp;
        iy = r.A1_trialIdx;
        if doRevPulse
            jy = r.A1_revPulseIdx;
        else
            jy = r.A1_pulseIdx;
        end
    end
    [xss, yss] = spikesPerPulse(ry, iy, jy);
    ys0 = nanmean(yss');
%     zs(ii) = (ys0(end)-ys0(6))/ys0(6);
%     zs2(ii) = (mean(r.A1resp) - mean(r.A2resp));
    if isL
        zs2(ii) = -zs2(ii)/mean(r.A2resp);
        clr = 'b';
    else
        zs2(ii) = zs2(ii)/mean(r.A1resp);
        clr = 'r';
    end
    
    xs0 = 1:max(abs(jy));
%     ys0 = (ys0 - ys0(end))/ys0(end);
% 	plot(xs0(6:end), ys0(6:end));
%     figure; hold on;
    
    if doRevPulse
        xs0 = min(jy):max(jy);
%         plot(xs0, ys0 - nanmean(ys0), clr);
        plot(xs0(6:end), ys0(6:end) - mean(ys0(6:end)), clr);
    else
        plot(xs0, ys0 - nanmean(ys0), clr);
    end
%     figure(2); hold on;
%     scatter(zs(ii), zs2(ii), 20, clr);
end

end

function [xss, yss] = spikesPerPulse(ry, iy, jy)

ry = ry';
ts = unique(iy);
xss = nan(max(abs(jy)),numel(ts));
yss = nan(max(abs(jy)),numel(ts));
doBackfill = any(jy < 0);
for jj = 1:numel(ts)
   ry0 = ry(iy == ts(jj));
   jy0 = jy(iy == ts(jj));
   [~, ix] = sort(jy0);
   xs = jy0(ix);
   ys = ry0(ix);
   if doBackfill % negative pulse inds are backfilled
       xss(end-numel(xs)+1:end,jj) = xs';
       yss(end-numel(ys)+1:end,jj) = ys';% - mean(ys))';
   else
       xss(1:numel(xs),jj) = xs';
       yss(1:numel(ys),jj) = ys';% - mean(ys))';
   end
end

end
