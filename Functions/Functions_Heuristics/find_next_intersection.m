function crossing_point = find_next_intersection(area, dir_vec, index_to_skip, point)
% Purpose: Find the intersection between the line originating in point,
%          along the direction vector, and the area.
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
%          area: A list of points determining a polygon
%       dir_vec: A direction vector for the current side
% index_to_skip: The index of the current side
%         point: The point at which the line originates

%% OUTPUT
% crossing_point: The intersection between the line and the polygon

%% CODE

n = size(area, 1);
crossing_point = [0, 0];

% Loop over each point of area
for i=1:n
    if i == index_to_skip
        continue;
    end
    
    % j is the index of the next point
    if i==n
        j = 1;
    else
        j = i+1;
    end
    
    new_dir_vec = area(j, :) - area(i, :);
    A = [dir_vec', -new_dir_vec'];
    % check if A is well conditioned. If not, this side is close to
    % parallel to the line, so we ignore it
    if cond(A) < 1e10
        t = A\(area(i, :) - point)';
        if 0 <= t(2) && t(2) <= 1 && t(1) >= 0
            crossing_point = t(2)*new_dir_vec + area(i, :);
        end
    end
end


end

