function tmp3(Y)
nchannels = 64;
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


end
