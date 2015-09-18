function [Summary, EACHchRESP] = noiseCorrelations(...
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

end