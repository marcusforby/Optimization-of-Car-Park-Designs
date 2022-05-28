function [edges, new_edges] = create_edges_first_point(X, Y, edges, first_point, end_point)
% Purpose: Create edges to the first point from centers
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% X: the x-coordinates of the grid
% Y: the y-coordinates of the grid
% edges: current edges
% first_point: the points which represents a slot in the grid
% end_point: the points which we can exit the lot from

%% OUTPUT
% new_edges: the edges which have been created
% edges: all current edges

%% CODE
n = size(X, 1);
m = size(first_point, 1);
k = size(end_point, 1);

% Set weight to 1 on all edges
edges = [edges, ones(size(edges, 1), 1)];

% Create new edges with weight M:
M = 1.0e3;
new_edges = [[n+k+1:n+k+m]', first_point(:, 3), M*ones(m, 1); ...
             first_point(:, 3), [n+k+1:n+k+m]', M*ones(m,1)];

edges = [edges; new_edges];
         
end
