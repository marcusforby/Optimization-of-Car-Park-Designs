function [first_point, points] = remove_used_parking_slots(path, first_point, end_point, X, Y, points)
% Purpose: remove parking slots which have been chosen
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% path: a list of the parking-slots to be removed
% first_point: the points which represents the parking slots in the grid
% end_point: the points which can get out
% X: a vector containing the X-coordinates of the nodes
% Y: a vector containing the Y-coordinates of the nodes
% points: the center points of the placed parking slots
% parking_size: the dimension of the parking slots

%% OUTPUT
% first_point_out: the points which represents the parking slots in the
% grid

%% CODE

n_X = size(X,1);
k = size(end_point,1); 
m = size(first_point, 1);

index = find(path > n_X+k);

remove_points_index = sort(path(index)- n_X - k);

first_point(remove_points_index,:) = [];
points(remove_points_index,:) = [];



end
