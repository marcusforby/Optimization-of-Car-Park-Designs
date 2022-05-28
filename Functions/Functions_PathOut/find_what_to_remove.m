function [path, edges_out, X_out, Y_out, points_out, first_point_out, can_get_out_before_out, cant_get_out_before_out] = find_what_to_remove(first_point, end_point, X, Y, points, inx, inx_new, parking_size, area, interval, edges, index_shifter, can_get_out_before, cant_get_out_before, road_width)
% Purpose: Find and remove parking slots
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% first_point: the point which we initialize the algorithm from
% end_point: the points which can get out
% X: a vector containing the X-coordinates of the nodes
% Y: a vector containing the Y-coordinates of the nodes
% points: the center points of the placed parking slots
% inx: the old slots which can get out
% inx_new: the old and new slots which can get out
% parking_size: the dimension of the parking slots
% area: the area in which we have placed parking slots
% interval: the distance between the nodes in the grid
% edges: edges between the nodes
% index_shifter: the index which shows which algorithm to use
% can_get_out_before: the nodes which have previously been shown to be able
% to get out
% cant_get_out_before: the nodes which have previously been shown to be
% unable to get out
% road_width: the width of the road

%% OUTPUT
% path: the parking-slots which have been removed
% edges_out: the edges of the grid
% X_out: a vector containing the x-coordinates of the nodes
% Y_out: a vector containing the y-coordinates of the nodes
% points_out: the centers of the parking lots
% first_point_out: the points which represents the parking slots in the
% grid
% can_get_out_before_out: updated list of the nodes which have previously
% been shown to be able to get out
% cant_get_out_before_out: updated list of the nodes which have previously
% been shown to be unable to get out

%% CODE

n_X = size(X,1);
k = size(end_point,1);

index = find_index(inx, inx_new, index_shifter, points, parking_size);

[X_start, Y_start] = create_XY(area, interval, road_width);

X_out = X; Y_out = Y; edges_out = edges; points_out = points; first_point_out = first_point; can_get_out_before_out = can_get_out_before; cant_get_out_before_out = cant_get_out_before;
points_init = points;

path = [];

reverseStr = '';
for i = 1:size(index,1)
   [X_temp, Y_temp] = add_remove_XY(X, Y, X_start, Y_start, parking_size, index(i,:), points_init, road_width);
    
   [first_point_temp, points_temp] = remove_used_parking_slots(index(i,:)+n_X+k, first_point, end_point, X, Y, points);

   
   if size(X_temp,1) > n_X
       [X_temp, Y_temp, edges_temp] = add_edges(X_temp, Y_temp, interval, end_point, X, Y, edges);
       for k1 = 1:size(first_point_temp, 1)
           find_xy = find(and(first_point_temp(k1,1) == X_temp, first_point_temp(k1,2) == Y_temp));

           if length(find_xy) ~= 1
               disp('Somethings wrong')
           end

           first_point_temp(k1, 3) = find_xy;
       end
       [inx_temp, can_get_out_before_temp, cant_get_out_before_temp] = depth_first_init(first_point_temp, end_point, X_temp, Y_temp, edges_temp, can_get_out_before, []);
       if sum(inx_temp) > sum(inx)
           disp(' ')
           disp(['Succes at i = ', num2str(i), ' / ', num2str(length(index)), '.'])
           disp(['Removing ', num2str(length(index(i,:))), ' parking slots.'])
           path = [path, index(i,:)];
           edges_out = edges_temp;
           X_out = X_temp;
           Y_out = Y_temp;
           points_out = points_temp;
           first_point_out = first_point_temp;
           can_get_out_before_out = can_get_out_before_temp;
           cant_get_out_before_out = cant_get_out_before_temp;
           return
       elseif sum(inx_temp) < sum(inx)-3
           disp('Somethings wrong')
           disp(['Number of parkingslot to little: ', num2str(sum(inx)-3-sum(inx_temp))])
           edges_out = edges_temp;
           X_out = X_temp;
           Y_out = Y_temp;
           figure
           scatter(X,Y, 'o')
           hold all
           scatter(X_temp, Y_temp, '*', 'red')
           for i1 = 1:size(edges_temp,1)
                if edges_temp(i1,1) <= size(X_temp,1) && edges_temp(i1,2) <= size(X_temp,1)
                    plot([X_temp(edges_temp(i1,1)), X_temp(edges_temp(i1,2))], [Y_temp(edges_temp(i1,1)), Y_temp(edges_temp(i1,2))])
                elseif edges_temp(i1,1) > size(X_temp,1) + 1 || edges_temp(i1,2) > size(X_temp,1) + 1
                    disp('W')
                elseif edges_temp(i1,2) > size(X_temp,1) || edges_temp(i1,2) <= size(X_temp,1) + 1
                    plot([X_temp(edges_temp(i1,1)), end_point(1,1)], [Y_temp(edges_temp(i1,1)), end_point(1,2)])
                    scatter(end_point(1,1), end_point(1,2), '*')
                end
           end
           
           return
       end
   end
   % Display the progress
   percentDone = 100 * i / size(index,1);
   msg = sprintf('Percent done: %3.1f', percentDone);
   fprintf([reverseStr, msg]);
   reverseStr = repmat(sprintf('\b'), 1, length(msg));
    
    
end
disp(' ')


end