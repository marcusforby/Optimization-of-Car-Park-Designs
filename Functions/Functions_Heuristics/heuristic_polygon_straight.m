function points = heuristic_polygon_straight(area, parking_size, index, rot_index)
% Purpose: Place parking slots with a angle of 90 degrees within an
%          arbitrary convex polygon
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
%         area: A list of points determining a polygon. The points must 
%               encircle the polygon in positive rotation
% parking_size: The dimensions of a parking slot. The first entry is width,
%               the second is height and the third is need free space in 
%               front of the car
%        index: A boolean indicating whether the slots needs to hold a 
%               distance of parking_size(3) to all sides.
%    rot_index: an index which tells which side to rotate the area on

%% OUTPUT
% points: a list of points which indicates parkingslots. The first and 
%         second entries are the x- and y- coordinates of the center of the 
%         parking-slot, the third entry indicates which angle the parking 
%         slot is rotated, and the fourth indicates which side should be 
%         used to enter the slot

%% CODE

% First rotate the area, and save variables to rotate it back later
[area, displacement, rot_mat, rot_angle] = rotate_area(area, rot_index);

points = []; % variable holding all the parking-slot centers coordinates

% If index, place the first row of slots along the lower side
x_interval = find_x_interval(0, parking_size(2) + parking_size(3), area);

if length(x_interval) == 0
    return;
end

for i = 1:2:length(x_interval)
    
    xmin = x_interval(i);
    xmax = x_interval(i+1);
    point = [xmin, 0] + parking_size(1:2)/2;

    while xmax - point(1) >= 0.5*parking_size(1)
        points = [points; [point, 0, 3]];
        point = point + [parking_size(1), 0];
    end
end


% find the highest y-value which we can place a slot
if index
    ymax = max(area(:, 2));
else
    ymax = max(area(:, 2)) - parking_size(3);
end
tol = 1.0e-2;
% while there is still vertical space, place rows of slots
while ymax - point(2) >= 1.5*parking_size(2) + parking_size(3)
    % move the y-coordinate to the new row
    point(2) = point(2) + parking_size(2) + parking_size(3);
    
    % find the maximum and the minimum x-value where we can place parking
    % slots
    x_interval = find_x_interval(point(2)-parking_size(2)/2 - parking_size(3) + tol, point(2)+parking_size(2)/2 - tol, area);
    %xmin  = find_xmin(point(2)-parking_size(2)/2 - parking_size(3), point(2)+parking_size(2)/2, area);
    
    for i = 1:2:length(x_interval)
        xmin = x_interval(i);
        xmax = x_interval(i+1);

        if ~index
            xmin = xmin + parking_size(3);
        end

        % the first x-coordinate we can place parking-slots on
        point(1) = xmin + parking_size(1)/2;
        
        if i == length(x_interval)-1
            % while there is still horizontal space, place parking-slots in the row
            while xmax - point(1) >= 0.5*parking_size(1)
                points = [points; [point, 180, 3]];
                point = point + [parking_size(1), 0];
            end
        else
            while xmax - point(1) >= 0.5*parking_size(1)
                points = [points; [point, 180, 3]];
                point = point + [parking_size(1), 0];
            end
        end
    end
    
    % check if we can place another row on top of this one
    if ymax - point(2) < 1.5*parking_size(2) + parking_size(3)
        break;
    end
    
    % repeat the same logic to place the new row
    point(2) = point(2) + parking_size(2);
    x_interval = find_x_interval(point(2)-parking_size(2)/2, point(2)+parking_size(2)/2 + parking_size(3), area);
    %xmin  = find_xmin(point(2)-parking_size(2)/2, point(2)+parking_size(2)/2 + parking_size(3), area);
    
    for i = 1:2:length(x_interval)
        xmin = x_interval(i);
        xmax = x_interval(i+1);
        
        if ~index
            xmin = xmin + parking_size(3);
        end

        point(1) = xmin + parking_size(1)/2;
        while xmax - point(1) >= 0.5*parking_size(1)
            points = [points; [point, 0, 3]];
            point = point + [parking_size(1), 0];
        end
    end
end

% if we have more room, place parallel-parking spaces
% if index
%     if ymax - point(2) >= parking_size(1) + 0.5*parking_size(2) + parking_size(3)
%         point(2) = point(2) + parking_size(1)/2 + parking_size(2)/2 + parking_size(3);
%         xmax = find_xmax(point(2)-parking_size(1)/2 - parking_size(3), point(2)+parking_size(1)/2, area);
%         xmin  = find_xmin(point(2)-parking_size(1)/2 - parking_size(3), point(2)+parking_size(1)/2, area);
%         point(1) = xmin + parking_size(2)/2;
%         while xmax - point(1) >= parking_size(2)/2
%             points = [points; [point, 90, 4]];
%             point = point + [parking_size(2), 0];
%         end
%     end
% end

% rotate and move the points back to the original area
points(:, 1:2) = points(:, 1:2)*rot_mat^-1;
points(:, 1:2) = points(:, 1:2) + displacement;
points(:, 3) = points(:, 3) + 180*rot_angle/pi;

end