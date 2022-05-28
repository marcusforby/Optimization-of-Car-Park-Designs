%% Generate figures for heuristic 1 in report
clc; close all; clear

%% DEFINING VARIABLES
parking_size = [2.2, 5, 6];
angles = 90 - [0, 30, 45, 60, 75, 90, 105, 120, 135, 150, 180];
free_space = [2.5, 2.5, 3.2, 4.2, 5.5, 7, 5.5, 4.2, 3.2, 2.5, 2.5];

%% Heuristic 1
area = [-15,0; -10, 0; -12, 5; -8, 0; -4, 0; 1, 12; 0,0; 6,0; 10, 5; 8,0; 14.5, 0; 15, 20; -15, 38];
points = heuristic_polygon_straight(area, parking_size, 1, 1);

fig = figure;   
plot_parking_spaces(points, area, parking_size(1:2), []);
saveas(fig, 'polygon_straight.png')

%% Heuristic 2
angle = 10;
parking_size_temp = parking_size;
parking_size_temp(3) = interp1(angles, free_space, angle); 
area = [-15,0; -4, 0; 1, 12; 0,0; 6,0; 14.5, 0; 14, 20; 5, 22; 15, 23; 15, 35; 2, 32; -15, 38];
points = heuristic_polygon_angled(area, parking_size_temp, angle, 1, []);

fig = figure;   
plot_parking_spaces(points, area, parking_size(1:2), []);
saveas(fig, 'polygon_angled.png')


%% Heuristic 3
angle_first_side = -10;
parking_size_first_side_temp = parking_size;
parking_size_first_side_temp(3) = interp1(angles, free_space, angle_first_side); 
points = heuristic_polygon_angled_first_side(area, parking_size_temp, parking_size_first_side_temp, angle, angle_first_side, 9);

fig = figure;
plot_parking_spaces(points, area, parking_size(1:2), []);
saveas(fig, 'polygon_angled_first_side.png')


%% Heuristic 4
area = [5,1; 75, 10; 75, 60; -8, 65; -25, 30];

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


