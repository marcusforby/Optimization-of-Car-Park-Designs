function first_point = pick_first_point(X, Y, points, parking_size)
% Purpose: Find the first points, which represent the parking slot in the
% grid
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% X: a vector containing the X-coordinates of the nodes
% Y: a vector containing the Y-coordinates of the nodes
% points: the center points of the placed parking slots
% parking_size: the dimension of the parking slots

%% OUTPUT
% first_point_out: the points which represents the parking slots in the
% grid

%% CODE

f = parking_size(3);
n = size(points,1);
first_point = zeros(n, 3);

for i = 1:n
    point = points(i,:);

    rot_mat = [cos(point(3)/180*pi), -sin(point(3)/180*pi); sin(point(3)/180*pi), cos(point(3)/180*pi)];

    % first build the parking slot around (0, 0)
    all_points = [(parking_size(1:2)./2)', [-1;1].*(parking_size(1:2)./2)', [-1;1].*(parking_size(1:2)./2 + [0,f])', (parking_size(1:2)./2+[0,f])'];

    % now rotate all the points, and then move it to the real center of the parking slot
    boundary_points = rot_mat*all_points + point(1:2)';
    boundary_points = boundary_points';

    [IN, ON] = inpolygon(X, Y, boundary_points(:,1), boundary_points(:,2));
    
    if sum(IN) > 0
        index = min(find(IN));
        first_point(i, :) = [X(index), Y(index), index];
    else
        disp("Somethings wrong")
        first_point = 0;
        return
    end
end











end