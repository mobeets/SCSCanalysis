function Y = loadSpikeCounts(X, Chs)
% X = ReducedDataSet
% Chs = [1 2 0 0 1 ...] where 1 is L, 2 is R, and 0 is none

nchannels = numel(Chs);
Y = struct([]);
% Y = cell(nchannels,1);
% for ii = 1:nchannels
%     Y{ii} = struct([]);
% end
assert(isequal(unique([X.AttentionLocation]), [1 2]));
for ii = 1:numel(X)
    if mod(ii, 10) == 0
        disp(ii);
    end

    if X(ii).Outcome == 3
        [changeRow, ~] = size(X(ii).OrientationChange);
    else
        assert(any([1 4] == X(ii).Outcome));
        [changeRow, ~] = find(X(ii).OrientationChange>0);
    end
    
    for ch = 1:nchannels
        if Chs(ch) == 0 % ignore noise channels
            continue;
        end
        ns1 = spikeCountByChannelByWindow(X(ii), ch, 'vis');
        ns2 = spikeCountByChannelByWindow(X(ii), ch, 'visoff');
        ns3 = spikeCountByChannelByWindow(X(ii), ch, 'sacc');
        ns4 = spikeCountByChannelByWindow(X(ii), ch, 'base');
        
        if numel(ns1) ~= changeRow || numel(ns2) ~= changeRow
            warning('too many stimstarts given OrientationChange');
            continue;
        end
        
        for jj = 1:changeRow-1 % 2nd stim to one before change        
            y.trialIdx = ii;
            y.pulseIdx = jj;
            y.pulseRevIdx = -(changeRow - jj);
            y.isAttIn = X(ii).AttentionLocation == Chs(ch);
            y.isLeftCh = Chs(ch) == 1;
            
            y.yVis = ns1(jj);
            y.yVisOff = ns2(jj);
            y.ySacc = ns3;
            y.yBase = ns4;
            y.channel = ch;
            Y = [Y y];
%             Y{ch} = [Y{ch} y];
        end
    end
end

end
