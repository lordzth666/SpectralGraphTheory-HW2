clear all;
close all;

% Load graph
Datafilename = 'pbmc8k_v2.1.0_knn.mat'

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

Ak_full = full(Ak);

Ak_bin = sparse(double(Ak_full~=0));

% Get the centrality measurement by the degree-based measurement.
% Compute the in-degree and out-degree of each matrix.

in_degree = round(full(sum(Ak_bin, 2)));
out_degree = round(full(sum(Ak_bin, 1)));

% Plot the centrality measurement
figure();
subplot(2,1,1);
histogram(in_degree, 50); 
title('histogram of in-degrees (unweighted edges)');
xlabel("degree");
subplot(2,1,2);
histogram(out_degree, 50);
title('histogram of out-degrees (unweighted edges)');

%% Compute eccentrity
Ak_cells = get_Pk_counts(Ak_bin);
Geod = get_geodesics_all( Ak_cells );
eccentrity = max(Geod);

% Plot the centrality measurement
figure();
histogram(eccentrity); 
title('histogram of eccentrity (unweighted edges)');
xlabel("eccentrity");
ylabel("count");