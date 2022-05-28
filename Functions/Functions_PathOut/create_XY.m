function [X, Y] = create_XY(area, interval, road_width)
% Purpose: Create nodes with X and Y coordinates, such that all nodes are
% within the area
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% area: the area in which we have placed parking slots
% interval: the distance between nodes in the grid
% road_width: the width of the road

%% OUTPUT
% X: A vector containing the X-coordinates of the nodes
% Y: A vector containing the Y-coordinates of the nodes
% nodes: The nodes in the graph, sorted in the same way as X and Y

%% DESCRIPTION
% First we consider the area as a square, an place as many nodes as
% possible. Then we remove all nodes which are outside of area

%% CODE

% Find the min and max values for x and y, such that we have a square
xmin = min(area(:, 1));
xmax = max(area(:, 1));
ymin = min(area(:, 2));
ymax = max(area(:, 2));

% Create the square
[X, Y] = meshgrid(xmin:interval:xmax, ymin:interval:ymax);

X = X(:);
Y = Y(:);

n = length(X);

% Find small area
area_temp = area;
for i=1:size(area, 1)
    if i == size(area, 1)
        j = 1;
        k = 2;
    elseif i == size(area, 1)-1
        j = i+1;
        k = 1;
    else
        j = i + 1;
        k = i + 2;
    end
    
    dir_1 = area(j, :) - area(i, :);
    dir_2 = area(k, :) - area(j, :);
    dir_1 = dir_1/norm(dir_1);
    dir_2 = dir_2/norm(dir_2);
    
    point_1 = area(i, :) + road_width*[-dir_1(2), dir_1(1)];
    point_2 = area(k, :) + road_width*[-dir_2(2), dir_2(1)];
    
    t = [dir_1', -dir_2']\(point_2 - point_1)';
    area_temp(j, :) = t(1)*dir_1 + point_1;
end

% Loop over all points, and check if they are within the area
indices_to_keep = inpolygon(X, Y, area_temp(:,1), area_temp(:,2));

% Only keep the nodes within the area
X = X(logical(indices_to_keep));
Y = Y(logical(indices_to_keep));

end