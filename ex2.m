clear;

% Load the youtube sparse graph

Ak = load_youtube_sparse(1200000);
Ak_bin = Ak;
norm_sum = sum(Ak_bin, 1);
Ak_norm = sparse(Ak_bin ./ (norm_sum+1e-8));

n = size(Ak, 1);

% First, compute the in-degree centrality
in_degree = round(full(sum(Ak, 2)));
degree_dist = in_degree;

% Next, compute the katx centrality.
% Implement the Katz algorithm
alpha = 0.09;

katz_c = zeros(n, 1);

%% Katz centrality
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

fprintf("Katz centrality completed. Press any key to continue\n");
pause();
% 
%% Page Rank centrality
% Plot the pagerank distribution
% Embed the PageRank centrality with alpha=0.85
% Generate the personalized vector
alphas = linspace(0.5, 0.9, 5);

figure();
for alpha=alphas
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
    histogram(log10(vector_soln*n), 100);
    title_str = 'Pagerank on 500k-node graph';
    hold on;
    title(title_str);
    xlabel("value");
    ylabel("Count");
end

figure();
stddevs = linspace(0.1, 0.5, 5);
for stddev=stddevs
    p_vector = normrnd(0.5, stddev, [n, 1]);
    p_vector(p_vector>1) = 1.0;
    p_vector(p_vector<0) = 0.0;

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
    histogram(log10(vector_soln*n), 100);
    title_str = 'Pagerank on 500k-node graph';
    hold on;
    title(title_str);
    xlabel("value");
    ylabel("Count");
end


box off
axis tight
legend("stddev=0.1","stddev=0.2","stddev=0.3","stddev=0.4","stddev=0.5",'Location','northwest');
legend boxoff

hold off;

fprintf("PageRank centrality completed. Press any key to continue \n");
pause();



%% Plot final embedding
figure();
gplot3D(Ak_bin, [degree_dist, katz_c, pagerank_dist]);
xlabel("In-degree distribution");
ylabel("katz-distribution");
zlabel("pagerank-distribution");
