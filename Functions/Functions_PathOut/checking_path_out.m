function [points, X, Y, end_point_out, inx, removed_points] = checking_path_out(area, outedges, points, parking_size, interval)
% Purpose: Check if one can drive out from all parking-slots, or remove the
% slots in the way, if they are can't
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% area: the area which encompasses the parking lot
% outedges: indices indicating which edges in area that leads out of the
% area
% points: the center of placed parking slots
% parking_size: measurements of the parking slots
% interval: the distance between nodes in the grid which will be built

%% OUTPUT
% points: the centers of the final parking slots
% X: the x-coordinates of the final grid
% Y: the y-coordinates of the final grid
% end_point: the coordinates of the end point
% inx: the parking-slots which can get out
% removed_points: the points which have been removed

%% CODE
n = size(area,1);

if isempty(outedges)
    return
end
end_point = [];
for i = 1:length(outedges)
    index = outedges(i);
    if index == n
        j = 1;
    else
        j = index + 1;
    end
    
    r = area(j,:) - area(index,:);
    end_point = [end_point; area(index,:) + [1:49]'*r/50];
    r = r/norm(r,2);
    n = [-r(2), r(1)];
    
end
road_width = 2;

disp('Creating XY...')
[X_start, Y_start] = create_XY(area, interval, road_width);
X = [X_start; points(:,1)];
Y = [Y_start; points(:,2)];

disp('Removing XY...')
[X, Y] = remove_XY(X, Y, parking_size, [(size(X,1) - size(points,1) + 1):size(X,1)], points(:,3), road_width);

disp('Creating edges...')
edges_init = create_edges_path_out(X, Y, interval, end_point, road_width);
if max(edges_init(:, 2)) <= size(X, 1)
    for i = 1:length(outedges)
        index = outedges(i);
        if index == n
            j = 1;
        else
            j = index + 1;
        end
        r = area(j,:) - area(index,:);
        r = r/norm(r,2);
        n = [-r(2), r(1)];
        corner_points = [area(index,:); area(j,:); area(j,:)+parking_size(3)*n; area(index,:)+parking_size(3)*n];
        
        IN = inpolygon(points(:,1), points(:,2), corner_points(:,1), corner_points(:,2));
        
        keep = logical(ones(size(IN, 1), 1) - IN);
        points = points(keep, :);
    end
    disp('Creating XY...')
    [X_start, Y_start] = create_XY(area, interval, road_width);
    X = [X_start; points(:,1)];
    Y = [Y_start; points(:,2)];

    disp('Removing XY...')
    [X, Y] = remove_XY(X, Y, parking_size, [(size(X,1) - size(points,1) + 1):size(X,1)], points(:,3), road_width);

    disp('Creating edges...')
    edges_init = create_edges_path_out(X, Y, interval, end_point, road_width);
end

disp('Picking first points...')
first_point = pick_first_point(X, Y, points, parking_size);
if size(first_point, 1) ~= size(points, 1)
    disp('Not all point can get a first point!!')
    inx = [];
    removed_points = [];
    end_point_out = [];
    return
end

disp('Using DFS...')
can_get_out = [];
[inx, can_get_out_before, cant_get_out_before] = depth_first_init(first_point, end_point, X, Y, edges_init, [], []);

[edges, new_edges] = create_edges_first_point(X, Y, edges_init, first_point, end_point);

edges = create_edges_combine_slots(X, Y, edges, points, inx, first_point, end_point);

[inx_new, ~, ~] = depth_first_init(first_point, end_point, X, Y, edges, [], []);

test_counter = 1;
removed_points = [];

while true && test_counter < 150
    
    disp('Finding what to remove')
    path = [];
    counter = 1;
    while isempty(path) && counter < 8
        disp(['Try number: ', num2str(counter)])
        [path, edges, X_out, Y_out, points_out, first_point_out, can_get_out_before_out, cant_get_out_before_out] = find_what_to_remove(first_point, end_point, X, Y, points, inx, inx_new, parking_size, area, interval, edges_init, counter, can_get_out_before, cant_get_out_before, road_width);
        counter = counter+1;
    end
    
    if isempty(path)
        disp('Cant make it better now')
        inx = [];
        break
    end
    
    removed_points = [removed_points; points(path, :), path'];
    X = X_out;
    Y = Y_out;
    points = points_out;
    first_point = first_point_out;
    edges_init = edges;
    can_get_out_before = can_get_out_before_out;
    cant_get_out_before = cant_get_out_before_out;
    
    
    inx = inx_new;

    [inx, can_get_out_before, cant_get_out_before] = depth_first_init(first_point, end_point, X, Y, edges, can_get_out_before, cant_get_out_before);
    
    if sum(inx) == size(inx,1)
        disp('Everything can come out now')
        break
    end
    
    disp([num2str(sum(inx)), ' / ' num2str(size(inx,1)), ' can get out now...'])
    
    [edges, new_edges] = create_edges_first_point(X, Y, edges, first_point, end_point);

    edges = create_edges_combine_slots(X, Y, edges, points, inx, first_point, end_point);

    [inx_new, ~, ~] = depth_first_init(first_point, end_point, X, Y, edges, [], []);
    
    
    test_counter = test_counter + 1;
end

%% Make sure that all slots can access each other
end_point_out = end_point;
end_point = first_point(1, 1:2);
disp('Creating edges...')
edges_init = create_edges_path_out(X, Y, interval, end_point, road_width);

disp('Using DFS...')
can_get_out = [];
[inx, can_get_out_before, cant_get_out_before] = depth_first_init(first_point, end_point, X, Y, edges_init, [], []);

[edges, new_edges] = create_edges_first_point(X, Y, edges_init, first_point, end_point);

edges = create_edges_combine_slots(X, Y, edges, points, inx, first_point, end_point);

[inx_new, ~, ~] = depth_first_init(first_point, end_point, X, Y, edges, [], []);

test_counter = 1;

while true && test_counter < 150
    
    disp('Finding what to remove')
    path = [];
    counter = 1;
    while isempty(path) && counter <= 10
        disp(['Try number: ', num2str(counter)])

        [path, edges, X_out, Y_out, points_out, first_point_out, can_get_out_before_out, cant_get_out_before_out] = find_what_to_remove(first_point, end_point, X, Y, points, inx, inx_new, parking_size, area, interval, edges_init, counter, can_get_out_before, cant_get_out_before, road_width);
        counter = counter+1;
    end
    
    if isempty(path)
        disp('Cant make it better now')
        inx = [];
        return
    end
    
    removed_points = [removed_points; points(path, :), path'];
    X = X_out;
    Y = Y_out;
    points = points_out;
    first_point = first_point_out;
    edges_init = edges;
    can_get_out_before = can_get_out_before_out;
    cant_get_out_before = cant_get_out_before_out;
    
    
    inx = inx_new;

    [inx, can_get_out_before, cant_get_out_before] = depth_first_init(first_point, end_point, X, Y, edges, can_get_out_before, cant_get_out_before);
    
    if sum(inx) == size(inx,1)
        disp('Everything can come out now')
        return
    end
    
    disp([num2str(sum(inx)), ' / ' num2str(size(inx,1)), ' can get out now...'])
    
    [edges, new_edges] = create_edges_first_point(X, Y, edges, first_point, end_point);

    edges = create_edges_combine_slots(X, Y, edges, points, inx, first_point, end_point);

    [inx_new, ~, ~] = depth_first_init(first_point, end_point, X, Y, edges, [], []);
    
    
    test_counter = test_counter + 1;
end


end