function [SCclassify] = ClassifySCTypes(ReducedDataSet,Chs)
% built from GetAvgRates.m for classifying SC cells as V/VM/M as well as
% generating some other possible metrics in this vein.

% use codes and spikes fields from the task data.

% first, let's take the response to the first stimulus and then also count
% spikes after the change stimulus but aligned to the saccade

% need to think through what to do about invalid trials...
% probably ignore them for now.

% should i use only instruction trials? because of only one stimulus?

IncludeMiss = false;

numchannels = length(Chs);

VisWinStartShift = 0.020;
SacWinStartShift = 0.0;  %align to window entry, right?
WinLength = 0.100;


for r = 1:numchannels
    q=Chs(r);
    
    %I will put spikes in these
    A1Visresp=[];
    A2Visresp=[];
        
    A1Sacresp=[];
    A2Sacresp=[];
    
    A1Baseline = [];
    A2Baseline = [];
    
        for i=1:length(ReducedDataSet)  %go through all trials

            if ReducedDataSet(i).IsInstruction == 1  %if it was an instruction trial
                
                %if ~IncludeMiss
                    CondsToInclude = [1];  %don't include catch trials - no saccade
                %elseif IncludeMiss
                %    CondsToInclude = [1 3 4];
                %end
                
                if ismember(ReducedDataSet(i).Outcome,CondsToInclude)  

                    %find timecode of first stimulus onset
                    StimOnTimes = [];
                    StimOnTimes = ReducedDataSet(i).codes(ReducedDataSet(i).codes==10,2);
                    FirstStimOn = StimOnTimes(1);
                    
                    %find time of saccade
                    SacTime = ReducedDataSet(i).codes(ReducedDataSet(i).codes==141,2);
                    
                    %get spike counts in window based on the above event
                    %times
                    
                    tmpVisCounts = [];
                    tmpSacCounts = [];
                    tmpBaselineCounts = [];
                    
                        if ReducedDataSet(i).AttentionLocation == 1
                            
                            tmpVisCounts = numel(find(ReducedDataSet(i).spikes(:,1)==q & ReducedDataSet(i).spikes(:,3)>= FirstStimOn + VisWinStartShift & ReducedDataSet(i).spikes(:,3)< FirstStimOn + VisWinStartShift + WinLength));
                            A1Visresp=[A1Visresp tmpVisCounts];
                            
                            tmpSacCounts = numel(find(ReducedDataSet(i).spikes(:,1)==q & ReducedDataSet(i).spikes(:,3)>= SacTime - SacWinStartShift - WinLength & ReducedDataSet(i).spikes(:,3)< SacTime - SacWinStartShift));
                            A1Sacresp=[A1Sacresp tmpSacCounts];
                            
                            tmpBaselineCounts = numel(find(ReducedDataSet(i).spikes(:,1)==q & ReducedDataSet(i).spikes(:,3)>= FirstStimOn - WinLength & ReducedDataSet(i).spikes(:,3)< FirstStimOn));                            
                            A1Baseline = [A1Baseline tmpBaselineCounts];
                       
                        elseif ReducedDataSet(i).AttentionLocation == 2
                            
                            tmpVisCounts = numel(find(ReducedDataSet(i).spikes(:,1)==q & ReducedDataSet(i).spikes(:,3)>= FirstStimOn + VisWinStartShift & ReducedDataSet(i).spikes(:,3)< FirstStimOn + VisWinStartShift + WinLength));
                            A2Visresp=[A2Visresp tmpVisCounts];
                            
                            tmpSacCounts = numel(find(ReducedDataSet(i).spikes(:,1)==q & ReducedDataSet(i).spikes(:,3)>= SacTime - SacWinStartShift - WinLength & ReducedDataSet(i).spikes(:,3)< SacTime - SacWinStartShift));
                            A2Sacresp=[A2Sacresp tmpSacCounts];
                            
                            tmpBaselineCounts = numel(find(ReducedDataSet(i).spikes(:,1)==q & ReducedDataSet(i).spikes(:,3)>= FirstStimOn - WinLength & ReducedDataSet(i).spikes(:,3)< FirstStimOn));                            
                            A2Baseline = [A2Baseline tmpBaselineCounts];
                        end
                    
                        
                end

            end
            
        end
    
%put these into a useful struct
SCclassify.resp{q}.A1Visresp = A1Visresp;
SCclassify.resp{q}.A1Sacresp = A1Sacresp;
SCclassify.resp{q}.A1Baseline = A1Baseline;
SCclassify.resp{q}.A2Visresp = A2Visresp;
SCclassify.resp{q}.A2Sacresp = A2Sacresp;
SCclassify.resp{q}.A2Baseline = A2Baseline;

end


%now do some crunching
for j = 1:numchannels
    i=Chs(j);
    
    %stats tests for determining v and m.  
    [hv,p]=ttest(SCclassify.resp{i}.A1Visresp,SCclassify.resp{i}.A1Baseline);
    A1VisSigFlg(j) = hv;
    [hs,p]=ttest(SCclassify.resp{i}.A1Sacresp,SCclassify.resp{i}.A1Baseline);
    A1SacSigFlg(j) = hs;
    
    %no additional stat here, just looking to see if both are individually
    %sig
    if hs == 1 && hv == 1
    A1VMFlg(j) = 1;
    else
    A1VMFlg(j) = 0;    
    end
    
    %same for att 2
    [hv,p]=ttest(SCclassify.resp{i}.A2Visresp,SCclassify.resp{i}.A2Baseline);
    A2VisSigFlg(j) = hv;
    [hs,p]=ttest(SCclassify.resp{i}.A2Sacresp,SCclassify.resp{i}.A2Baseline);
    A2SacSigFlg(j) = hs;
    
    if hs == 1 && hv == 1
    A2VMFlg(j) = 1;
    else
    A2VMFlg(j) = 0;    
    end
  
    %physiologists index of Vis and Sac response    
    A1vmPIindex(j) = (nanmean(SCclassify.resp{i}.A1Visresp) - nanmean(SCclassify.resp{i}.A1Sacresp)) / (nanmean(SCclassify.resp{i}.A1Visresp) + nanmean(SCclassify.resp{i}.A1Sacresp));
    A2vmPIindex(j) = (nanmean(SCclassify.resp{i}.A2Visresp) - nanmean(SCclassify.resp{i}.A2Sacresp)) / (nanmean(SCclassify.resp{i}.A2Visresp) + nanmean(SCclassify.resp{i}.A2Sacresp));
    
end

SCclassify.A1VisSigFlg = A1VisSigFlg;
SCclassify.A1SacSigFlg = A1SacSigFlg;
SCclassify.A1VMFlg = A1VMFlg;

SCclassify.A2VisSigFlg = A2VisSigFlg;
SCclassify.A2SacSigFlg = A2SacSigFlg;
SCclassify.A2VMFlg = A2VMFlg;

SCclassify.A1vmPIindex = A1vmPIindex;
SCclassify.A2vmPIindex = A2vmPIindex;


end


