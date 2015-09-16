function [MatrixEntries] = GetMatrixEntries(Matrix,RowIndex,ColumnIndex,varargin)

% Scan the user's input to the function and verify that it is legit
P = inputParser;
addRequired(P,'Matrix',@(x) ~isempty(x));
addRequired(P,'RowIndex',@(x)islogical(x)|isnumeric(x))
addRequired(P,'ColumnIndex',@(x)islogical(x)|isnumeric(x));
addOptional(P,'UpperTriangleFilter',false,@islogical);
parse(P,Matrix,RowIndex,ColumnIndex,varargin{:});
InputParams = P.Results;

if ~iscolumn(RowIndex)
    RowIndex = RowIndex';
end

if ~isrow(ColumnIndex)
    ColumnIndex = ColumnIndex';
end

[SizeX,SizeY] = size(Matrix);

if islogical(RowIndex)
   RowIDX = RowIndex;
else
   RowIDX = false(SizeX,1);
   RowIDX(RowIndex)= true; 
end


if islogical(ColumnIndex)
    ColIDX = ColumnIndex;
else
    ColIDX = false(1,SizeY);
    ColIDX(ColumnIndex) = true;    
end

RowColFilter = repmat(RowIDX,[1,SizeY]) & repmat(ColIDX,[SizeX,1]);

% Now we want to make sure we dont grab duplicate entries across the
% diagonal, this will result in double counting.
if InputParams.UpperTriangleFilter
    DuplicateFilter = (RowColFilter & RowColFilter') & triu(true(SizeX));
else
    DuplicateFilter = (RowColFilter & RowColFilter') & tril(true(SizeX));
end

RowColFilter(DuplicateFilter) = false;
MatrixEntries = Matrix(RowColFilter);

%imagesc(RowColFilter)
end