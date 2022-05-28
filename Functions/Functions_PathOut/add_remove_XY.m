function [X, Y] = add_remove_XY(X, Y, X_start, Y_start, parking_size, chosen_points, points, road_width)
% Purpose: Add nodes to the grid, and remove the ones conflicting with
% chosen_points
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% X: x-coordinates for all the nodes in the grid
% Y: y-coordinates for all the nodes in the grid
% X_start: the x-coordinates of all original grid
% Y_start: the y-coordinates of all original grid
% parking_size: the sizes of the parking-slots
% chosen_points: indices of the points which we should remove nodes around
% points: the centers of all parking slots
% road_width: the width which is needed for the car to drive

%% OUTPUT
% X: x-coordinates for all the nodes in the grid
% Y: y-coordinates for all the nodes in the grid

%% CODE
n = size(X_start,1);
n_chosen_points = length(chosen_points);
f = parking_size(3);
h = parking_size(2);
w = parking_size(1);

% remove all points that cant be used anymore
new_points = logical(zeros(n,1));
close_points = logical(zeros(size(points,1),1));

% first build the parking slot around (0, 0)
all_points = [[-w/2; h/2+road_width], [w/2; h/2+road_width], [road_width+w/2; h/2], [road_width+w/2; -h/2], ...
    [w/2; -road_width-h/2], [-w/2; -road_width-h/2], [-road_width-w/2; -h/2], [-road_width-w/2; h/2]];

for i = 1:n_chosen_points
    index = chosen_points(i);
    point = points(index, 1:3);
    
    rot_mat = [cos(point(3)/180*pi), -sin(point(3)/180*pi); sin(point(3)/180*pi), cos(point(3)/180*pi)];

    % now rotate all the points, and then move it to the real center of the parking slot
    boundary_points = rot_mat*all_points + point(1:2)';
    boundary_points = boundary_points';

    IN = inpolygon(X_start, Y_start, boundary_points(:,1), boundary_points(:,2));
    
    new_points = logical(or(new_points, IN));
    
end


for i = 1:n_chosen_points
    norms = sqrt(sum((points(:,1:2)-points(chosen_points(i),1:2)).^2, 2));
    index = logical(norms < parking_size(3)*2);
    close_points = logical(or(close_points, index));
end

close_points(chosen_points) = 0;

X_new = X_start(new_points);
Y_new = Y_start(new_points);

X_new = [X_new; points(close_points, 1)];
Y_new = [Y_new; points(close_points, 2)];

[X_new, Y_new] = remove_XY(X_new, Y_new, parking_size, [size(X_new,1)-sum(close_points)+1:size(X_new,1)], points(:,3), road_width);

X = [X; X_new];
Y = [Y; Y_new];

end