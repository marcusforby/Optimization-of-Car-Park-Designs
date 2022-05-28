function x = find_x_interval(y_low, y_high, area)
% Purpose: Find the highest x-coordinate at which we can place a parking
%          slot within the polygon with given y-coordinates.
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
%  y_low: The lowest y-coordinate at which a parking slot might hit the edge
%         of the polygon
% y_high: The lowest y-coordinate at which a parking slot might hit the
%         edge of the polygon
%   area: A list of points determining a polygon. The points must encircle
%         the polygon in positive rotation

%% OUTPUT
% x: A vector containing x-intervals for which we can place parking slots
%    in

%% CODE

n = size(area, 1);
tol = 1e-4; % a tolerance to counter small numeric errors in the algorithm

x_low = zeros(2, n);
count1 = 0;
x_high = zeros(2, n);
count2 = 0;
x_middle = zeros(2, n);
count3 = 0;

for i=1:n
    if i == n
        j = 1;
    else
        j = i + 1;
    end
    % If a line segment intersects the lower y-coordinate, and it is not a
    % line parallel with the x-axis (within numeric accuracy), interpolate
    % the x-coordinate at the lower y-coordinate
    if area(i, 2) < area(j, 2)
        if (y_low >= area(i, 2) - tol && y_low <= area(j, 2) + tol && abs(area(i, 2) - area(j, 2)) > tol)
%             if area(i,1) <= area(j,1)
%                 x_low(:, count1+1) = [interp1(area([i, j], 2), area([i, j], 1), y_low); i];
%                 count1 = count1 + 1;
%             end
            x_low(:, count1+1) = [interp1(area([i, j], 2), area([i, j], 1), y_low); i];
            if isnan(x_low(1, count1+1))
                x_low(1, count1+1) = interp1(area([i, j], 2), area([i, j], 1), y_low+tol);
            end
            count1 = count1 + 1;
        end
    else
        if (y_low <= area(i, 2) + tol && y_low >= area(j, 2) - tol && abs(area(i, 2) - area(j, 2)) > tol)
%             if area(i,1) <= area(j,1)
%                 x_low(:, count1+1) = [interp1(area([i, j], 2), area([i, j], 1), y_low); i];
%                 count1 = count1 + 1;
%             end
            x_low(:, count1+1) = [interp1(area([i, j], 2), area([i, j], 1), y_low); i];
            count1 = count1 + 1;
        end
    end
    % Do the same as before, just for the higher y-coordinate.
    if area(i, 2) < area(j, 2)
        if (y_high >= area(i, 2) - tol && y_high <= area(j, 2) + tol && abs(area(i, 2) - area(j, 2)) > tol)
            x_high(:, count2+1) = [interp1(area([i, j], 2), area([i, j], 1), y_high); i];
            count2 = count2 + 1;
        end
    else
        if (y_high <= area(i, 2) + tol && y_high >= area(j, 2) - tol && abs(area(i, 2) - area(j, 2)) > tol)
            x_high(:, count2+1) = [interp1(area([i, j], 2), area([i, j], 1), y_high); i];
            count2 = count2 + 1;
        end
    end
    
    if area(j,2) < y_high && area(j,2) > y_low 
        if abs(area(i,2) - area(j,2)) > tol
            x_middle(:, count3+1) = [area(j, 1); i];
            count3 = count3 + 1;
        end
    end
end

% if count1 == 0 || count2 == 0
%     disp('Something is wrong')
% end

x_middle = x_middle(:, 1:count3);

x_low = x_low(:, 1:count1);
[~,inx]=sort(x_low(1,:));
x_low = x_low(:,inx);

x_high = x_high(:, 1:count2);
[~,inx]=sort(x_high(1,:));
x_high = x_high(:,inx);

% x_maxs = [];
% for i = 1:count1
%     index_low = x_low(2, i);
%     for j = 1:count2
%         index_high = x_high(2, j);
%         if index_low == index_high
%             x_maxs = [x_maxs, min(x_low(1, i), x_high(1, j))];
%         end
%     end
% end

all_x = unique(sort([x_middle(1,:), x_low(1,:), x_high(1,:)]));

x = [];
n_test = length(all_x);
index_buttom = 1;
index_top = 2;
y_vals = linspace(y_low+1e-2, y_high-1e-2, 1500);
insertion = 0;
while index_buttom < n_test && index_top <= n_test
    x_vals = ((all_x(index_top) - all_x(index_top-1))/2 + all_x(index_top-1)) * ones(1500, 1);
    
    if sum(inpolygon(x_vals, y_vals, area(:,1), area(:,2))) == 1500
        index_top = index_top + 1;
        insertion = 1;
    elseif insertion == 1
        x = [x, all_x(index_buttom), all_x(index_top-1)];
        index_buttom = index_top;
        index_top = index_top + 1;
        insertion = 0;
    else
        index_buttom = index_buttom + 1;
        index_top = index_top + 1;
    end
end

if insertion == 1
    x = [x, all_x(index_buttom), all_x(index_top-1)];
end



%x = unique(sort([x_middle(1,:), x_low(1,:), x_high(1,:)]));

if mod(length(x), 2) == 1
    disp('Something is wrong')
end


end