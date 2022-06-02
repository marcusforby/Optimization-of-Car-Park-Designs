%% Generate figures for heuristic 1 in report
clc; close all; clear

%% DEFINING VARIABLES
parking_size = [2.2, 5, 6];
angles = 90 - [0, 30, 45, 60, 75, 90, 105, 120, 135, 150, 180];
free_space = [2.5, 2.5, 3.2, 4.2, 5.5, 7, 5.5, 4.2, 3.2, 2.5, 2.5];
area = [5,4; 75, 10; 75, 60; -8, 60; -25, 30];

%% Heuristic 1
points = heuristic_polygon_straight(area, parking_size, 1, 1);

fig = figure;   
plot_parking_spaces(points, area, parking_size(1:2), []);
saveas(fig, 'polygon_straight.png')

%% Heuristic 2
angle = 27;
parking_size_temp = parking_size;
parking_size_temp(3) = interp1(angles, free_space, angle); 
points = heuristic_polygon_angled(area, parking_size_temp, angle, 1, []);

fig = figure;   
plot_parking_spaces(points, area, parking_size(1:2), []);
saveas(fig, 'polygon_angled.png')


%% Heuristic 3
angle_first_side = 5;
parking_size_first_side_temp = parking_size;
parking_size_first_side_temp(3) = interp1(angles, free_space, angle_first_side); 
points = heuristic_polygon_angled_first_side(area, parking_size_temp, parking_size_first_side_temp, angle, angle_first_side, 2);

fig = figure;
plot_parking_spaces(points, area, parking_size(1:2), []);
saveas(fig, 'polygon_angled_first_side.png')


%% Heuristic 4

% SINGLE
[points_max, new_area, ~] = heuristic_boundary_single(area, parking_size, 4, 0, 3);
[points_temp, new_area, ~] = heuristic_boundary_single(new_area, parking_size, 4, 0, 3);
points_max = [points_max; points_temp];
[points_temp, new_area, ~] = heuristic_boundary_single(new_area, parking_size, 4, 0, 4);
points_max = [points_max; points_temp];

fig = figure;   
plot_parking_spaces(points_max, area, parking_size(1:2), []);
saveas(fig, 'polygon_boundary_single.png')

% DOUBLE
[points_max, new_area, ~] = heuristic_boundary_single(area, parking_size, 4, 0, 3);
[~, points_temp, new_area, ~] = heuristic_boundary_double(new_area, parking_size, 4, 0, 1);
points_max = [points_max; points_temp];

fig = figure;   
plot_parking_spaces(points_max, area, parking_size(1:2), []);
saveas(fig, 'polygon_boundary_double.png')


