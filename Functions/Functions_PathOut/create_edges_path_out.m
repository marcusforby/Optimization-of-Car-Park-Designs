function edges = create_edges_path_out(X, Y, interval, end_point, road_width)
% Purpose: Create edges between nodes with higher index, which are situated
% within a certain interval
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% X: the x-coordinates of the grid
% Y: the y-coordinates of the grid
% interval: the center of placed parking slots
% end_point: the points which we can exit the lot from
% road_width: the width of the road in the parking slots

%% OUTPUT
% edges: all current edges

%% CODE
n = size(X, 1);
m = size(end_point, 1);

% Preallocate space for the edges to and from coordinates. Notice that we
% use two vectors instead of a matrix, because this is magically much
% faster.
edgesFrom = zeros((n+m)*4, 1);
edgesTo = zeros((n+m)*4, 1);

count = 1;

% Loop over all nodes (except the last)
for i=1:n
    % Look over all nodes, with higher index
    for j=1:n
        if i ~= j
            
            % if the horizontal distance is greater than a parking space width,
            % and the vertical distance is greater than h + f, we can add an
            % edge between i and j.
            if abs(X(i) - X(j)) - interval < 1.0e-4 && abs(Y(i) - Y(j)) < 1.0e-4
                edgesFrom(count) = i;
                edgesTo(count) = j;
                count = count + 1;
            elseif abs(Y(i) - Y(j)) - interval < 1.0e-4 && abs(X(i) - X(j)) < 1.0e-4
                edgesFrom(count) = i;
                edgesTo(count) = j;
                count = count + 1;
            end
        end
        
        
    end
    for k = 1:m
        if norm([X(i), Y(i)] - end_point(k,:), 2) <= road_width + 0.5
            edgesFrom(count) = i;
            edgesTo(count) = n+k;
            count = count + 1;
        end
    end
end

% Remove edges not used
edgesFrom = edgesFrom(1:count-1, :);
edgesTo = edgesTo(1:count-1, :);

% Merge the two vectors into one matrix, before returning
edges = [edgesFrom, edgesTo];

end
