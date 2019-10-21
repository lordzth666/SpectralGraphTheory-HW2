clear;

% Load the youtube sparse graph

Ak = load_youtube_sparse(1000000);
Ak_bin = Ak;
norm_sum = sum(Ak_bin, 1);
Ak_norm = sparse(Ak_bin ./ (norm_sum+1e-8));

n = size(Ak, 1);

% First, compute the in-degree centrality
in_degree = round(full(sum(Ak, 2)));
degree_dist = in_degree;

% Next, compute the katx centrality.
% Implement the Katz algorithm
alpha = 0.01;

katz_c = zeros(n, 1);

% Kartz centrality iteration limit
fprintf("Evaluating Katz centrality...");
iters = 3;
Ak_t = speye(n);

for i=1:iters
    disp(i);
    Ak_t = alpha * Ak_t * Ak_bin;
    katz_tmp = sum(Ak_t, 2);
    katz_c = katz_c + katz_tmp;
end
katz_dist = full(katz_c);

% Plot the Katz distribution
figure();
histogram(log10(katz_dist), 50); 
title('Katz-distribution for graph with 500k nodes');
xlabel("value");
ylabel("Count");

% Plot the pagerank distribution
% Embed the PageRank centrality with alpha=0.85
% Generate the personalized vector
alpha= 0.85;
p_vector = rand(n, 1);
% Normalize p vector
p_vector = p_vector / sum(abs(p_vector));

fprintf("Evaluating Pagerank...\n");
Pk0 = speye(n) - speye(n);
Pk = speye(n);
for i=1:iters
    
        Pk = alpha * Pk * Ak_norm;
        Pk0 = Pk0 + Pk; 
end
vector_soln = Pk0 * (1-alpha) * p_vector * n;
pagerank_dist = vector_soln;

% Plot the Pagerank distribution
figure();
histogram(log10(vector_soln*n), 50);
title_str = 'Pagerank on 500k-node graph';
title(title_str);
xlabel("value");
ylabel("Count");

% Plot the embedding

figure();
gplot3D(Ak_bin, [degree_dist, katz_dist, pagerank_dist]);
xlabel("in-degree distribution");
ylabel("katz-distribution");
zlabel("pagerank-distribution");
