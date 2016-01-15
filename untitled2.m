a = 1.2;
b = 0.8;
ps = [a b 1-b 1-a];%./0.5;
xs0 = [...
    0 0 0 1; 0 0 1 0; 0 1 0 0; 1 0 0 0; ...
    0 0 1 1; 0 1 0 1; 1 0 0 1; 0 1 1 0; ...
    1 0 1 0; 1 1 0 0; ...
    1 1 1 0; 0 1 1 1; 1 0 1 1; 1 1 0 1 ...
];
xs = xs0;
xs(xs == 0) = nan;
Ps = xs .* repmat(ps, size(xs,1), 1);
% p = exp(nansum(log(Ps),2));
p = nanmean(Ps,2);
% p = (p + 0.5)/max(p + 0.75)

''
ps
(sum(p >= 0 & p <= 1) == numel(p > 0)) % must be valid probs
mean(p) % must be mean 0.5
(xs0'*p/size(xs0,1))' % must match goal ps
