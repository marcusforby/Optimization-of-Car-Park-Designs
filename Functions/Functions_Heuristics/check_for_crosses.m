function new_area = check_for_crosses(area)
% Purpose: Check if the sides of the polygon crosses each other, and if
% they do, return a new polygon without crossing sides
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% area: A list of points determining a polygon. The points must encircle
% the polygon in positive rotation

%% OUTPUT
% new_area: A polygon where no sides crosses each other

%% CODE
n = size(area, 1);

% if we have a triangular domain, return
if n == 3
    new_area = [];
    return;
end

% a vector containing all the points where the sides crosses each other
cross_points = zeros(n, 2);

% a vector which indicates if a point is positioned outside the polygon
cross_indices = zeros(1, n);


for i = 1:n
    % find out which points we need to look at
    if i == n-2
        j = n-1;
        h = n;
        k = 1;
    elseif i == n-1
        j = n;
        h = 1;
        k = 2;
    elseif i == n
        j = 1;
        h = 2;
        k = 3;
    else
        j = i+1;
        h = i+2;
        k = i+3;
    end
    
    % Identify the lines which might intersect, and some points on the
    % lines, which we need later
    line1 = area(j, :) - area(i, :);
    point1 = area(i, :);
    pointj = area(j, :);
    line2 = area(k, :) - area(h, :);
    point2 = area(h, :);
    
    % find the crossing point
    t = [line1', -line2']\(point2-point1)';
    cross_point = t(1)*line1 + point1;

    % first we check if the first line move in a negative or positive
    % direction along the x-axis
    if point1(1) > pointj(1)
        % check if the crossing point's x-coordinate is between the
        % x-coordinates of the endpoints of the side
        if cross_point(1) < point1(1) && cross_point(1) > pointj(1)
            % mark the points that need to be removed, and remember the
            % crossing points coordinates
            cross_indices(j) = 1;
            cross_indices(h) = 1;
            cross_points(j, :) = cross_point;
            cross_points(h, :) = cross_point;
        end
    else
        % check if the crossing point's x-coordinate is between the
        % x-coordinates of the endpoints of the side
        if cross_point(1) > point1(1) && cross_point(1) < pointj(1)
            % mark the points that need to be removed, and remember the
            % crossing points coordinates
            cross_indices(j) = 1;
            cross_indices(h) = 1;
            cross_points(j, :) = cross_point;
            cross_points(h, :) = cross_point;
        end
    end
end

new_area = [];

correction_cross_points = [];
for i=1:n
    if i == n
        j = 1;
    else
        j = i+1;
    end
    
    if cross_indices(i) == 1 && cross_indices(j) == 1
        new_area = [new_area; cross_points(i, :)]; 
        correction_cross_points = [correction_cross_points; j, cross_points(i, :)];
    else
        new_area = [new_area; area(i, :)];
    end
end

for i = 1:size(correction_cross_points,1)
    index = correction_cross_points(i,1);
    new_area(index,:) = correction_cross_points(i,2:3);
    if index == 1
        new_area(end,:) = [];
    end
end

new_new_area = [];
point = [inf, inf];
for i = 1:size(new_area)
    if point(1) ~= new_area(i, 1) || point(2) ~= new_area(i, 2)
        new_new_area = [new_new_area; new_area(i, :)];
    end
    point = new_area(i, :);
end
new_area = new_new_area;

end