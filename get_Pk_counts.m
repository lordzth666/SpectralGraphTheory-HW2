function [ Ak_cells] = get_Pk_counts( A ) 
% 
% Input
% =====
% A : n x n array of integers 
%     representing a graph G (not necessarily connected) 
%     in sparse storage format 
% 
% Output
% ======
% Ak_cells : Ak_cells{ell} contains the matrix of 
%            path with length ell, 1 <= ell <= diam( G) 
%            Ak_calls{ell}(i,j) = number of path with length ell 
%            from vertex j to vertex i 
% 
% see demo cases in demo_get_Pk.m 

%% 
n   = size( A, 1 );
MA  = zeros(n,n);                  % for accumulated mask  

k  = 1; 
Pk = A;

while nnz(Pk) > 0 
    MA = ( MA + Pk ) > 0;          % mask update 
    Ak_cells{k} = Pk; 

    k  = k + 1; 
    Qk = A * Pk;                   % one more step walk 
    Pk = Qk - diag( diag(Qk) );    % removal of cycles 
    Pk = Pk - MA .* Pk;            % removal of longer paths
    disp(nnz(Pk));
    
end


return 


%% Program Log 
%  Initial draft: Sept. 15, 2019 
%  Last revision: Sept. 30, 2019  
%
%  Programmer: Xiaobai Sun 
%               Duke CS 
% 
