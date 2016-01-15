function [ix, mask] = newIndicesForGoodChannels()
    ix = [1:17 19:2:31 ([1:17 19:2:31]+32)];
    mask = zeros(64,1);
    mask(ix(1:24)) = 1; % L
    mask(ix(25:48)) = 2; % R
end
