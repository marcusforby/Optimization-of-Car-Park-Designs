function plot_parking_spaces(points, area, parking_size, outedges)
% Purpose: plots the car park that has been designed
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
%       points: a list of points which we need to plot. The first and 
%               second entries are the x- and y- coordinates of the center 
%               of the parking-slot, the third entry indicates which angle 
%               the parking slot is rotated, and the fourth indicates 
%               which side should be used to enter the slot
%         area: a list of points defining the parking space, in positive  
%               direction of rotation
% parking_size: the dimensions of a parking slot. The first entry is width,
%               the second is height and the third is need free space in 
%               front of the car

%% CODE
M = size(area, 1); % amount of points which determines the polygon
N = size(points, 1); % amount of parking slots

% plot the area first
if isempty(outedges)
    plot([area(M, 1), area(1, 1)], [area(M, 2), area(1, 2)], 'black', 'LineWidth', 2)
    hold all;
    for i=1:M-1
        plot([area(i, 1), area(i+1, 1)], [area(i, 2), area(i+1, 2)], 'black', 'LineWidth', 2)
    end
else
    for i=1:M
        if i == M
            j = 1;
        else
            j = i+1;
        end
        if sum(outedges == i) == 1
            plot([area(i, 1), area(j, 1)], [area(i, 2), area(j, 2)], 'red', 'LineWidth', 4)
            hold all;
        else
            plot([area(i, 1), area(j, 1)], [area(i, 2), area(j, 2)], 'black', 'LineWidth', 2)
            hold all;
        end
    end
end
    

% plot each parking slot
for i=1:N
    % find the matrix which rotates the parking slot
    rot_mat = [cos(points(i,3)/180*pi), -sin(points(i,3)/180*pi); sin(points(i,3)/180*pi), cos(points(i,3)/180*pi)];
    
    % first build the parking slot around (0, 0)
    all_points = [-parking_size'/2, [1;-1].*parking_size'/2, parking_size'/2, [-1;1].*parking_size'/2];
    
    % now rotate all the points, and then move it to the real center of the
    % parking slot
    all_points = rot_mat*all_points + points(i, 1:2)';
    all_points = [all_points, all_points(:, 1)];
    
    % plot the parking space, and make the entry side red
    plot(all_points(1, 1:points(i,4)), all_points(2, 1:points(i,4)), 'blue', 'LineWidth', 1);
    plot(all_points(1, points(i,4):points(i,4)+1), all_points(2, points(i,4):points(i,4)+1), 'red', 'LineWidth', 2);
    plot(all_points(1, points(i,4)+1:end), all_points(2, points(i,4)+1:end), 'blue', 'LineWidth', 1);
end

% plot all the centers of the parking slots
scatter(points(:, 1), points(:, 2), 'red')

% ensure that the ratio between x- and y-axis is 1-to-1
ax = gca;
ax.PlotBoxAspectRatio = [1, 1, 1];
daspect([1,1,1]);

hold off

% make the figure look nice
title(['Number of parking spaces: ' num2str(N)]);
xlim([min(area(:, 1))-2, max(area(:, 1))+2])
ylim([min(area(:, 2))-2, max(area(:, 2))+2])

end