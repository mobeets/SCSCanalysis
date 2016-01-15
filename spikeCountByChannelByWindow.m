function n = spikeCountByChannelByWindow(X, ch, opt, winLength, startShift)
% counts the number of event-related spikes on channel "ch"
%   for a given trial X (i.e., ReducedDataSet(j) for some j)
%   where the event is one of ['vis', 'sacc', 'visoff', 'base']
% 

if ch > 32 && ch < 100
    ch = ch + 96;
end

if nargin < 4
    winLength = 0.1;
end
if nargin < 5
    switch opt
        case 'vis'
            startShift = 0.02;
        case 'sacc'
            startShift = 0.00;
        case 'visoff'
            startShift = 0.05;
    end
end

stimDur = X.StimulusDuration/120;
stimOn = X.stimstart;
stimOff = X.stimstart + stimDur;
sacTime = X.codes(X.codes==141,2);

switch opt
    case 'vis'
        if isempty(stimOn)
            n = nan;
            return;
        end
        n = nan(numel(stimOn),1);
        for ii = 1:numel(n)
            n(ii) = sum(X.spikes(:,1)==ch ...
                & X.spikes(:,3) >= stimOn(ii) + startShift ...
                & X.spikes(:,3) < stimOn(ii) + startShift + winLength);
        end
    
    case 'visoff'
        if isempty(stimOn)
            n = nan;
            return;
        end
        n = nan(numel(stimOn),1);
        for ii = 1:numel(n)
            if ii < n
                if stimOff(ii) + startShift + winLength > stimOn(ii+1)
                    warning('"visoff" contains next stimOn time');
                end
            end
            n(ii) = sum(X.spikes(:,1)==ch ...
                & X.spikes(:,3) >= stimOff(ii) + startShift ...
                & X.spikes(:,3) < stimOff(ii) + startShift + winLength);
        end
        
    case 'sacc' % spikes prior to saccade
        if isempty(sacTime)
            n = nan;
            return
        end
        n = sum(X.spikes(:,1)==ch & ...
            X.spikes(:,3) >= sacTime - startShift - winLength & ...
            X.spikes(:,3) < sacTime - startShift);
        
    case 'base' % spikes prior to first stim pulse
        if isempty(stimOn)
            n = nan;
            return;
        end
        n = sum(X.spikes(:,1)==ch & ...
            X.spikes(:,3) >= stimOn(1) - winLength & ...
            X.spikes(:,3) < stimOn(1));
        
end

end
