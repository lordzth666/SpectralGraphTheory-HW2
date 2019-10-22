%% Create a bipartite and test the connectivity
s = [1,2,3,4,5,6,7,8,9,10];
t = [2,3,4,5,1,7,9,10,8,6];

G = digraph(s, t);
A = adjacency(G);

n = size(A, 1);

groups = partition_graph(A, 1, 1:n, n);
groups = full(groups);
groups = sort_group(groups);
disp(groups);
fprintf("Testing of a bipartite completed.\n");
pause();

fprintf("Testing a demo barbell graph from matlab\n");

%% Use a more complicated barbell graph
load barbellgraph.mat
G = graph(A,'omitselfloops');
p = plot(G,'XData',xy(:,1),'YData',xy(:,2),'Marker','.');
axis equal

n = size(A, 1);

% Remove the diagnol value
A(1:n,1:n)=0;

groups = partition_graph(A, 1, 1:n, n);
groups = full(groups);
groups = sort_group(groups);
disp(groups);



