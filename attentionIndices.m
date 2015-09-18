function Rates = attentionIndices(EACHchRESP, A1str, A2str)
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
    
if nargin < 3
    A1str = 'A1resp';
end
if nargin < 4
    A2str = 'A2resp';
end
    
for i = 1:length(EACHchRESP)

    if i <=24  %left probe, right RF.  att 2 is in
        AttOut = nanmean(EACHchRESP(i).(A1str));
        AttIn = nanmean(EACHchRESP(i).(A2str));        
    else  %right probe, leftt RF.  att 1 is in
        AttIn = nanmean(EACHchRESP(i).(A1str));
        AttOut = nanmean(EACHchRESP(i).(A2str));        
    end

    Rates.AttIndex(i) = (AttIn - AttOut) / (AttIn + AttOut); 

    Rates.countsA1{i} = EACHchRESP(i).(A1str);
    Rates.countsA2{i} = EACHchRESP(i).(A2str);

    [p,h]=ranksum(Rates.countsA1{i},Rates.countsA2{i});
    Rates.SigFlg(i) = h;

    Rates.avgA1(i) = nanmean(EACHchRESP(i).(A1str));
    Rates.avgA2(i) = nanmean(EACHchRESP(i).(A2str));

end     
% end

%All SC att idx plot
figure; hold on;
set(gca,'TickDir','out');
[h,hist_xvals,n]=mchist(Rates.AttIndex,-.975:.05:.975,0);
% [h,hist_xvals,n]=mchist(Summary.Rates.AttIndex,-.975:.05:.975,1,0);
set(h,'facecolor','none')
[n1 hist_xvals1] =hist(Rates.AttIndex(find(Rates.SigFlg==1)),-.975:.05:.975,1,0);
i = bar(hist_xvals1,n1);
set(i,'facecolor','black')
text(nanmean(Rates.AttIndex),max(n)+5,'*')
%plot line at 0
x=0; y=linspace(0,max(n)+5);
plot(x,y,'k');
axis([-.35 .35 0 max(n)+10]);
xlabel('SC Attention Indices')
ylabel('Number of units')
title('SC All Spatial Atttention Indices')

%thisname=['popV1AllAttIDXHist'];
%exportfig(gcf,thisname,'Format','eps','Width',8,'Height',6,'FontSize',12,'Color','cmyk','FontMode', 'fixed','LineWidth',2)

[p,h]=signrank(Rates.AttIndex)

end
