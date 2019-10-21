clear all;
close all;

% Load graph
Datafilename = 'pbmc8k_v2.1.0_knn.mat';

fprintf( '\n   loading data from file %s...\n', Datafilename  ); 

iodata = matfile( Datafilename );

I = iodata.I;                   % indices to neighbor nodes  
D = iodata.D;                   % distances to neighbors 

kmax = size( D, 2 );
n    = size( D, 1 ); 

fprintf('\n   data with %d vertices and their %d neighbors loaded \n', n, kmax ); 

fprintf( '\n   select a k value (<= %d)', kmax ); 
k = input( ' and enter k = ');

% Build Adjacency graph
fprintf( '\n   building the kNN graph...\n' ); 

Ik = I(:,1:k);
Dk = D(:,1:k);


Ak = knnsearch2sparse( Ik, Dk )';   % k-neighbors per node column 
% Mapping Ak to unweighted adjacency matrix
fprintf( 'Generating Katz distribution \n' ); 
Ak_full = full(Ak);
Ak_bin = double(Ak_full ~= 0);
Ak_bin = sparse(Ak_bin);

% Implement the Katz algorithm
alpha = 0.09;

katz_c = zeros(n, 1);

% Kartz centrality iteration limit
iters = 10;
Ak_t = eye(n);
Ak_t = sparse(Ak_t);

for i=1:iters
    Ak_t = alpha * Ak_t * Ak_bin;
    katz_tmp = sum(Ak_t, 2);
    katz_c = katz_c + katz_tmp;
end
katz_dense = full(katz_c);

% Plot the Katz distribution
figure();
histogram(log10(katz_dense), 50); 
title('Katz-distribution');
xlabel("value");
ylabel("Count");

