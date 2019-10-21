function [Ak] = load_youtube_sparse(max_cnt)
    fID = fopen('com-youtube.ungraph.txt','r');
    formatSpec = '%d\t%d';
    sizeA = [2 Inf];
    edges = fscanf(fID, formatSpec, sizeA);
    edges = transpose(edges);
    % Filter out edge number larger than 500k
    edges_t = transpose(edges);
    filter_idx = (max(edges_t)<=500*1000);
    edges = edges(filter_idx,:);
    % Shuffle the edges and randomly select first 100k
    fprintf("Shuffling Started\n");
    idx = randperm(size(edges, 1));
    edges(:, 1) = edges(idx, 1);
    edges(:, 2) = edges(idx, 2);
    s = edges(1:max_cnt, 1);
    t = edges(1:max_cnt, 2);
    fprintf("Shuffling completed\n");
    G = digraph(s, t);
    Ak = adjacency(G);
    fclose(fID);
end