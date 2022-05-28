function [points, new_area, empty_area] = heuristic_boundary_single(area, parking_size, algorithm, index, rot_index)
% Purpose: Place parking slots along all the sides of an arbitrary polygon
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% area: A list of points determining a polygon. The points must encircle
% the polygon in positive rotation
% parking_size: The dimensions of a parking slot. The first entry is width,
% the second is height and the third is need free space in front of the car
% algorithm: A number indicating which (if any) function should be called
% at the end of this function
% index: A boolean indicating whether the slots needs to hold a distance of
% parking_size(3) to all sides.
% rot_index: an index which tells which side to rotate the area on

%% OUTPUT
% points: a list of points which indicates parkingslots. The first and 
% second entries are the x- and y- coordinates of the center of the 
% parking-slot, the third entry indicates which angle the parking slot is 
% rotated, and the fourth indicates which side should be used to enter the 
% slot

%% CODE

% First rotate the area, and save variables to rotate it back later
[area, displacement, rot_mat, rot_angle] = rotate_area(area, rot_index);

% Check if the area is too small to place parking slots inside it
if abs(min(area(:,1))-max(area(:,1))) <= parking_size(1) + parking_size(3) || abs(min(area(:,2))-max(area(:,2))) <= parking_size(2) + parking_size(3)
    points = [];
    new_area = [];
    empty_area = area*rot_mat^-1;
    empty_area = empty_area + displacement';
    return;
end

n = size(area, 1);
new_area = [];


point = parking_size(1:2)/2;
%xmax = find_xmax(point(2)-parking_size(2)/2, point(2)+parking_size(2)/2 + parking_size(3), area);
%xmin = find_xmin(point(2)-parking_size(2)/2, point(2)+parking_size(2)/2 + parking_size(3), area);
x_interval = find_x_interval(point(2)-parking_size(2)/2, point(2)+parking_size(2)/2 + parking_size(3), area);
if length(x_interval) > 2
    disp('SOMETHING IS WRONG')
end
xmin = x_interval(1);
xmax = x_interval(2);
point = [xmin, 0] + point;
points = [];

% Place parking-slots along the first side
while xmax - point(1) >= parking_size(1)*0.5
    points = [points; [point, 0, 3]];
    point = point + [parking_size(1), 0];
end

% save or initiate variables
prev_direction = [1, 0];
prev_direction_last_point = [1, 0];
prev_normal_last_point = [0, 1];
prev_angle = zeros(n, 1);
prev_point = [0, 0] + [0, parking_size(2)+parking_size(3)];
no_points = 0;
index_last_point = 1;
been_over_min_y = 0;
been_below_0_x = 0;
x_max_constraint_holds = 0;

for i=2:n
    % k is the index of the next side
    if i == n
        k = 1;
    else
        k = i+1;
    end
    
    % B is the point at which this side and the last side which we have 
    % placed parking slots
    if size(points, 1) == no_points
        dir_vec_prev = area(index_last_point+1, :) - area(index_last_point, :);
        dir_vec_now = area(k, :) - area(i, :);
        point_prev = area(index_last_point+1, :);
        point_now = area(i, :);
        t = [dir_vec_prev', -dir_vec_now']\(point_now-point_prev)';
        B = t(1)*dir_vec_prev + point_prev;
        true_prev_angle = prev_angle(index_last_point+1);
    else
        true_prev_angle = prev_angle(i);
        B = area(i, :);
    end
    
    % Save the number of points we currently have created
    no_points = size(points, 1);
    
    side = area(k, :) - B;
    angle = acos([1, 0]*side'/norm(side));
    % check if we are moving in a positive x-direction and negative
    % y-direction. If we are, then the x_max_constraint_holds needs to be
    % true
    if side(2) < 0
        angle = 2*pi-angle;
        if side(1) > 0
            x_max_constraint_holds = 1;
        end
    end
    
    direction_vector = side/norm(side);
    normal_vector = [-direction_vector(2), direction_vector(1)];
    
    alpha = angle - true_prev_angle;
    
    % Calculate how long along the current side we need to go, such that we
    % don't conflict with previously placed parking slots
    if alpha > pi/2 - 1e-3
        % Trigonometric observations
        red_side = sin(alpha-pi/2)*parking_size(2);
        long_side = (red_side + parking_size(2) + parking_size(3))/cos(alpha-pi/2);
    else
        % Calculate the last point placed
        point = point - parking_size(1)*prev_direction_last_point;
        
        % The case where the side of the next slot, hits the corner of the
        % free space in front of the previous parking slot
        corner = point + parking_size(1)/2*prev_direction_last_point + (parking_size(2)/2 + parking_size(3))*prev_normal_last_point;
        t = [direction_vector', -normal_vector']\(corner - area(i, :))';
        A = t(1)*direction_vector + area(i, :);
        
        if (A-B)*direction_vector' > 0
            long_side_1 = norm(B-A, 2);
        else
            long_side_1 = 0;
        end
        
        % The case where the side of the next slot, hits the corner of the
        % actual previous parking slot
        corner = point + parking_size(1)/2*prev_direction_last_point + parking_size(2)/2*prev_normal_last_point;
        t = [direction_vector', -normal_vector']\(corner - area(i, :))';
        A = t(1)*direction_vector + area(i, :);
        
        if (A-B)*direction_vector' > 0
            min_long_side = norm(B-A, 2);
        else
            min_long_side = 0;
        end
        
        % The case where the corner of the next slot, hits the side of the 
        % last previous parking slot
        red_side = sin(alpha)*parking_size(2);
        
        t = [direction_vector', -prev_normal_last_point']\(point+parking_size(1)/2*prev_direction_last_point-area(i, :))';
        C = t(1)*direction_vector + area(i, :);
        
        long_side_2 = red_side/cos(alpha);
        long_side_2 = long_side_2 - norm(C-B, 2);
        
        long_side = min(long_side_1, long_side_2);
        long_side = max(long_side, max(min_long_side, 0));
        
    end
    
    % Calculate the center of the next slot we want to place
    point = B + parking_size(2)/2*normal_vector;
    point = point + (long_side + parking_size(1)/2)*direction_vector;
    
    % Solve for a corner of the new polygon
    if index
        t = [direction_vector', -prev_direction']\(prev_point-point-parking_size(2)/2*normal_vector)';
        new_area = [new_area; t(1)*direction_vector + point + parking_size(2)/2*normal_vector];
    else
        t = [direction_vector', -prev_direction']\(prev_point-point-(parking_size(2)/2+parking_size(3))*normal_vector)';
        new_area = [new_area; t(1)*direction_vector + point + (parking_size(2)/2 + parking_size(3))*normal_vector];
    end
    
    % j is the point after the point k
    if k == n
        j = 1;
    else
        j = k + 1;
    end
    
    side = area(j, :) - area(k, :);
    alpha = acos([1, 0]*side'/norm(side));
    if side(2) < 0
        alpha = 2*pi-alpha;
    end
    alpha = alpha - angle;
    
    % Find the stopping point, by considering the two places it can hit the
    % next side/sides
    top_intersection_point  = find_next_intersection(area, area(k, :) - area(i, :), i, area(i, :)+normal_vector*(parking_size(2)+parking_size(3)));
    stopping_point_1 = top_intersection_point - parking_size(1)/2*direction_vector - (parking_size(2)/2 + parking_size(3))*normal_vector;
    stopping_point_2 = area(k, :) + parking_size(2)/2*normal_vector - parking_size(1)/2*direction_vector;
    if (stopping_point_2 - stopping_point_1)*direction_vector'>0
        stopping_point = stopping_point_1;
    else
        stopping_point = stopping_point_2;
    end
    
    % find the matrix which rotates the parking slot
    rot_mat_side = [cos(angle), -sin(angle); sin(angle), cos(angle)];
    % first build the parking slot around (0, 0)
    rotated_slot = [-parking_size(1:2)'/2, [1;-1].*parking_size(1:2)'/2, parking_size(1:2)'/2, [-1;1].*parking_size(1:2)'/2];
    
    % now rotate all the points, and then move it to the real center of the
    % parking slot
    rotated_slot = rot_mat_side*rotated_slot;
    
    % If needed, calculate the minimum y and x value, such that the parking
    % slots don't intersect with the first row of parking slots
    if been_over_min_y
        min_y = min(rotated_slot(2, :));
    else
        min_y = inf;
    end
    if x_max_constraint_holds || been_below_0_x
        max_x = max(rotated_slot(1, :));
    else
        max_x = inf;
    end
    
    % Place the parking slots along this side, until there is no more space
    while (stopping_point - point)*direction_vector' > 0 && (parking_size(2) + parking_size(3) <= point(2) + min_y || 0 > point(1)+max_x) 
        points = [points; [point, angle/pi*180, 3]];
        point = point + parking_size(1)*direction_vector;
        index_last_point = i;
    end
    
    % Check if we need to consider the minimum x and y value when placing
    % slots along the next side
    min_y = min(rotated_slot(2, :));
    if ~been_over_min_y && parking_size(2) + parking_size(3) < point(2) + min_y
        been_over_min_y = 1;
    end
    max_x = max(rotated_slot(1, :));
    if ~been_below_0_x && 0 > point(1) + max_x
        been_below_0_x = 1;
    end

    % save variables for when looking at the next side
    prev_angle(k) = angle;
    prev_direction = direction_vector;

    if i == index_last_point
        prev_normal_last_point = normal_vector;
        prev_direction_last_point = direction_vector;
    end
        
    if index
        prev_point = point + parking_size(2)/2*normal_vector;
    else
        prev_point = point + (parking_size(2)/2+parking_size(3))*normal_vector;
    end
end

% Calculate the last point in the new area
if index
    t = [direction_vector', -[1, 0]']\(parking_size(2)*[0,1]-point-parking_size(2)/2*normal_vector)';
    new_area = [t(1)*direction_vector + point + parking_size(2)/2*normal_vector; new_area];
else
    t = [direction_vector', -[1, 0]']\((parking_size(2)+parking_size(3))*[0,1]-point-(parking_size(2)/2+parking_size(3))*normal_vector)';
    new_area = [t(1)*direction_vector + point + (parking_size(2)/2 + parking_size(3))*normal_vector; new_area];
end


if ~index
    points(:, 1:2) = points(:, 1:2)*rot_mat^-1;
    points(:, 1:2) = points(:, 1:2) + displacement;
    points(:, 3) = points(:, 3) + 180*rot_angle/pi;
    area = area*rot_mat^-1;
    area = area + displacement;
    new_area = new_area*rot_mat^-1;
    new_area = new_area + displacement;
end

new_area = check_for_crosses(new_area);

% This is included but outcommented for debugging purposes
% figure; plot_parking_spaces(points, area, parking_size(1:2));

% Call the next algorithm, given by the variable algorithm
if algorithm == 0
    [new_area, new_points] = heuristic_polygon_straight(new_area, parking_size, algorithm, rot_index);
    empty_area = [];
elseif algorithm == 1
    [new_area, new_points, ~, empty_area] = heuristic_boundary_single(new_area, parking_size, algorithm, 0, rot_index);
elseif algorithm == 2
    [new_area, new_points, ~, empty_area] = heuristic_boundary_double(new_area, parking_size, algorithm, 0, 0);
else
    new_points = [];
    empty_area = [];
end

% Add the new points to the points
points = [points; new_points];

end