nchannels = 64;

np = max([Y.pulseIdx]);
% np = min([Y.pulseRevIdx]);
zs1 = nan(nchannels, np);
zs2 = nan(nchannels, np);
zs3 = nan(nchannels, np);
zs4 = nan(nchannels, np);

for ii = 1:nchannels
    Y1 = Y([Y.channel] == ii);
%     for jj = np:-1
%         Ya = Y1([Y1.pulseRevIdx]==jj);
    for jj = 1:np
        Ya = Y1([Y1.pulseIdx]==jj);        
        zs1(ii,abs(jj)) = nanmean([Ya.yVis]);
        zs2(ii,abs(jj)) = nanmean([Ya.yVisOff]);
        zs3(ii,abs(jj)) = nanmean([Ya.ySacc]);
        zs4(ii,abs(jj)) = nanmean([Ya.yBase]);
    end
end

%%

np = max([Y.pulseIdx]);
sc = cell(nchannels, np);
for ii = 1:nchannels
    for jj = 1:np
        sc{ii,jj} = [];
    end
end

for ii = 1:nchannels
    Y1 = Y([Y.channel] == ii);
    nt = unique([Y1.trialIdx]);
    for jj = 1:numel(nt)
       Ya = Y1([Y1.trialIdx] == nt(jj));
       nps = max([Ya.pulseIdx]);
       sc{ii,nps} = [sc{ii,nps} Ya(1).ySacc];
    end
end

ms = nan(nchannels, np);
vs = nan(nchannels, np);
for ii = 1:nchannels
    for jj = 1:np
        ms(ii,jj) = nanmean(sc{ii,jj});
        vs(ii,jj) = numel(sc{ii,jj});
    end
end

%%

figure; hold on;
xlabel('pulse index');
% ylabel('avg spike count: vis');
% ylabel('avg spike count: visoff');
ylabel('avg spike count: sacc');
for jj = 1:nchannels        
%     plot(zs1(jj,:) - zs4(jj,:));
%     plot(zs2(jj,:) - zs4(jj,:));
    plot(ms(jj,:));
end

%%

figure; hold on;
for jj = 1:abs(np)
% for jj = 1:np
%     figure(jj); hold on;
%     title(jj);
    
    scatter3(zs1(:,jj)-zs4(:,jj), zs3(:,jj)-zs4(:,jj), zs2(:,jj)-zs4(:,jj));
    ylabel('sacc');
    zlabel('vis-off');
    
%     scatter(zs1(:,jj)-zs4(:,jj), zs3(:,jj)-zs4(:,jj));
%     ylabel('sacc');

%     scatter(zs1(:,jj)-zs4(:,jj), zs2(:,jj)-zs4(:,jj));
%     ylabel('vis-off');
    
    axis square;
    xlabel('vis-on');
    
    yl = ylim;
    xl = xlim;
    xlim([min(xl(1), yl(1)) max(xl(2), yl(2))]);
    xlim([-5 20]);
    ylim(xlim);
    
    plot(xlim, ylim, 'k--');
end
