function [output, colors, can_get_out, cant_get_out] = depth_first_algorithm(X, Y, edges, index, colors, end_point, can_get_out, cant_get_out)
% Purpose: Depth first search algorithm, which recursively tries to find a
% way out of a network
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% X: a vector containing the X-coordinates of the nodes
% Y: a vector containing the Y-coordinates of the nodes
% edges: edges between the nodes
% index: the node we currently are at
% colors: the colors of the nodes
% end_point: the points which can get out
% can_get_out: the nodes which have previously been shown to be able to get
% out
% cant_get_out: the nodes which have previously been shown to be unable to
% get out

%% OUTPUT
% output: binary variable determining if a way out have been found or not
% colors: updated list of colors of nodes
% can_get_out: updated list of the nodes which have previously been shown
% to be able to get out
% cant_get_out: updated list of the nodes which have previously been shown 
% to be unable to get out

%% CODE

n = size(X, 1);
k = size(end_point, 1);
index_from = find(edges(:,1) == index);

colors(index) = 1;

if isempty(index_from)
    output = 0;
    return
end

if can_get_out(index) == 1
    output = 1;
    return
end

if cant_get_out(index) == 1
    output = 0;
    return
end

for i = 1:length(index_from)
    index_to = edges(index_from(i),2);
    if index_to > n && index_to <= n+k
        can_get_out(index) = 1;
        output = 1;
        return
    elseif colors(index_to) == 0
        [output, colors, can_get_out] = depth_first_algorithm(X, Y, edges, index_to, colors, end_point, can_get_out, cant_get_out);
        if output == 1
            can_get_out(index) = 1;
            return
        end
    else
        output = 0;
    end
end

end