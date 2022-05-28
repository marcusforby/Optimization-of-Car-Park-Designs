function [inx, can_get_out, cant_get_out] = depth_first_init(first_point, end_point, X, Y, edges, can_get_out_before, cant_get_out_before)
% Purpose: Initialize the depth first search algorithm
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% first_point: the point which we initialize the algorithm from
% end_point: the points which can get out
% X: a vector containing the X-coordinates of the nodes
% Y: a vector containing the Y-coordinates of the nodes
% edges: edges between the nodes
% can_get_out_before: the nodes which have previously been shown to be able to get
% out
% cant_get_out_before: the nodes which have previously been shown to be unable to
% get out

%% OUTPUT
% inx: the slots which can get out
% can_get_out: updated list of the nodes which have previously been shown
% to be able to get out
% cant_get_out: updated list of the nodes which have previously been shown 
% to be unable to get out

%% CODE

n = max(max(edges(:,1:2)));
n_X = size(X,1);
m = size(first_point,1);
inx = zeros(m, 1);
can_get_out = zeros(n,1);
if ~isempty(can_get_out_before)
    can_get_out(1:size(can_get_out_before,1), :) = can_get_out_before;
end
cant_get_out = zeros(n,1);
if ~isempty(cant_get_out_before)
    cant_get_out(1:size(cant_get_out_before,1), :) = cant_get_out_before;
end

colors = zeros(n, 1); % 0 = not visited, 1 = visited

if size(can_get_out,1) ~= n
    disp('W')
end

for i = 1:m
%     if i == 44
%         disp('W')
%     end
    index = first_point(i,3);
    [inx(i), colors2, can_get_out, cant_get_out] = depth_first_algorithm(X, Y, edges, index, colors, end_point, can_get_out, cant_get_out);   
    if inx(i) == 0
        cant_get_out = or(cant_get_out, colors2);
    end
end

end