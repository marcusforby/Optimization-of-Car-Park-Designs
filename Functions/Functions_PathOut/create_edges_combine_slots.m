function edges = create_edges_combine_slots(X, Y, edges, points, inx, first_point, end_point)
% Purpose: Create edges between slots that are close together
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% X: the x-coordinates of the grid
% Y: the y-coordinates of the grid
% edges: current edges
% points: the center of placed parking slots
% inx: indices of whether or not the slots can get out now
% first_point: the points which represents a slot in the grid
% end_point: the points which we can exit the lot from

%% OUTPUT
% edges: all current edges

%% CODE
n = size(X, 1);
k = size(end_point, 1);
m = size(first_point, 1);


node_number = [n+k+1:n+k+m]';
nodes_cant_get_out = [points(logical(ones(m, 1)-inx), 1:3), node_number(logical(ones(m, 1)-inx))];
nodes_can_get_out = [points(logical(inx), 1:3), node_number(logical(inx))];

new_edges = zeros(2*m, 3);
count = 1;
M = 1.0e3;

for i = 1:size(nodes_cant_get_out, 1)
    center_point = nodes_cant_get_out(i, 1:2);
    norms = sqrt(sum((nodes_can_get_out(:,1:2)-center_point).^2, 2));
    [min_val, index] = min(norms);
    if min_val < 9
        new_edges(count, :) = [nodes_cant_get_out(i, 4), nodes_can_get_out(index, 4), M];
        new_edges(count+1, :) = [nodes_can_get_out(index, 4), nodes_cant_get_out(i, 4), M];
        count = count + 2;
    end
end

edges = [edges; new_edges(1:count-1, :)];


end