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
fprintf( 'Generating PageRank distribution \n' );
Ak_full = full(Ak);
Ak_bin = double(Ak_full ~= 0);
Ak_bin = sparse(Ak_bin);

norm_sum = sum(Ak_bin, 1);
Ak_norm = sparse(Ak_bin ./ (norm_sum+1e-8));


% Generate the link graph
P = sparse(Ak_norm);
% Generate the personalized vector
p_vector = rand(n, 1);
% Normalize p vector
p_vector = p_vector / sum(abs(p_vector));
% Aggregator
e_t = ones(1, n);
% Fixed personalized term
S = p_vector * e_t;
S = sparse(S);

iters = 5;

fprintf( 'Studying dampening effect \n' );
%% Q1: Study the dampening effect
alphas = linspace(0.5, 0.95, 2);
for alpha=alphas
    fprintf("Evaluating alpha: %f\n", alpha)
    Pk0 = sparse(zeros(n, n));
    Pk = sparse(eye(n));
    for i=1:iters
        Pk = alpha * Pk * Ak_norm;
        Pk0 = Pk0 + Pk; 
    end
    vector_soln = Pk0 * (1-alpha) * p_vector;
    % Plot the Pagerank distribution
    figure();
    histogram(log10(vector_soln*n), 50);
    title_str = ['Pagerank-distribution with alpha=', num2str(alpha)];
    title(title_str);
    xlabel("value");
    ylabel("Count");
end

fprintf("Q1: Studying the dampening factor ended. Press any key to continue.\n");
pause();

%% Q2: Study the personalized vector
alpha = 0.85;
% Personalized vectors are generated from random normal distribution with 
% zero mean and different standard deviations. Smaller standard deviation
% indicates larger centrality of links in personalized vector.
stddev_list = linspace(0.1, 0.5, 5);

for stddev=stddev_list
    fprintf("Evaluating stddev: %f\n", stddev)
    p_vector = normrnd(0.5, stddev, [n, 1]);
    p_vector(p_vector>1) = 1.0;
    p_vector(p_vector<0) = 0.0;
    p_vector = p_vector / sum(abs(p_vector));
    Pk0 = sparse(zeros(n, n));
    Pk = sparse(eye(n));
    for i=1:iters
        Pk = alpha * Pk * Ak_norm;
        Pk0 = Pk0 + Pk; 
    end
    vector_soln = Pk0 * (1-alpha) * p_vector;

    % Plot the Pagerank distribution
    figure();
    histogram(log10(vector_soln*n), 50);
    title_str = ['Pagerank-distribution with', ...
        ' personalized vector generated from N(0,', ...
        num2str(stddev), ')'];
    title(title_str);
    xlabel("value");
    ylabel("Count");
end

fprintf("Q2: Studying the personalized vector ended. Press any key to continue.\n");
pause();

%% Q3: Batch computation of many pageranks
% It is easy to formulate batch computation of many personalized vectors
% by concanteating them into a single vector.

starttime = cputime;
batch_size = 32;

p_vector_mat = [];

% Fix a dampening vector of 5.
alpha = 0.85;
% Fix a standard deviation of 0.05
stddev = 0.1;

for i=1:batch_size
    p_vector = normrnd(0.5, stddev, [n, 1]);
    p_vector_mat = [p_vector_mat, p_vector];
end

Pk0 = sparse(zeros(n, n));
Pk = sparse(eye(n));
for i=1:iters
    Pk = alpha * Pk * Ak_norm;
    Pk0 = Pk0 + Pk; 
end
vector_soln_mat = Pk0 * (1-alpha) * p_vector_mat;

endtime = cputime;

fprintf("%f time elasped for computing 32 PageRank vectors in a batch.\n", ...
    endtime-starttime);

fprintf("Batch computation completed. Press any key for naive computation.\n");
pause();

% naive implementation baseline
starttime = cputime;
vector_soln_res = [];
for t=1:batch_size
    p_vector = normrnd(0.5, stddev, [n, 1]);
    p_vector(p_vector>1) = 1.0;
    p_vector(p_vector<0) = 0.0;
    Pk0 = sparse(zeros(n, n));
    Pk = sparse(eye(n));
    for i=1:iters
        Pk = alpha * Pk * Ak_norm;
        Pk0 = Pk0 + Pk; 
    end    
    vector_soln = Pk0 * (1-alpha) * p_vector;
    vector_soln_res = [vector_soln_res, vector_soln];
end
endtime = cputime;
fprintf("%f time elasped for computing 32 PageRank vectors separately.\n", ...
    endtime-starttime);