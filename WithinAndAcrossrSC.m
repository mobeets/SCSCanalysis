function Summary = WithinAndAcrossrSC(EACHchRESP, Summary, ...
    ReducedDataSet, SCChsLeft, SCChsRight, SCclassify, sorted)

% ok, now the part I care about :  getting rSC values
% matrices were stored in Summary.Matrices from previous function

%have now added in first attempt to classify SC neurons as v,vm,m pull out
%all the within and between pairings that go with that...

[CrLLA1, CrLLA2, CrLL, CrLLSEM] = getCorrAndSEM(Summary, ...
    SCChsLeft, SCChsLeft);
[CrRRA1, CrRRA2, CrRR, CrRRSEM] = getCorrAndSEM(Summary, ...
    SCChsRight, SCChsRight);
[CrLRA1, CrLRA2, CrLR, CrLRSEM] = getCorrAndSEM(Summary, ...
    SCChsLeft, SCChsRight);

figure;

subplot(3,1,1);
hold on;
bar(CrLL);
errorbar([1:2],CrLL,CrLLSEM,CrLLSEM,'.k');
title('within left SC');
set(gca,'XTickLabel',{'attend 1','attend 2'},'XTick',[1 2]);

subplot(3,1,2);
hold on;
bar(CrRR);
errorbar([1:2],CrRR,CrRRSEM,CrRRSEM,'.k');
title('within right SC');
set(gca,'XTickLabel',{'attend 1','attend 2'},'XTick',[1 2]);

subplot(3,1,3);
hold on;
bar(CrLR);
errorbar([1:2],CrLR,CrLRSEM,CrLRSEM,'.k');
title('between the two SCs');
set(gca,'XTickLabel',{'attend 1','attend 2'},'XTick',[1 2]);

% store values for later      
Summary.rSC.corrSClA1 = CrLLA1;
Summary.rSC.corrSClA2 = CrLLA2;
Summary.rSC.corrSCrA1 = CrRRA1;
Summary.rSC.corrSCrA2 = CrRRA2;
Summary.rSC.corrBetweenSCSCA1 = CrLRA1;
Summary.rSC.corrBetweenSCSCA2 = CrLRA2;

% store avgs and SEM for later replotting
Summary.rSC.SClAvgCorr = CrLL;
Summary.rSC.SCLAvgCorrSEM = CrLLSEM;
Summary.rSC.SCrAvgCorr = CrRR;
Summary.rSC.SCrAvgCorrSEM = CrRRSEM;
Summary.rSC.SCSCAvgCorr = CrLR;
Summary.rSC.SCSCAvgCorrSEM = CrLRSEM;

%% everything below in this function has not been modified/fixed yet

% 
% %% make a list of the SC cell's PI value and all of its MT rSCs for pop level analysis
% % only include SC units that were 'active'
% 
% 
% for i = 1:length(SCChs)
%     
%     ThiscorrBetweenMTSCA1 = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,MTChs,SCChs(i));
%     ThiscorrBetweenMTSCA2 = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,MTChs,SCChs(i));
% 
%     %use the A1 index for stan because stim 1 is in the RF
%     ThisPI = SCclassify.A1vmPIindex(i);
%     
%     
%     % could want to pass all pair's rSC up to pop level, for now, just each
%     % SC cells avg with MT
%     
%     SCPIindxAndAvgMTrSCDiff(i,1) = ThisPI;
%     SCPIindxAndAvgMTrSCDiff(i,2) = nanmean(ThiscorrBetweenMTSCA1 - ThiscorrBetweenMTSCA2);
%    
% end
% 
% %% classification based stuff
% 
% %by default for stan i'm using the A1 classification (that was the att in
% %condition for him)
% corrSCA1withinVis = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,SCChs(logical(SCclassify.A1VisSigFlg)),SCChs(logical(SCclassify.A1VisSigFlg)));
% corrSCA2withinVis = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,SCChs(logical(SCclassify.A1VisSigFlg)),SCChs(logical(SCclassify.A1VisSigFlg)));
% 
% corrSCA1withinSac = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,SCChs(logical(SCclassify.A1SacSigFlg)),SCChs(logical(SCclassify.A1SacSigFlg)));
% corrSCA2withinSac = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,SCChs(logical(SCclassify.A1SacSigFlg)),SCChs(logical(SCclassify.A1SacSigFlg)));
% 
% corrSCA1withinVM = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,SCChs(logical(SCclassify.A1VMFlg)),SCChs(logical(SCclassify.A1VMFlg)));
% corrSCA2withinVM = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,SCChs(logical(SCclassify.A1VMFlg)),SCChs(logical(SCclassify.A1VMFlg)));
% 
% %
% SCCorrWithinVis = [nanmean(corrSCA1withinVis) nanmean(corrSCA2withinVis)];
% SCCorrWithinVisSEM(1) = sem(corrSCA1withinVis);
% SCCorrWithinVisSEM(2) = sem(corrSCA2withinVis);
% 
% SCCorrWithinSac = [nanmean(corrSCA1withinSac) nanmean(corrSCA2withinSac)];
% SCCorrWithinSacSEM(1) = sem(corrSCA1withinSac);
% SCCorrWithinSacSEM(2) = sem(corrSCA2withinSac);
% 
% SCCorrWithinVM = [nanmean(corrSCA1withinVM) nanmean(corrSCA2withinVM)];
% SCCorrWithinVMSEM(1) = sem(corrSCA1withinVM);
% SCCorrWithinVMSEM(2) = sem(corrSCA2withinVM);
% 
% 
% % store values for later      
% Summary.rSC.corrSCA1withinVis = corrSCA1withinVis;
% Summary.rSC.corrSCA2withinVis = corrSCA2withinVis;
% Summary.rSC.corrSCA1withinSac = corrSCA1withinSac;
% Summary.rSC.corrSCA2withinSac = corrSCA2withinSac;
% Summary.rSC.corrSCA1withinVM = corrSCA1withinVM;
% Summary.rSC.corrSCA2withinVM = corrSCA2withinVM;
% 
% 
% % store avgs and SEM for later replotting
% Summary.rSC.SCCorrWithinVis = SCCorrWithinVis;
% Summary.rSC.SCCorrWithinVisSEM = SCCorrWithinVisSEM;
% Summary.rSC.SCCorrWithinSac = SCCorrWithinSac;
% Summary.rSC.SCCorrWithinSacSEM = SCCorrWithinSacSEM;
% Summary.rSC.SCCorrWithinVM = SCCorrWithinVM;
% Summary.rSC.SCCorrWithinVMSEM = SCCorrWithinVMSEM;
% 
% 
% Summary.rSC.SCPIindxAndAvgMTrSCDiff = SCPIindxAndAvgMTrSCDiff;
% 
% 
% %may want to add in between group stuff within SC, but may need to make groups
% %exclusive then...
% 
% %between area stuff - all MT, sub groups of SC
% corrBetweenMTSCVisA1 = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,MTChs,SCChs(logical(SCclassify.A1VisSigFlg)));
% corrBetweenMTSCVisA2 = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,MTChs,SCChs(logical(SCclassify.A1VisSigFlg)));
% 
% corrBetweenMTSCSacA1 = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,MTChs,SCChs(logical(SCclassify.A1SacSigFlg)));
% corrBetweenMTSCSacA2 = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,MTChs,SCChs(logical(SCclassify.A1SacSigFlg)));
% 
% corrBetweenMTSCVMA1 = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,MTChs,SCChs(logical(SCclassify.A1VMFlg)));
% corrBetweenMTSCVMA2 = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,MTChs,SCChs(logical(SCclassify.A1VMFlg)));
% 
% %
% MTSCVisCorr = [nanmean(corrBetweenMTSCVisA1) nanmean(corrBetweenMTSCVisA2)];
% MTSCVisCorrSEM(1) = sem(corrBetweenMTSCVisA1);
% MTSCVisCorrSEM(2) = sem(corrBetweenMTSCVisA2);
% 
% MTSCSacCorr = [nanmean(corrBetweenMTSCSacA1) nanmean(corrBetweenMTSCSacA2)];
% MTSCSacCorrSEM(1) = sem(corrBetweenMTSCSacA1);
% MTSCSacCorrSEM(2) = sem(corrBetweenMTSCSacA2);
% 
% MTSCVMCorr = [nanmean(corrBetweenMTSCVMA1) nanmean(corrBetweenMTSCVMA2)];
% MTSCVMCorrSEM(1) = sem(corrBetweenMTSCVMA1);
% MTSCVMCorrSEM(2) = sem(corrBetweenMTSCVMA2);
% 
% 
% % store values for later      
% Summary.rSC.corrBetweenMTSCVisA1 = corrBetweenMTSCVisA1;
% Summary.rSC.corrBetweenMTSCVisA2 = corrBetweenMTSCVisA2;
% Summary.rSC.corrBetweenMTSCSacA1 = corrBetweenMTSCSacA1;
% Summary.rSC.corrBetweenMTSCSacA2 = corrBetweenMTSCSacA2;
% Summary.rSC.corrBetweenMTSCVMA1 = corrBetweenMTSCVMA1;
% Summary.rSC.corrBetweenMTSCVMA2 = corrBetweenMTSCVMA2;
% 
% 
% % store avgs and SEM for later replotting
% Summary.rSC.MTSCVisCorr = MTSCVisCorr;
% Summary.rSC.MTSCVisCorrSEM = MTSCVisCorrSEM;
% Summary.rSC.MTSCSacCorr = MTSCSacCorr;
% Summary.rSC.MTSCSacCorrSEM = MTSCSacCorrSEM;
% Summary.rSC.MTSCVMCorr = MTSCVMCorr;
% Summary.rSC.MTSCVMCorrSEM = MTSCVMCorrSEM;
% 

end

function [CrA1, CrA2, CrAvg, CrSEM] = getCorrAndSEM(Summary, ChsX, ChsY)
    CrA1 = GetMatrixEntries(Summary.Matrices.CorrMatrixA1, ...
        ChsX, ChsY);
    CrA2 = GetMatrixEntries(Summary.Matrices.CorrMatrixA2, ...
        ChsX, ChsY);
    CrAvg = [nanmean(CrA1) nanmean(CrA2)];
    CrSEM(1) = nanstd(CrA1) / sqrt(length(CrA1));
    CrSEM(2) = nanstd(CrA2) / sqrt(length(CrA2));
end
