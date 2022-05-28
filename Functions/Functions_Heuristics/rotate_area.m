function [area_out, displacement, rot_mat, rot_angle] = rotate_area(area, rot_index)
% Purpose: Rotate the area, such that the longest side lays on the x-axis,
%          starting in origo
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
%      area: A list of points determining a polygon. The points must 
%            encircle the polygon in positive rotation
% rot_index: if 0, rotate around the longest side, else rotate around the
%            side given by this index

%% OUTPUT
%     area_out: The new, transformed area
% displacement: A vector indicating how the area have been moved
%               translationally
%      rot_mat: The matrix which is used to rotate the area
%    rot_angle: The angle which the area is rotated by

%% CODE
n = size(area, 1);

if rot_index == 0
    bottom_side = norm(area(1, :) - area(end, :)); % the current length of the longest side found
    index = n; % the index of the first point in the longest side
    side = area(1, :) - area(end, :); % a vector parallel to the longest side

    % Loop over all sides
    for i=1:n-1
        % If the side is longer than the previous longest side, update all the
        % variables
        if norm(area(i, :) - area(i+1, :)) > bottom_side
            bottom_side = norm(area(i, :) - area(i+1, :));
            index = i;
            side = area(i+1, :) - area(i, :);
        end
    end
else
    % rotate by the side given by rot_index
    index = rot_index;
    if index == n
        j = 1;
    else
        j = index + 1;
    end
    side = area(j, :) - area(index, :);
    bottom_side = norm(side, 2);
end

displacement = area(index, :); % the vector which we displace the entire area by translationally
area = area - displacement;
angle = acos([1, 0]*side'/bottom_side); % the angle between the side and the x-axis

% acos only gives value between 0 and 180, so we also need to detect
% negative angles
if side(2) < 0
    angle = -angle;
end

rot_mat = [cos(angle), -sin(angle); sin(angle), cos(angle)];
rot_angle = angle; % save the rotation angle

% reorder area, such that the first point now is in (0, 0)
area_out = area*rot_mat; % rotate area
area_out = [area_out(index:end, :); area_out(1:index-1, :)];
area_out(2,2) = 0; % ensure that this is exactly zero and not just approx zero!

end