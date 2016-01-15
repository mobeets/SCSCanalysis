function X = filterExp(X, includeMiss)

validOutcomes = [1 3];
if includeMiss
    validOutcomes = [validOutcomes 4];
end
ix = arrayfun(@(x) any(x == validOutcomes), [X.Outcome]);
X = X(ix);

end
