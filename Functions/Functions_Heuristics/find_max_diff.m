function max_diff = find_max_diff(rot_matrix, corner_points, area, point)
% Purpose: finds max diff from point and into the area
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
%    rot_matrix: a rot maxtrix depending on the angle of the parking slot
% corner_points: a list of all points around (0,0) that needs to be inside area
%          area: A list of points determining a polygon
%         point: The centers of the next parking-slot which we try to place


%% OUTPUT
% max_diff: The maximal distance we need to move point in the x-direction

%% CODE
max_diff = 0;

all_points = rot_matrix*corner_points + point';

IN = inpolygon(all_points(1,:), all_points(2,:), area(:,1), area(:,2));
if sum(IN) ~= size(all_points, 2)
    for j = 1:length(IN)
        if IN(j) == 0
            min_diff = inf;
            for k=2:size(area,1)
                if k == size(area,1)
                    p = 1;
                else
                    p = k + 1;
                end
                if abs(area(p, 2)-area(k, 2)) >= 1e-4
                    t = [[1; 0], (area(p, :)-area(k, :))']\(area(p, :)' - all_points(:, j));
                    if t(2) >= 0 && t(2) <= 1
                        if min_diff > abs(t(1))
                            min_diff = abs(t(1));
                        end
                    end
                end
            end
            if max_diff < min_diff
                max_diff = min_diff;
            end
        end

    end
end
IN = inpolygon(area(:,1), area(:,2), all_points(1,:), all_points(2,:));
if sum(IN) >= 1
    for j = 1:length(IN)
        if IN(j) == 1
            min_diff = inf;

            t = [[1; 0], (all_points(:, 4) - all_points(:, 2))]\(all_points(:, 4)' - area(j, :))';
            if t(2) >= 0 && t(2) <= 1
                if min_diff > abs(t(1))
                    min_diff = abs(t(1));
                end
            end
            t = [[1; 0], (all_points(:, 5) - all_points(:, 4))]\(all_points(:, 5)' - area(j, :))';
            if t(2) >= 0 && t(2) <= 1
                if min_diff > abs(t(1))
                    min_diff = abs(t(1));
                end
            end

            if max_diff < min_diff
                max_diff = min_diff + 1e-4;
            end
        end

    end
end
