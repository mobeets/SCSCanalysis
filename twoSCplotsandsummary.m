function Summary = twoSCplotsandsummary(ReducedDataSet)
% this file was built from MTSCplotsandsummary.m
% 
% ReducedDataSet = load([ filename '_reduceddata.mat'], 'ReducedDataSet');
% Summary = twoSCplotsandsummary(ReducedDataSet);
% save([filename 'SummaryMTSCatt'],'Summary','SCclassify');
% 

[EACHchRESPidx, SCChsLeft, SCChsRight] = loadResponses(ReducedDataSet);

%classify sc channels
[SCclassify] = ClassifySCTypes(ReducedDataSet, ...
    [1:17 19:2:31 ([1:17 19:2:31]+32)]);

% get SC and MT correlations and rates
sorted = true; % because structure changed
Summary = noiseCorrelations(EACHchRESPidx, ReducedDataSet, ...
    sorted);
Summary.Rates = attentionIndices(EACHchRESPidx, Summary);
Summary = WithinAndAcrossrSC(EACHchRESPidx, Summary, ReducedDataSet, ...
    SCChsLeft, SCChsRight, SCclassify, sorted);

end
