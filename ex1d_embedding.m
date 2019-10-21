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

Ak_full = full(Ak);

boolean_masking = double(Ak_full~=0);

% Embed the in-degree centrality
in_degree = round(full(sum(boolean_masking, 2)));
out_degree = round(full(sum(boolean_masking, 1)));

degree_dist = in_degree;

Ak_bin = double(Ak_full ~= 0);
Ak_bin = sparse(Ak_bin);

norm_sum = sum(Ak_bin, 1);
Ak_norm = sparse(Ak_bin ./ (norm_sum+1e-8));

% Implement the Katz algorithm
alpha = 0.09;

katz_c = zeros(n, 1);
% Kartz centrality iteration limit
fprintf( 'Generating Katz distribution \n' ); 


iters = 10;
Ak_t = eye(n);
Ak_t = sparse(Ak_t);

for i=1:iters
    Ak_t = alpha * Ak_t * Ak_bin;
    katz_tmp = sum(Ak_t, 2);
    katz_c = katz_c + katz_tmp;
end

% Embed the PageRank centrality with alpha=0.85
% Generate the personalized vector
alpha= 0.85;
p_vector = rand(n, 1);
% Normalize p vector
p_vector = p_vector / sum(abs(p_vector));

fprintf("Evaluating Pagerank...\n");
Pk0 = sparse(zeros(n, n));
Pk = sparse(eye(n));
for i=1:iters
        Pk = alpha * Pk * Ak_norm;
        Pk0 = Pk0 + Pk; 
end
vector_soln = Pk0 * (1-alpha) * p_vector * n;
pagerank_dist = vector_soln;

%% Compute eccentrity
Ak_cells = get_Pk_counts(Ak_bin);
Geod = get_geodesics_all( Ak_cells );
eccentrity = transpose(max(Geod));

figure();
gplot3D(Ak_bin, [eccentrity, katz_c, pagerank_dist]);
xlabel("in-degree distribution");
ylabel("katz-distribution");
zlabel("pagerank-distribution");