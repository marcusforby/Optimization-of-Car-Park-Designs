function in_area = check_if_in_area(area, point, parking_size)
% Purpose: Check if point is in area
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
%  area: A list of points determining a polygon. The points must encircle
%        the polygon in positive rotation
% point: A point (x,y) of which we check is inside of area
%     w: the width of the parking slot
%     h: the high of the parking slot
%     f: the free space in front of the car

%% OUTPUT
% in_area: in_area = 1 if point is in area, 0 otherwise

%% CODE
m = size(area, 1);

w = parking_size(1);
h = parking_size(2);
f = parking_size(3);

parking_size = [w, h];
rot_mat = [cos(point(3)/180*pi), -sin(point(3)/180*pi); sin(point(3)/180*pi), cos(point(3)/180*pi)];

% first build the parking slot around (0, 0)
all_points = [-parking_size'/2, [1;-1].*parking_size'/2, parking_size'/2, [-1;1].*parking_size'/2, (parking_size'/2+[0; f]), [-1;1].*(parking_size'/2+[0; f])];

% now rotate all the points, and then move it to the real center of the
% parking slot
all_points = rot_mat*all_points + point(1:2)';
all_points = [all_points'; point(1:2)];
all_points(1:2, :) = all_points(1:2, :) + 1.0e-10;
other_points = [all_points([1,2,5,6], :)];


IN = inpolygon(area(:,1), area(:,2), other_points(:,1), other_points(:,2));
if sum(IN) >= 1
    in_area = 0;
    return;
end 

IN = inpolygon(all_points(:,1), all_points(:,2), area(:,1), area(:,2));

if sum(IN) == length(IN)
    in_area = 1;
else
    in_area = 0;
end

end