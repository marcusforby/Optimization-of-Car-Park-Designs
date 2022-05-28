%% Plotting script for the solutions from Julia
clc; close all; clear

%% LOADING TXT FILES
points = readmatrix('points.txt');
if size(points, 2) == 2
    points = [points zeros(size(points, 1), 1) 3*ones(size(points, 1), 1)];
end

area = readmatrix('area.txt');
parking_size = readmatrix('parking_size.txt');

%% PLOTTING SOLUTION
fig = figure;
plot_parking_spaces(points, area, parking_size(1:2), []);
