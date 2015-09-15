function [EACHchRESP] = GetAvgRates(ReducedDataSet,IncludeMiss)
% 08/02/15 from GetAttInResponses in V1MT study to get avg rates for each
% channel in MT SC study.  only one stimulus condition here...

if nargin == 1
IncludeMiss = false;
end
%what about including miss trials to unattended ??

numchannels = length(ReducedDataSet(1).channels(:,1));

for q = 1:numchannels
    %I will put spikes in these
    A1resp=[];
    A2resp=[];
    BASELINE = [];
    
        for i=1:length(ReducedDataSet)  %go through all trials

            if ReducedDataSet(i).IsInstruction == 0  %if it wasn't an instruction trial
                
                if ~IncludeMiss
                    CondsToInclude = [1 3];
                elseif IncludeMiss
                    CondsToInclude = [1 3 4];
                end
                
                if ismember(ReducedDataSet(i).Outcome,CondsToInclude)  %new way, with flags

                    %use up to change, wherever change was

                    if ReducedDataSet(i).Outcome  == 1 ||  ReducedDataSet(i).Outcome  == 4    %if correct or miss
                        %find where/when the change happened
                        [ChangeRow,ChangeCol]=find(ReducedDataSet(i).OrientationChange>0);
                    elseif ReducedDataSet(i).Outcome  == 3   %need something for catch trials here...
                        [ChangeRow,ChangeCol]=size(ReducedDataSet(i).OrientationChange);
                        %a little kludgy, but works.  use up to last
                        %stim on catch trials
                    else
                        disp('WTF')
                    end

                    %use all flashes from 2 until the change
                    for j = 2:ChangeRow-1  %2nd stim to one before change

                        if ReducedDataSet(i).AttentionLocation == 1
                            A1resp=[A1resp ReducedDataSet(i).SpikeCounts(q,j)];
                        elseif ReducedDataSet(i).AttentionLocation == 2
                            A2resp=[A2resp ReducedDataSet(i).SpikeCounts(q,j)];                      
                        end
                    end
                    
                BASELINE = [BASELINE ReducedDataSet(i).BaselineSpikeCounts(q) .* (1./ReducedDataSet(i).BaselineIntervals(q))];
                end

            end
               
        end
    
%put these into a useful struct
EACHchRESP{q}.A1resp = A1resp;
EACHchRESP{q}.A2resp = A2resp;
EACHchRESP{q}.BASELINE = BASELINE;

end










end


