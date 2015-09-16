function [Summary, EACHchRESP] = SCSCcorrelationAttPlotProbe(...
    EACHchRESP, ReducedDataSet, sorted)
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
set(gca,'TickDir','out');
[h,hist_xvals,n]=mchist(Summary.Rates.AttIndex,-.975:.05:.975,0);
% [h,hist_xvals,n]=mchist(Summary.Rates.AttIndex,-.975:.05:.975,1,0);
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