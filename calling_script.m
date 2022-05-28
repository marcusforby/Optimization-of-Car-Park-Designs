function struct = calling_script(area, parking_size, algoritms_index, angle_interval, path_out_index, out_edges, interval)

if isempty(algoritms_index) || sum((1 <= algoritms_index) & (algoritms_index <= 4)) == 0
    disp('Please define algorithm type')
    disp('1: straight parking spaces')
    disp('2: straight parking spaces in different angles')
    disp('3: straight parking spaces in different angles using a special first side')
    disp('4: boundary parking spaces')
    struct = [];
    return 
end

if sum(algoritms_index==2) + sum(algoritms_index==3) >= 1 
    if isempty(angle_interval) || ~isnumeric(angle_interval) || angle_interval == 0
        disp('Please define angle interval between 1 and 90')
        struct = [];
        return 
    end
end

n = size(area,1);

if isempty(path_out_index)
    path_out_index = 0;
end

if ~isnumeric(path_out_index) || path_out_index < 0 || path_out_index > 3 || (floor(path_out_index) ~= path_out_index)
    disp('Please define path out index between 0 and 3')
    disp('0: no use of path out method')
    disp('1: use path out method on best solution')
    disp('2: use path out method on all best solutions')
    disp('3: use path out method on all solutions')
    return
elseif path_out_index > 0
    if max(interval) < 0 || isempty(interval) || min(interval) < 0 || length(interval) > 1
        disp('Please define one interval larger than 0')
        struct = [];
        return
    end
    if max(out_edges) > n || isempty(out_edges) || min(out_edges) < 1
        disp(['Please define an outedge between 1 and ', num2str(n)])
        struct = [];
        return
    end
end

index = [];
tic;

%% Algorithm 1 is straight parking spaces
if sum(algoritms_index == 1) >= 1
    t = toc;
    disp('Placing straight parking spaces...')
    
    points_max = [];
    for i = 1:n
        disp(['Looking at side: ', num2str(i)])
        points_temp = heuristic_polygon_straight(area, parking_size, 1, i);
        
        if path_out_index == 3
            [points, X, Y, end_point, index, removed_points] = checking_path_out(area, out_edges, points_temp, parking_size, interval);
        else
            points = points_temp;
        end
        
        if size(points,1) > size(points_max,1) && ~(isempty(index) && path_out_index == 3)
           points_max = points;
           i_max = i;
           if path_out_index == 3
               struct.algorithm1.point_before_path_out = points_temp;
               struct.algorithm1.X = X;
               struct.algorithm1.Y = Y;
               struct.algorithm1.end_point = end_point;
               struct.algorithm1.removed_points = removed_points;
           end
           for k = 1:size(points,1)
               point_i = points(k,:);
               for j = k+1:size(points,1)
                   point_j = points(j,:);
                    if norm(point_i-point_j) < 0.1
                        disp('*******************************************')
                        disp('POINTS ARE PLACED DOUBLE!!!')
                        disp([i,j])
                        disp('*******************************************')
                    end
               end
            end
        end
    end
    
    disp('The best straight solution was with:')
    disp(['side = ', num2str(i_max)])
    disp(['n = ', num2str(size(points_max,1))])
    disp(' ')

    struct.algorithm1.time = toc - t;

    fileID = fopen([cd, '/Outputs/var_algorithm1.txt'],'w');
    fprintf(fileID, 'The best straight solution was with: \n');
    fprintf(fileID, ['side = ', num2str(i_max), '\n']);
    fprintf(fileID, ['n = ', num2str(size(points_max,1)), '\n']);
    fprintf(fileID, ['total time = ', num2str(struct.algorithm1.time), '\n']);
    fclose(fileID);
    
    if path_out_index == 2
        struct.algorithm1.point_before_path_out = points_max;
        disp('Using path out method on best solution...')
        [points_max, X, Y, end_point, ~, removed_points] = checking_path_out(area, out_edges, points_max, parking_size, interval);
        disp(['Removed ', num2str(size(removed_points,1), 1), ' parking slots.'])
        struct.algorithm1.X = X;
        struct.algorithm1.Y = Y;
        struct.algorithm1.end_point = end_point;
        struct.algorithm1.removed_points = removed_points;
    end
    
    struct.algorithm1.points_max = points_max;
    struct.algorithm1.i_max = i_max;
end


%% Algorithm 2 is straight parking spaces in different angles
if sum(algoritms_index == 2) >= 1
    t = toc;
    disp('Placing straight parking spaces with different angles...')
    
    parking_size_temp = parking_size;
    angles = 90 - [0, 30, 45, 60, 75, 90, 105, 120, 135, 150, 180];
    free_space = [2.5, 2.5, 3.2, 4.2, 5.5, 7, 5.5, 4.2, 3.2, 2.5, 2.5];
    
    max_angle = 45;
    
    points_max = [];
    for i = 1:n
        disp(['Looking at side: ', num2str(i)])
        for angle = -max_angle:angle_interval:max_angle
            parking_size_temp(3) = interp1(angles, free_space, angle);
            points = heuristic_polygon_angled(area, parking_size_temp, angle, i, []);
            
            if path_out_index == 3
                [points, X, Y, end_point, index, removed_points] = checking_path_out(area, out_edges, points, parking_size_temp, interval);
            end

            if size(points,1) > size(points_max,1) && ~(isempty(index) && path_out_index == 3)
               points_max = points;
               angle_max = angle;
               i_max = i;
               if path_out_index == 3
                   struct.algorithm2.X = X;
                   struct.algorithm2.Y = Y;
                   struct.algorithm2.end_point = end_point;
                   struct.algorithm2.removed_points = removed_points;
               end
               for k = 1:size(points,1)
                   point_i = points(k,:);
                   for j = k+1:size(points,1)
                       point_j = points(j,:);
                        if norm(point_i-point_j) < 0.1
                            disp('*******************************************')
                            disp('POINTS ARE PLACED DOUBLE!!!')
                            disp([i,j])
                            disp('*******************************************')
                        end
                   end
                end
            end
        end
    end
    
    disp('The best angled solution was with:')
    disp(['angle = ', num2str(angle_max)])
    disp(['side = ', num2str(i_max)])
    disp(['n = ', num2str(size(points_max,1))])
    disp(' ')
    struct.algorithm2.time = toc - t;

    fileID = fopen([cd, '/Outputs/var_algorithm2.txt'],'w');
    fprintf(fileID, 'The best angled solution was with: \n');
    fprintf(fileID, ['angle = ', num2str(angle_max), '\n']);
    fprintf(fileID, ['side = ', num2str(i_max), '\n']);
    fprintf(fileID, ['n = ', num2str(size(points_max,1)), '\n']);
    fprintf(fileID, ['total time = ', num2str(struct.algorithm2.time), '\n']);
    fclose(fileID);
    
    if path_out_index == 2
        struct.algorithm2.point_before_path_out = points_max; 
        disp('Using path out method on best solution...')
        
        [points_max, X, Y, end_point, ~, removed_points] = checking_path_out(area, out_edges, points_max, parking_size, interval);
        disp(['Removed ', num2str(size(removed_points,1), 1), ' parking slots.'])
        
        struct.algorithm2.X = X;
        struct.algorithm2.Y = Y;
        struct.algorithm2.end_point = end_point;
        struct.algorithm2.removed_points = removed_points;
    end
    
    struct.algorithm2.points_max = points_max;
    struct.algorithm2.i_max = i_max;
    struct.algorithm2.angle_max = angle_max;
end

%% Algorithm 3 is straight parking spaces in different angles using special first side
if sum(algoritms_index == 3) >= 1
    t = toc;
    disp('Placing straight parking spaces with different angles and first sides...')
    
    parking_size_temp = parking_size;
    parking_size_temp_first_side = parking_size;
    angles = 90 - [0, 30, 45, 60, 75, 90, 105, 120, 135, 150, 180];
    free_space = [2.5, 2.5, 3.2, 4.2, 5.5, 7, 5.5, 4.2, 3.2, 2.5, 2.5];
    
    max_angle = 45;
    points_max = [];
    for i = 1:n
        disp(['Looking at side: ', num2str(i)])
        for angle = -max_angle:angle_interval:max_angle
            parking_size_temp(3) = interp1(angles, free_space, angle);
            for angle_first_side = -max_angle:angle_interval:max_angle
                parking_size_temp_first_side(3) = interp1(angles, free_space, angle_first_side);
                points = heuristic_polygon_angled_first_side(area, parking_size_temp, parking_size_temp_first_side, angle, angle_first_side, i);

                if path_out_index == 3
                    [points, X, Y, end_point, index, removed_points] = checking_path_out(area, out_edges, points, parking_size_temp, interval);
                end

                if size(points,1) > size(points_max,1) && ~(isempty(index) && path_out_index == 3)
                   points_max = points;
                   angle_max = angle;
                   angle_first_side_max = angle_first_side;
                   i_max = i;
                   if path_out_index == 3
                       struct.algorithm3.X = X;
                       struct.algorithm3.Y = Y;
                       struct.algorithm3.end_point = end_point;
                       struct.algorithm3.removed_points = removed_points;
                   end
                   for k = 1:size(points,1)
                       point_i = points(k,:);
                       for j = k+1:size(points,1)
                           point_j = points(j,:);
                           if norm(point_i-point_j) < 0.1
                               disp('*******************************************')
                               disp('POINTS ARE PLACED DOUBLE!!!')
                               disp([i,j])
                               disp('*******************************************')
                           end
                       end
                   end
                end
            end
        end
    end
    
    disp('The best first side angled solution was with:')
    disp(['angle = ', num2str(angle_max)])
    disp(['angle first side = ', num2str(angle_first_side_max)])
    disp(['side = ', num2str(i_max)])
    disp(['n = ', num2str(size(points_max,1))])
    disp(' ')
    
    struct.algorithm3.time = toc - t;

    fileID = fopen([cd, '/Outputs/var_algorithm3.txt'],'w');
    fprintf(fileID, 'The best first side angled solution was with: \n');
    fprintf(fileID, ['angle = ', num2str(angle_max), '\n']);
    fprintf(fileID, ['angle first side = ', num2str(angle_first_side_max), '\n']);
    fprintf(fileID, ['side = ', num2str(i_max), '\n']);
    fprintf(fileID, ['n = ', num2str(size(points_max,1)), '\n']);
    fprintf(fileID, ['total time = ', num2str(struct.algorithm3.time), '\n']);
    fclose(fileID);
    
    if path_out_index == 2
        struct.algorithm3.point_before_path_out = points_max; 
        disp('Using path out method on best solution...')
        
        [points_max, X, Y, end_point, ~, removed_points] = checking_path_out(area, out_edges, points_max, parking_size, interval);
        disp(['Removed ', num2str(size(removed_points,1), 1), ' parking slots.'])
        
        struct.algorithm3.X = X;
        struct.algorithm3.Y = Y;
        struct.algorithm3.end_point = end_point;
        struct.algorithm3.removed_points = removed_points;
    end
    
    struct.algorithm3.points_max = points_max;
    struct.algorithm3.i_max = i_max;
    struct.algorithm3.angle_max = angle_max;
    struct.algorithm3.angle_first_side_max = angle_first_side_max;
end


%% Algorithm 4 is boundary
if sum(algoritms_index == 4) >= 1
    disp('Placing boundary parking slots...')
    N_max = 0;
    points_temp = [];
    new_area = area;

    for i=1:n
        [points, new_area, ~] = heuristic_boundary_single(area, parking_size, 4, 0, i);
        N = size(points, 1);
        if N > N_max
            N_max = N;
            points_temp = points;
        end
    end
    points_max = points_temp;
    
    while size(points_temp, 1) ~= 0
        n = size(new_area, 1);
        points_temp = [];
        for i=1:n
            [~, points_temp, new_area_tmp, ~] = heuristic_boundary_double(new_area, parking_size, 4, 0, i);
            N = size(points, 1);
            if N > N_max
                N_max = N;
                points_temp = points;
            end
        end
        new_area = new_area_tmp;

        points_max = [points_max; points_temp];
    end
    
    disp('The solution for boundary heuristic was:')
    disp(['n = ', num2str(size(points_max,1))])
    disp(' ')
    
    fileID = fopen([cd, '/Outputs/var_algorithm4.txt'],'w');
    fprintf(fileID, 'The solution for boundary heuristic was:\n');
    fprintf(fileID, ['n = ', num2str(size(points_max,1)), '\n']);
    fclose(fileID);
    
    if path_out_index == 2 || path_out_index == 3
        struct.algorithm4.point_before_path_out = points_max;
        disp('Using path out method on best solution...')
        
        [points_max, X, Y, end_point, ~, removed_points] = checking_path_out(area, out_edges, points_max, parking_size, interval);
        disp(['Removed ', num2str(size(removed_points,1), 1), ' parking slots.'])
        
        struct.algorithm4.X = X;
        struct.algorithm4.Y = Y;
        struct.algorithm4.end_point = end_point;
        struct.algorithm4.removed_points = removed_points;
    end
    
    struct.algorithm4.points_max = points_max;
    
end


%% Getting best solution:
inx_max = 0;
for i = 1:length(algoritms_index)
    index = algoritms_index(i);
    if eval(['size(struct.algorithm', num2str(index), '.points_max,1) > inx_max'])
        eval(['inx_max = size(struct.algorithm', num2str(index), '.points_max,1);'])
        inx_best_solution = index;
    end
end

eval(['points_max = struct.algorithm', num2str(inx_best_solution), '.points_max;']);

if path_out_index == 1
    struct.best_solution.point_before_path_out = points_max;
    points_max_old = points_max;    
    disp('Using path out method on best solution...')
    
    [points_max, X, Y, end_point, inx, removed_points] = checking_path_out(area, out_edges, points_max, parking_size, interval);
    disp(['Removed ', num2str(size(removed_points,1), 1), ' parking slots.'])
    
    struct.best_solution.X = X;
    struct.best_solution.Y = Y;
    struct.best_solution.end_point = end_point;
    struct.best_solution.removed_points = removed_points;
    struct.best_solution.points_max = points_max;
end

if length(algoritms_index) > 1
    disp(['The best solution was from algorithm', num2str(inx_best_solution), '.'])
    disp(['n = ', num2str(size(points_max,1))])
    if 1 <= inx_best_solution && inx_best_solution <= 3
        eval(['i_max = struct.algorithm', num2str(inx_best_solution), '.i_max;']);
        disp(['side = ', num2str(i_max)])

        if inx_best_solution >= 2
            eval(['angle_max = struct.algorithm', num2str(inx_best_solution), '.angle_max;']);
            disp(['angle = ', num2str(angle_max)])
            
            if inx_best_solution == 3
                eval(['angle_first_side_max = struct.algorithm', num2str(inx_best_solution), '.angle_first_side_max;']);
                disp(['angle_first_side = ', num2str(angle_first_side_max)])
            end
        end

    end
end