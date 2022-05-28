function points = heuristic_polygon_angled_first_side(area, parking_size, parking_size_first_side, angle, angle_first_side, side_index)
% Purpose: Place parking slots with a given angle within an arbitrary
%          convex polygon, after having filled one side with parking 
%          slots first
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

%% Place the first side
% First rotate the area, and save variables to rotate it back later
[area_first, displacement, rot_mat, rot_angle] = rotate_area(area, side_index);

points_first_side = []; % variable holding all the parking-slot centers coordinates

if angle_first_side >= 0
    rangle = angle_first_side/180*pi; % angle in radians
    rot_matrix_up = [cos(-rangle), -sin(-rangle); sin(-rangle), cos(-rangle)];
    h_dist = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)]*[parking_size_first_side(1); -parking_size_first_side(2)]/2;
    h_dist = h_dist(1);
    v_dist = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)]*parking_size_first_side(1:2)'/2;
    v_dist = v_dist(2);
    cToc_h_dist = parking_size_first_side(1)/cos(rangle);
else
    rangle = angle_first_side/180*pi; % angle in radians
    rot_matrix_up = [cos(-rangle), -sin(-rangle); sin(-rangle), cos(-rangle)];
    h_dist = rot_matrix_up*[parking_size_first_side(1); -parking_size_first_side(2)]/2;
    h_dist = h_dist(1);
    v_dist = rot_matrix_up*parking_size_first_side(1:2)'/2;
    v_dist = v_dist(2);
    cToc_h_dist = parking_size_first_side(1)/cos(rangle);
end 

% Place the first row of slots along the lower side
x_interval = find_x_interval(0, 2*v_dist + parking_size_first_side(3), area_first);
% bottom_right_rot(1), x_disp_top_up_max, 

% first build the parking slot around (0, 0)
corner_points = [-parking_size_first_side(1:2)'/2, [1;-1].*parking_size_first_side(1:2)'/2, parking_size_first_side(1:2)'/2, [-1;1].*parking_size_first_side(1:2)'/2, (parking_size_first_side(1:2)'/2+[0; parking_size_first_side(3)]), [-1;1].*(parking_size_first_side(1:2)'/2+[0; parking_size_first_side(3)])];

point = -inf;
for i = 1:2:length(x_interval)
    xmin = max(x_interval(i), point(1));
    xmax = x_interval(i+1);
    point = [xmin, v_dist];
     
    rangle = -angle_first_side/180*pi; % angle in radians
    calculated_rot_matrix = [cos(rangle), -sin(rangle); sin(rangle), cos(rangle)];

    max_diff = find_max_diff(calculated_rot_matrix, corner_points, area_first, point);
        
    point = point + [max_diff + 1.0e-5, 0];
    
    counter = 0;
    while ~check_if_in_area(area_first, [point, -angle_first_side], parking_size_first_side) && counter < 100
        point(1) = point(1) + 1e-2;
        counter = counter + 1;
    end

    while check_if_in_area(area_first, [point, -angle_first_side], parking_size_first_side) && point(1) < xmax
        points_first_side = [points_first_side; [point, -angle_first_side, 3]];
        point = point + [cToc_h_dist, 0];
    end
end


% rotate and move the points back to the original area
if ~isempty(points_first_side)
    point1 = [points_first_side(1, 1)-h_dist, 0];
    point2 = [points_first_side(end, 1)+h_dist, 0];
    first_row_box = [point1; point2; point2 + [0, 2*v_dist+parking_size_first_side(3)]; point1 + [0, 2*v_dist+parking_size_first_side(3)]];
    
    points_first_side(:, 1:2) = points_first_side(:, 1:2)*rot_mat^-1;
    points_first_side(:, 1:2) = points_first_side(:, 1:2) + displacement;
    points_first_side(:, 3) = points_first_side(:, 3) + 180*rot_angle/pi;
    first_row_box = first_row_box*rot_mat^-1;
    first_row_box_init = first_row_box + displacement;
else
    first_row_box_init = zeros(4, 2);
end


%% Place the remaining rows

points_max = [];

for rot_index=1:size(area, 1)
    
    points = heuristic_polygon_angled(area, parking_size, angle, rot_index, first_row_box_init);
    
    if size(points_max, 1) < size(points, 1)
        points_max = points;
    end
    
end

points = [points_max; points_first_side];

end