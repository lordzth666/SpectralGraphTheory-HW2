function S = knnsearch2sparse(idxCol, dist)
% KNNSEARCH2SPARSE - Transform knnsearch results to sparse matrix
%   
% SYNTAX
%
%   MAT = KNNSEARCH2SPARSE( IDXCOL, DIST )
%
% INPUT
%
%   IDXCOL      Column indices (id) of each neighbor    [n-by-k]
%   DIST        Distances of each neighbor              [n-by-k]
%
% OUTPUT
%
%   MAT         Neighbor distance matrix                [n-by-n sparse]
%
% DESCRIPTION
%
%   [IDXCOL, DIST] = KNNSEARCH( X, Y, KNBR );
%   MAT = KNNSEARCH2SPARSE( IDXCOL, DIST );
%
%   Transform the result of knnsearch to a sparse distance matrix.
%   
% DEPENDENCIES
%
%   <none>
%
%
% See also      rangesearch, knnsearch
%
  
  % number of "points" and "neighbors" (matrix side and row sparsity)
  [n, k] = size( idxCol );
  
  % row indices (for sparse matrix formation convenience)
  idxRow = repmat( (1 : n).', [1 k] );
  
  % sparse matrix formation
  S = sparse( idxRow, idxCol, dist, n, n );
    
end



%%------------------------------------------------------------
%
% AUTHORS
%
%   Dimitris Floros                         fcdimitr@auth.gr
%
% VERSION
%
%   0.1 - December 30, 2017
%
% CHANGELOG
%
%   0.1 (Dec 30, 2017) - Dimitris
%       * initial implementation
%
% ------------------------------------------------------------

