function y = dropNonstimFields(y)
% ignore all non-trial-related fieldnames

fns = setdiff(fieldnames(y), io.stimFields());
for ii = 1:numel(fns)
    y = rmfield(y, fns{ii});
end

end
