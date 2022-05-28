function [X_temp, Y_temp, edges] = add_edges(X_temp, Y_temp, interval, end_point, X, Y, edges)
% Purpose: Add edges between the new nodes
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
% X_temp: x-coordinates for all the new and old nodes in the grid
% Y_temp: y-coordinates for all the new and old nodes in the grid
% interval: distance between the nodes in the grid
% end_point: list of points from which we can exit the parking lot
% X: x-coordinates for all the old nodes in the grid
% Y: y-coordinates for all the old nodes in the grid
% edges: the current list of edges

%% OUTPUT
% edges: list of edges containing both old and new edges

%% CODE
n_X = size(X,1);
k = size(end_point, 1);
[tf, ~] = ismember([X_temp,Y_temp],[X, Y], 'rows');

index_end_point = find(edges(:,2) > n_X);


X_new = X_temp(~logical(tf));
Y_new = Y_temp(~logical(tf));

X_temp = [X; X_new];
Y_temp = [Y; Y_new];

edgesFrom = zeros(4*size(X_temp,1), 1);
edgesTo = zeros(4*size(X_temp,1), 1);

count = 1;
for i = 1:size(X_new, 1)
    for j=1:size(X_temp,1)
        if i+n_X ~= j
            if abs(X_new(i) - X_temp(j)) - interval < 1.0e-4 && abs(Y_new(i) - Y_temp(j)) < 1.0e-4
                edgesFrom(count) = i+n_X;
                edgesFrom(count+1) = j;
                edgesTo(count) = j;
                edgesTo(count+1) = i+n_X;
                count = count + 2;
                
            elseif abs(Y_new(i) - Y_temp(j)) - interval < 1.0e-4 && abs(X_new(i) - X_temp(j)) < 1.0e-4
                edgesFrom(count) = i+n_X;
                edgesFrom(count+1) = j;
                edgesTo(count) = j;
                edgesTo(count+1) = i+n_X;
                count = count + 2;
            end
        end
    end
end    

edges(index_end_point, 2) = size(X_temp, 1) + edges(index_end_point, 2) - size(X, 1);

% Remove edges not used
edgesFrom = edgesFrom(1:count-1, :);
edgesTo = edgesTo(1:count-1, :);

% Merge the two vectors into one matrix, before returning
edges_new = [edgesFrom, edgesTo];
edges = [edges; edges_new];

end