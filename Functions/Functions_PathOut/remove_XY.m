function [X, Y] = remove_XY(X, Y, parking_size, chosen_points, angles, road_width)
% Purpose: remove coordinates from the grid, which overlap with the chosen
% points
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% X: a vector containing the X-coordinates of the nodes
% Y: a vector containing the Y-coordinates of the nodes
% parking_size: the dimension of the parking slots
% chosen_points: the points chosen to have removed grid around them
% angles: a vector containing all the slots angle
% road_width: the width of the road

%% OUTPUT
% X: a vector containing the X-coordinates of the nodes
% Y: a vector containing the Y-coordinates of the nodes

%% CODE

n = length(X);
n_beginning_points = length(chosen_points);
f = parking_size(3);
h = parking_size(2);
w = parking_size(1);
% remove all points that cant be used anymore
remove_points = logical(zeros(n,1));

% first build the parking slot around (0, 0)
all_points = [[-w/2; h/2+road_width], [w/2; h/2+road_width], [road_width+w/2; h/2], [road_width+w/2; -h/2], ...
    [w/2; -road_width-h/2], [-w/2; -road_width-h/2], [-road_width-w/2; -h/2], [-road_width-w/2; h/2]];

for i = 1:n_beginning_points
    index = chosen_points(i);
    point = [X(index), Y(index)];
    rot_mat = [cos(angles(i)/180*pi), -sin(angles(i)/180*pi); sin(angles(i)/180*pi), cos(angles(i)/180*pi)];
    
    % now rotate all the points, and then move it to the real center of the parking slot
    boundary_points = rot_mat*all_points + point(1:2)';
    boundary_points = boundary_points';

    [IN, ON] = inpolygon(X, Y, boundary_points(:,1), boundary_points(:,2));
    remove_points = logical(or(remove_points, IN-ON)); 
end

keep_points = logical(ones(n,1) - remove_points);

X = X(keep_points);
Y = Y(keep_points);

end