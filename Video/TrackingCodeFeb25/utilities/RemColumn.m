function [ColumnRemoved] = RemColumn(InputMatrix,ColumnToRemove)
%RemColumn Removes a column from an input matrix.
%   RemColumn
if ColumnToRemove > size(InputMatrix,2)
    error('Column does not exist. Check matrix size.')
end
ColumnRemovedA = InputMatrix(1:end,1:ColumnToRemove-1);
ColumnRemovedB = InputMatrix(1:end,ColumnToRemove+1:end);
ColumnRemoved = [ColumnRemovedA ColumnRemovedB];
end

