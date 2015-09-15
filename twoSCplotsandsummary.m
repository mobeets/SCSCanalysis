function [Summary] = twoSCplotsandsummary(filename,sorted)
% this file was built from MTSCplotsandsummary.m

%now it will make some plots from the recordings with 2 V probes in each
%Colliculus.


if nargin == 1
    sorted = false;
end

%right now, in SCSCcorrelationAttPlotProbe, for att indices i'm defining:
% ch 1:24 as left probe (right RF) and att 2 is att in
% ch 25:48 as right probe (leftt RF) and att 1 is att in
%everywhere else im sticking with att 1 and att 2


%%
load([ filename '_reduceddata.mat']);

%classify sc channels
[SCclassify] = ClassifySCTypes(ReducedDataSet,[1:17 19:2:31 ([1:17 19:2:31]+32)]);

% get the counts for each condition
[EACHchRESP] = GetAvgRates(ReducedDataSet,0);


%% handle indexing here

%right now, i've hard coded which channels are mt and sc and ive indexed
%out the dead channels below...

%index it, both probes are SC
EACHchRESPidx = [EACHchRESP{[1:17 19:2:31 ([1:17 19:2:31]+32)]}];

sorted = true;  %because structure changed

%if i've indexed above, this is correct:
SCChsLeft=[1:24];
SCChsRight=[25:48];
  
% i may want to incorporate something about probe order here...
% vprobe, plugged in straight.
% a=[16 14 12 10 8 6 4 2 31 29 27 25 23 21 19 17 15 13 11 9 7 5 3 1];

%%
% get SC and MT correlations and rates
[Summary] = SCSCcorrelationAttPlotProbe(EACHchRESPidx,ReducedDataSet,sorted);

[Summary] = WithinAndAcrossrSC(EACHchRESPidx,Summary,ReducedDataSet,SCChsLeft,SCChsRight,SCclassify,sorted);


%% save output from each session

Summary.filename = filename;
save([filename 'SummaryMTSCatt'],'Summary','SCclassify')

end


function [Summary] = WithinAndAcrossrSC(EACHchRESP,Summary,ReducedDataSet,SCChsLeft,SCChsRight,SCclassify,sorted)

% ok, now the part I care about :  getting rSC values
% matrices were stored in Summary.Matrices from previous function

%have now added in first attempt to classify SC neurons as v,vm,m pull out
%all the within and between pairings that go with that...

corrSClA1 = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,SCChsLeft,SCChsLeft);
corrSClA2 = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,SCChsLeft,SCChsLeft);

corrSCrA1 = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,SCChsRight,SCChsRight);
corrSCrA2 = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,SCChsRight,SCChsRight);

corrBetweenSCSCA1 = GetMatrixEntries(Summary.Matrices.CorrMatrixA1,SCChsLeft,SCChsRight);
corrBetweenSCSCA2 = GetMatrixEntries(Summary.Matrices.CorrMatrixA2,SCChsLeft,SCChsRight);


SClCorr = [nanmean(corrSClA1) nanmean(corrSClA2)];
SClCorrSEM(1) = nanstd(corrSClA1) / sqrt(length(corrSClA1));
SClCorrSEM(2) = nanstd(corrSClA2) / sqrt(length(corrSClA2));

SCrCorr = [nanmean(corrSCrA1) nanmean(corrSCrA2)];
SCrCorrSEM(1) = nanstd(corrSCrA1) / sqrt(length(corrSCrA1));
SCrCorrSEM(2) = nanstd(corrSCrA2) / sqrt(length(corrSCrA2));

SCSCCorr = [nanmean(corrBetweenSCSCA1) nanmean(corrBetweenSCSCA2)];
SCSCCorrSEM(1) = nanstd(corrBetweenSCSCA1) / sqrt(length(corrBetweenSCSCA1));
SCSCCorrSEM(2) = nanstd(corrBetweenSCSCA2) / sqrt(length(corrBetweenSCSCA2));


figure;
      subplot(3,1,1)
      hold on;
      bar(SClCorr)
      errorbar([1:2],SClCorr,SClCorrSEM,SClCorrSEM,'.k')
      title('within left SC')
      set(gca,'XTickLabel',{'attend 1','attend 2'},'XTick',[1 2]);
      subplot(3,1,2)
      hold on;
      bar(SCrCorr)
      errorbar([1:2],SCrCorr,SCrCorrSEM,SCrCorrSEM,'.k')
      title('within right SC')
      set(gca,'XTickLabel',{'attend 1','attend 2'},'XTick',[1 2]);
      subplot(3,1,3)
      hold on;
      bar(SCSCCorr)
      errorbar([1:2],SCSCCorr,SCSCCorrSEM,SCSCCorrSEM,'.k')
      title('between the two SCs')
      set(gca,'XTickLabel',{'attend 1','attend 2'},'XTick',[1 2]);

% store values for later      
Summary.rSC.corrSClA1 = corrSClA1;
Summary.rSC.corrSClA2 = corrSClA2;
Summary.rSC.corrSCrA1 = corrSCrA1;
Summary.rSC.corrSCrA2 = corrSCrA2;
Summary.rSC.corrBetweenSCSCA1 = corrBetweenSCSCA1;
Summary.rSC.corrBetweenSCSCA2 = corrBetweenSCSCA2;


% store avgs and SEM for later replotting
Summary.rSC.SClAvgCorr = SClCorr;
Summary.rSC.SCLAvgCorrSEM = SClCorrSEM;
Summary.rSC.SCrAvgCorr = SCrCorr;
Summary.rSC.SCrAvgCorrSEM = SCrCorrSEM;
Summary.rSC.SCSCAvgCorr = SCSCCorr;
Summary.rSC.SCSCAvgCorrSEM = SCSCCorrSEM;



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


function [Summary, EACHchRESP] = SCSCcorrelationAttPlotProbe(EACHchRESP,ReducedDataSet,sorted)
% modified from the MTV1 code.  
%get rSC matrices, rates and attention indices
%when i find att indices, i currently assume att 1 is att in

PlotFlg = 1;  %do you want the rSC matrix plotted?

% handling indexing in main function now

if ~sorted  % if not sorted
% make correlation matrices
for i = 1:length(EACHchRESP)
        for j = 1:length(EACHchRESP)
                    [r,p]=mccorrcoef(EACHchRESP{i}.A1resp,EACHchRESP{j}.A1resp);
                    CorrMatrixA1(i,j) = r;
                    [r,p]=mccorrcoef(EACHchRESP{i}.A2resp,EACHchRESP{j}.A2resp);
                    CorrMatrixA2(i,j) = r;
        end
end

else   % if sorted and restructured.
for i = 1:length(EACHchRESP)
        for j = 1:length(EACHchRESP)
                    [r,p]=mccorrcoef(EACHchRESP(i).A1resp,EACHchRESP(j).A1resp);
                    CorrMatrixA1(i,j) = r;
                    [r,p]=mccorrcoef(EACHchRESP(i).A2resp,EACHchRESP(j).A2resp);
                    CorrMatrixA2(i,j) = r;               
        end
end

end

if PlotFlg
    figure;
    subplot(2,1,1)
    imagesc(CorrMatrixA1,[-1 1])
    title('A1')
    subplot(2,1,2)
    imagesc(CorrMatrixA2,[-1 1])
    title('A2')
    colorbar
end

% when we want to get avg corrs in different conditions.  within and across
% areas
% [MatrixEntries] = GetMatrixEntries(Matrix,RowIndex,ColumnIndex)

Summary.Matrices.CorrMatrixA1 = CorrMatrixA1;
Summary.Matrices.CorrMatrixA2 = CorrMatrixA2;


%% SC and MT rates for calculating attention indices

%here is where I assume att 1 is in...

%i could do a shorthand and just flip the sign for one side...

% if ~sorted
%     %get all avg rates for attend in Summary
%     for i = 1:length(EACHchRESP)
% 
%             AttIn = nanmean(EACHchRESP{i}.A1resp);
%             AttOut = nanmean(EACHchRESP{i}.A2resp);
%             Summary.Rates.AttIndex(i) = (AttIn - AttOut) / (AttIn + AttOut);
%             
%             Summary.Rates.countsA1{i} = EACHchRESP{i}.A1resp;
%             Summary.Rates.countsA2{i} = EACHchRESP{i}.A2resp;
%     
%             [p,h]=ranksum(Summary.Rates.countsA1{i},Summary.Rates.countsA2{i});
%             Summary.Rates.SigFlg(i) = h;
%             
%             Summary.Rates.avgA1(i) = nanmean(EACHchRESP{i}.A1resp);
%             Summary.Rates.avgA2(i) = nanmean(EACHchRESP{i}.A2resp);
%     end
% else
    %get all avg rates for attend in Summary
    for i = 1:length(EACHchRESP)

        if i <=24  %left probe, right RF.  att 2 is in
            AttOut = nanmean(EACHchRESP(i).A1resp);
            AttIn = nanmean(EACHchRESP(i).A2resp);        
        else  %right probe, leftt RF.  att 1 is in
            AttIn = nanmean(EACHchRESP(i).A1resp);
            AttOut = nanmean(EACHchRESP(i).A2resp);        
        end
        
            Summary.Rates.AttIndex(i) = (AttIn - AttOut) / (AttIn + AttOut); 
           
            Summary.Rates.countsA1{i} = EACHchRESP(i).A1resp;
            Summary.Rates.countsA2{i} = EACHchRESP(i).A2resp;

            [p,h]=ranksum(Summary.Rates.countsA1{i},Summary.Rates.countsA2{i});
            Summary.Rates.SigFlg(i) = h;
            
            Summary.Rates.avgA1(i) = nanmean(EACHchRESP(i).A1resp);
            Summary.Rates.avgA2(i) = nanmean(EACHchRESP(i).A2resp);
            

        
    end     
% end
  

%All SC att idx plot
figure; hold on;
set(gca,'Tick','out');
[h,hist_xvals,n]=mchist(Summary.Rates.AttIndex,-.975:.05:.975,1,0);
set(h,'facecolor','none')
[n1 hist_xvals1] =hist(Summary.Rates.AttIndex(find(Summary.Rates.SigFlg==1)),-.975:.05:.975,1,0);
i = bar(hist_xvals1,n1);
set(i,'facecolor','black')
text(nanmean(Summary.Rates.AttIndex),max(n)+5,'*')
%plot line at 0
x=0; y=linspace(0,max(n)+5);
plot(x,y,'k');
axis([-.35 .35 0 max(n)+10]);
xlabel('SC Attention Indices')
ylabel('Number of units')
title('SC All Spatial Atttention Indices')

    %thisname=['popV1AllAttIDXHist'];
    %exportfig(gcf,thisname,'Format','eps','Width',8,'Height',6,'FontSize',12,'Color','cmyk','FontMode', 'fixed','LineWidth',2)

[p,h]=signrank(Summary.Rates.AttIndex)


end