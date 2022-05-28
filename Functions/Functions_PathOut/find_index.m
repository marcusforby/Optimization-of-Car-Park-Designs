function index = find_index(inx, inx_new, index_shifter, points, parking_size)
% Purpose: find the indices of parking slots to remove
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% inx: the old slots which can get out
% inx_new: the old and new slots which can get out
% index_shifter: integer indicating which algorithm to use
% points: the centers of the parking lots
% parking_size: the dimension of the parking slots

%% OUTPUT
% index: a list of the indices to be removed

%% CODE

if index_shifter == 1
    disp('1 different point')
    % Try points that can get out in inx_new but not in inx
    inx_different = xor(inx, inx_new);
    index = find(inx_different == 1);
elseif index_shifter == 2
    disp('1 old point')
    % Try points that can get out in inx
    inx_different = inx;
    index = find(inx_different == 1);
elseif index_shifter == 3
    disp('2 different points')
    % Try 2 points that can get out in inx_new but not in inx
    inx_different = xor(inx, inx_new);
    
    n_inx = size(inx_different,1);
    index = zeros(n_inx, 2);
    count = 1;
    
    for i = 1:n_inx-1
        if sum(inx_different(i:i+1, 1)) == 2
           index(count, :) = [i:i+1]; 
           count = count + 1;
        end
    end
    index = index(1:count-1, :);
elseif index_shifter == 4
    disp('1 different point and 1 old point')
    % Try one point that can get out in inx_new but not in inx with a point
    % that can get out in inx
    
    inx_different = xor(inx, inx_new);
    
    n_inx = size(inx,1);
    index = zeros(n_inx, 2);
    count = 1;
    
    for i = 1:n_inx
        for j = 1:n_inx
            if i ~= j
                if inx(i) == 1 && inx_different(j) == 1 
                    if norm(points(i,1:2)-points(j,1:2), 2) < sum(parking_size) || abs(i-j) == 1
                        index(count, :) = [i, j];
                        count = count + 1;
                    end
                end
            end
        end
    end
    index = index(1:count-1, :);
elseif index_shifter == 5
    disp('2 different points and 1 old point')
    % Try 2 points that can get out in inx_new but not in inx with a point
    % that can get out in inx
    
    inx_different = xor(inx, inx_new);
    n_inx = size(inx,1);
    index = zeros(n_inx, 3);
    count = 1;
    
    for i = 1:n_inx-1
        for j = 1:n_inx
            if i ~= j && i+1 ~= j
                if sum(inx_different(i:i+1)) == 2 && inx(j) == 1
                    if norm(points(i,1:2)-points(j,1:2), 2) < sum(parking_size) || j == i-1 || j == i+2
                        index(count, :) = [i, i+1, j];
                        count = count + 1;
                    end
                end
            end
        end
    end
    index = index(1:count-1, :);
    
elseif index_shifter == 6
    disp('2 old points')
    % Try 2 points that can get out in inx
    n_inx = size(inx,1);
    index = zeros(n_inx, 2);
    count = 1;
    for i = 1:n_inx-1
        if sum(inx(i:i+1, 1)) == 2
           index(count, :) = [i:i+1]; 
           count = count + 1;
        end
    end
    index = index(1:count-1, :);

elseif index_shifter == 7
    disp('1 different point and 2 old points')
    % Try one points that can get out in inx_new but not in inx with 2
    % points that can get out in inx
    
    inx_different = xor(inx, inx_new);
    n_inx = size(inx,1);
    index = zeros(n_inx, 3);
    count = 1;
    
    for i = 1:n_inx
        for j = 1:n_inx-1
            if i ~= j && i ~= j+1
                if inx_different(i) == 1 && sum(inx(j:j+1)) == 2
                    if norm(points(i,1:2)-points(j,1:2), 2) < sum(parking_size) || i == j-1 || i == j+2
                        index(count, :) = [i, j, j+1];
                        count = count + 1;
                    end
                end
            end
        end
    end
    index = index(1:count-1, :);
    
elseif index_shifter == 8
    disp('3 different points')
    % Try 3 points that can get out in inx_new but not in inx
    
    inx_different = xor(inx, inx_new);
    
    n_inx = size(inx_different,1);
    index = zeros(n_inx, 3);
    count = 1;
    for i = 1:n_inx-2
        if sum(inx_different(i:i+2, 1)) == 3
           index(count, :) = [i:i+2]; 
           count = count + 1;
        end
    end
    
    index1 = index(1:floor(count/2), :);
    index2 = index([count-1:-1:floor(count/2)+1], :);
    
    count1 = 1;
    count2 = 1;
    index = zeros(count-1, 3);
    
    for i = 1:count-1
        if mod(i,2) == 1
            index(i,:) = index1(count1,:);
            count1 = count1 + 1;
        else
            index(i,:) = index2(count2,:);
            count2 = count2 + 1;
        end
    end
elseif index_shifter == 9
    disp('3 old points')
    % Try 3 points that can get out in inx
    n_inx = size(inx,1);
    index = zeros(n_inx, 3);
    
    count = 1;
    for i = 1:n_inx-2
        if sum(inx(i:i+2, 1)) == 3
           index(count, :) = [i:i+2]; 
           count = count + 1;
        end
    end
    
    index1 = index(1:floor(count/2), :);
    index2 = index([count-1:-1:floor(count/2)+1], :);
    
    count1 = 1;
    count2 = 1;
    index = zeros(count-1, 3);
    
    for i = 1:count-1
        if mod(i,2) == 1
            index(i,:) = index1(count1,:);
            count1 = count1 + 1;
        else
            index(i,:) = index2(count2,:);
            count2 = count2 + 1;
        end
    end
elseif index_shifter == 10
    disp('2 different point and 2 old points')
    % Try one points that can get out in inx_new but not in inx with 2
    % points that can get out in inx
    
    inx_different = xor(inx, inx_new);
    n_inx = size(inx,1);
    index = zeros(n_inx, 4);
    count = 1;
    
    for i = 1:n_inx-1
        for j = 1:n_inx-1
            if i ~= j && i ~= j+1 && i+1 ~= j
                if sum(inx_different(i:i+1)) == 2 && sum(inx(j:j+1)) == 2
                    if norm(points(i,1:2)-points(j,1:2), 2) < sum(parking_size) || i == j-1 || i == j+2
                        index(count, :) = [i, i+1, j, j+1];
                        count = count + 1;
                    end
                end
            end
        end
    end
    index = index(1:count-1, :);
else
    disp('Wrong definition')
    return
end




end