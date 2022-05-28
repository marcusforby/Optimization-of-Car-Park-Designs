function points = heuristic_polygon_angled(area, parking_size, angle, rot_index, first_row_box_init)
% Purpose: Place parking slots with a given angle within an arbitrary
%          convex polygon
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
%         area: A list of points determining a polygon. The points must 
%               encircle the polygon in positive rotation
% parking_size: The dimensions of a parking slot. The first entry is width,
%               the second is height and the third is need free space in 
%               front of the car parking_size(3) to all sides.
%        angle: Angle in degrees, determining how much each slot has to 
%               be rotated
%    rot_index: an index which tells which side to rotate the area on

%% OUTPUT
% points: a list of points which indicates parkingslots. The first and 
%         second entries are the x- and y- coordinates of the center of the 
%         parking-slot, the third entry indicates which angle the parking 
%         slot is rotated, and the fourth indicates which side should be 
%         used to enter the slot

%% CODE

if angle >= 0
    rangle = angle/180*pi; % angle in radians
    rot_matrix_up = [cos(-rangle), -sin(-rangle); sin(-rangle), cos(-rangle)];
    rot_matrix_up_2 = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)];

    rot_matrix_down = [cos(-pi-rangle), -sin(-pi-rangle); sin(-pi-rangle), cos(-pi-rangle)];
    h_dist = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)]*[parking_size(1); -parking_size(2)]/2;
    h_dist = h_dist(1);
    v_dist = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)]*parking_size(1:2)'/2;
    v_dist = v_dist(2);
    cToc_h_dist = parking_size(1)/cos(rangle);
    new_center_vec = (rot_matrix_up*[0; parking_size(2)])';
    new_center_vec_2 = (rot_matrix_up_2*[0; parking_size(2)])';
else
    rangle = angle/180*pi; % angle in radians
    rot_matrix_up = [cos(-rangle), -sin(-rangle); sin(-rangle), cos(-rangle)];
    rot_matrix_up_2 = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)];

    rot_matrix_down = [cos(-pi-rangle), -sin(-pi-rangle); sin(-pi-rangle), cos(-pi-rangle)];
    h_dist = rot_matrix_up*[parking_size(1); -parking_size(2)]/2;
    h_dist = h_dist(1);
    v_dist = rot_matrix_up*parking_size(1:2)'/2;
    v_dist = v_dist(2);
    cToc_h_dist = parking_size(1)/cos(rangle);
    new_center_vec = (rot_matrix_up*[0; parking_size(2)])';
    new_center_vec_2 = (rot_matrix_up_2*[0; parking_size(2)])';
end

points = []; % variable holding all the parking-slot centers coordinates
point = -inf;

% First rotate the area, and save variables to rotate it back later
[area, displacement, rot_mat, rot_angle] = rotate_area(area, rot_index);

if isempty(first_row_box_init)
    first_row_box = [];
else
    first_row_box = first_row_box_init - displacement;
    first_row_box = first_row_box*rot_mat;
end


% Place the first row of slots along the lower side
x_interval = find_x_interval(0, 2*v_dist + parking_size(3), area);
% bottom_right_rot(1), x_disp_top_up_max, 

% first build the parking slot around (0, 0)
corner_points = [-parking_size(1:2)'/2, [1;-1].*parking_size(1:2)'/2, parking_size(1:2)'/2, [-1;1].*parking_size(1:2)'/2, (parking_size(1:2)'/2+[0; parking_size(3)]), [-1;1].*(parking_size(1:2)'/2+[0; parking_size(3)])];


for i = 1:2:length(x_interval)
    xmin = max(x_interval(i), point(1));
    xmax = x_interval(i+1);
%xmin = find_xmin_angle(bottom_left_rot(2)+parking_size(2)/2, 2*v_dist + parking_size(3), bottom_left_rot(1), x_disp_top_up_min, area);
    point = [xmin, v_dist];
     
    rangle = -angle/180*pi; % angle in radians
    calculated_rot_matrix = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)];

    max_diff = find_max_diff(calculated_rot_matrix, corner_points, area, point);
        
    point = point + [max_diff + 1.0e-5, 0];  
    counter = 1;
    while ~check_if_in_area(area, [point, -angle], parking_size) && counter < 100
        point(1) = point(1) + 1e-2;
        counter = counter + 1;
    end
    
    if isempty(first_row_box)
        while check_if_in_area(area, [point, -angle], parking_size) && point(1) < xmax
            points = [points; [point, -angle, 3]];
            point = point + [cToc_h_dist, 0];
        end
    else
        while check_if_in_area(area, [point, -angle], parking_size) && point(1) < xmax
            all_points = calculated_rot_matrix*corner_points(:, [1,2,3,4]) + point';
            if 0 == sum(inpolygon([all_points(1, :), point(1)], [all_points(2, :), point(2)], first_row_box(:, 1), first_row_box(:, 2)))
                points = [points; [point, -angle, 3]];
                point = point + [cToc_h_dist, 0];
            else
                point = point + [cToc_h_dist, 0];
            end
        end
    end
end


% find the highest y-value which we can place a slot
ymax = max(area(:, 2));
counter_2 = 1;

% while there is still vertical space, place rows of slots
while ymax - point(2) >= 3*v_dist + parking_size(3)
%     if mod(counter_2,2) == 1
%         angle = -angle;
%     else
%         angle = -angle;
%     end
    % move the y-coordinate to the new row
    point(2) = point(2) + 2*v_dist + parking_size(3);
    
    % find the maximum and the minimum x-value where we can place parking
    % slots
    x_interval = find_x_interval(point(2)- v_dist - parking_size(3), point(2)+v_dist, area);
    % x_disp_top_down_max, top_left_rot(1)
    
    point(1) = -inf;
    
    for i = 1:2:length(x_interval)
        
        %xmin  = find_xmin_angle(point(2)- v_dist - parking_size(3), point(2)+v_dist, x_disp_top_down_min, top_left_rot(1), area);
        xmin = max(x_interval(i), point(1));
        xmax = x_interval(i+1);
        
        if mod(counter_2, 2) == 0
            calculated_angle = 180-angle;
        else
            calculated_angle = 180+angle;
        end
        rangle = calculated_angle/180*pi; % angle in radians
        calculated_rot_matrix = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)];

        
        % the first x-coordinate we can place parking-slots on
        if i == 1
            point(1) = xmin;
            max_diff = find_max_diff(calculated_rot_matrix, corner_points, area, point) + 1e-4;
            point(1) = xmin + max_diff;

            counter = 0;
            while ~check_if_in_area(area, [point, calculated_angle], parking_size) && counter < 100
                point(1) = point(1) + 1e-2;
                counter = counter + 1;
            end
        else
            counter = 0;
            while ~check_if_in_area(area, [point, calculated_angle], parking_size) && counter < 100
                point = point + [cToc_h_dist, 0];
                counter = counter + 1;
            end
        end
         
        % save the first point placed in this row
        if i == 1
            first_point = point;
        end
        
        % place points first row
        if isempty(first_row_box)
            while check_if_in_area(area, [point, calculated_angle], parking_size) && point(1) < xmax
                points = [points; [point, calculated_angle, 3]];
                point = point + [cToc_h_dist, 0];
            end
        else
            while check_if_in_area(area, [point, calculated_angle], parking_size) && point(1) < xmax
                all_points = calculated_rot_matrix*corner_points(:, [1,2,3,4]) + point';
                if 0 == sum(inpolygon([all_points(1, :), point(1)], [all_points(2, :), point(2)], first_row_box(:, 1), first_row_box(:, 2)))
                    points = [points; [point, calculated_angle, 3]];
                    point = point + [cToc_h_dist, 0];
                else
                    point = point + [cToc_h_dist, 0];
                end
            end
        end 
    end
    
    % check if we can place another row on top of this one
    if ymax - point(2) < 3*h_dist + parking_size(3)
        break;
    end
    
    % repeat the same logic to place the new row
    if mod(counter_2, 2) == 0
        point = first_point + new_center_vec;
    else
        point = first_point + new_center_vec_2;
    end
    
    x_interval = find_x_interval(point(2)-v_dist, point(2)+ v_dist + parking_size(3), area);
    %xmax = find_xmax_angle(point(2)-v_dist, point(2)+ v_dist + parking_size(3), bottom_right_rot(1), x_disp_top_up_max, area);
    %xmin  = find_xmin_angle(point(2)-v_dist, point(2)+v_dist + parking_size(3), bottom_left_rot(1), x_disp_top_up_min, area);
    
    for i = 1:2:length(x_interval)
        xmin = x_interval(i);
        xmax = x_interval(i+1); 
        
        if xmin > xmax
            continue
        end
        
        spaces_to_the_left = floor((point(1) - xmin)/cToc_h_dist);

        point(1) = point(1) - spaces_to_the_left*cToc_h_dist;
       
        % now rotate all the points, and then move it to the real center of the
        % parking slot
        
        if mod(counter_2, 2) == 0
            calculated_angle = -angle;
        else
            calculated_angle = angle;
        end
        
        rangle = calculated_angle/180*pi; % angle in radians
        calculated_rot_matrix = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)];

        % now rotate all the points, and then move it to the real center of the
        % parking slot
        counter = 0;
        while ~check_if_in_area(area, [point, calculated_angle], parking_size) && counter < 100
            point = point + [cToc_h_dist, 0];
            counter = counter + 1;
        end
        
        if isempty(first_row_box)
            while check_if_in_area(area, [point, calculated_angle], parking_size) && xmax >= point(1)
                points = [points; [point, calculated_angle, 3]];
                point = point + [cToc_h_dist, 0];
            end
        else
            while check_if_in_area(area, [point, calculated_angle], parking_size) && xmax >= point(1)
                all_points = calculated_rot_matrix*corner_points(:, 1:4) + point';
                if 0 == sum(inpolygon([all_points(1, :), point(1)], [all_points(2, :), point(2)], first_row_box(:, 1), first_row_box(:, 2)))
                    points = [points; [point, calculated_angle, 3]];
                    point = point + [cToc_h_dist, 0];
                else
                    point = point + [cToc_h_dist, 0];
                end
            end
        end
    end
    counter_2 = counter_2 + 1;
end

% rotate and move the points back to the original area

if ~isempty(points)
    points(:, 1:2) = points(:, 1:2)*rot_mat^-1;
    points(:, 1:2) = points(:, 1:2) + displacement;
    points(:, 3) = points(:, 3) + 180*rot_angle/pi;
end

end