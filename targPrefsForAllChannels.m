function targPrefs = targPrefsForAllChannels(RChs)
    ix = newIndicesForGoodChannels();
    ixd = false(1,numel(ix));
    ixd(RChs) = true;
    targPrefs = ones(1,64);
    targPrefs(ix(ixd)) = 2;
end
