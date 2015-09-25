function EACHchRESP = GetAvgRates(ReducedDataSet, IncludeMiss)
% 08/02/15 from GetAttInResponses in V1MT study to get avg rates for each
% channel in MT SC study.  only one stimulus condition here...

if nargin < 2
    IncludeMiss = false;
end
% what about including miss trials to unattended ??

numchannels = length(ReducedDataSet(1).channels(:,1));

for q = 1:numchannels
    % I will put spikes in these
    A1resp = [];
    A2resp = [];
    A1_trialIdx = []; % for each entry in A1resp
    A2_trialIdx = [];

    A1_revPulseIdx = []; % -1, -2, ... - relative to change pulse
    A2_revPulseIdx = [];
    
    A1_pulseIdx = []; % 1, 2, ... - relative to start of trial
    A2_pulseIdx = [];
    
    BASELINE = [];
    
    for i = 1:length(ReducedDataSet) % go through all trials
        % if it wasn't an instruction trial
        if ReducedDataSet(i).IsInstruction == 0
            if ~IncludeMiss
                CondsToInclude = [1 3];
            elseif IncludeMiss
                CondsToInclude = [1 3 4];
            end

            % new way, with flags
            if ismember(ReducedDataSet(i).Outcome,CondsToInclude)

                % use up to change, wherever change was
                % if correct or miss
                if ReducedDataSet(i).Outcome  == 1 ||  ...
                        ReducedDataSet(i).Outcome  == 4
                    % find where/when the change happened
                    [ChangeRow, ChangeCol] = find(...
                        ReducedDataSet(i).OrientationChange>0);
                % need something for catch trials here...
                elseif ReducedDataSet(i).Outcome  == 3
                    [ChangeRow, ChangeCol] = size(...
                        ReducedDataSet(i).OrientationChange);
                    % a little kludgy, but works.  use up to last
                    % stim on catch trials
                else
                    disp('WTF')
                end

                % use all flashes from 2 until the change
                for j = 2:ChangeRow-1 % 2nd stim to one before change

                    if ReducedDataSet(i).AttentionLocation == 1
                        A1resp = [A1resp ...
                            ReducedDataSet(i).SpikeCounts(q,j)];
                        A1_trialIdx = [A1_trialIdx; i];
                        A1_pulseIdx = [A1_pulseIdx; j];
                        A1_revPulseIdx = [A1_revPulseIdx; -(ChangeRow-j)];
                    elseif ReducedDataSet(i).AttentionLocation == 2
                        A2resp = [A2resp ...
                            ReducedDataSet(i).SpikeCounts(q,j)];
                        A2_trialIdx = [A2_trialIdx; i];
                        A2_pulseIdx = [A2_pulseIdx; j];
                        A2_revPulseIdx = [A2_revPulseIdx; -(ChangeRow-j)];
                    end
                end

                BASELINE = [BASELINE ...
                    ReducedDataSet(i).BaselineSpikeCounts(q) .* ...
                    (1./ReducedDataSet(i).BaselineIntervals(q))];
            end
        end
    end
    
% put these into a useful struct
EACHchRESP{q}.A1resp = A1resp;
EACHchRESP{q}.A2resp = A2resp;
EACHchRESP{q}.A1_trialIdx = A1_trialIdx;
EACHchRESP{q}.A2_trialIdx = A2_trialIdx;
EACHchRESP{q}.A1_pulseIdx = A1_pulseIdx;
EACHchRESP{q}.A2_pulseIdx = A2_pulseIdx;
EACHchRESP{q}.A1_revPulseIdx = A1_revPulseIdx;
EACHchRESP{q}.A2_revPulseIdx = A2_revPulseIdx;
EACHchRESP{q}.BASELINE = BASELINE;

end
end
