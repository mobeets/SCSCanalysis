function [X2, Yproj] = projectAttentionAxis(X, Y, mLA, mLB, pulseInd, ...
    oriChange)

v = diff([mLA mLB]');
v = v/norm(v);

[~, X2, Y2] = getTrialInds(X, Y, [], pulseInd, oriChange);
ix = ismember([X2.Outcome], [1 4]);
X2 = X2(ix);
Y2 = Y2(ix);
Yproj = Y2*v;

end
