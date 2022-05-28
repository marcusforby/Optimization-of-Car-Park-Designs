%% Generate figures for IKEA our solution in report
clc; close all; clear

%% DEFINING VARIABLES
area = [113.441561409,	-13.3308421882; ...
        11.5662584181,	-8.86056330403; ...
        9.68403573006,	-54.7397413254; ...
        14.5072313682,	-54.7397413254; ...
        13.3308421882,	-88.8550275465; ...
        23.6830669725,	-98.5014188228; ...
        92.1489172506,	-84.6200264984; ...
        92.7371118406,	-68.6211336499; ...
        111.088783049,	-69.4446060759];

parking_size = [2.4, 5, 7];
out_edge = 4;
angle = 28;
side = 9;

%% MAKING SOLUTION
angles = 90 - [0, 30, 45, 60, 75, 90, 105, 120, 135, 150, 180];
free_space = [2.5, 2.5, 3.2, 4.2, 5.5, 7, 5.5, 4.2, 3.2, 2.5, 2.5];
parking_size_temp = parking_size;
parking_size_temp(3) = interp1(angles, free_space, angle);
points_init = heuristic_polygon_angled(area, parking_size_temp, angle, side, []);

%% PLOTTING THE CURRENT SOLUTION
removed_index = [38, 57, 134, 161, 162, 163, 191, 192, 248, 278, 279, 309];
removed_points = points_init(removed_index,:);
points_init(removed_index,:) = [];
removed_index_2 = [80];
removed_points_2 = points_init(removed_index_2,:);
removed_index_our = [20, 21, 38, 39, 56, 81, 82];
removed_points_our = points_init(removed_index_our,:);
points_init(removed_index_our,:) = [];

fig = figure;
plot_parking_spaces(points_init, area, parking_size(1:2), [1]);
hold all
scatter(removed_points(:,1), removed_points(:,2), '*', 'red')
scatter(removed_points_our(:,1), removed_points_our(:,2), '*', 'green')
scatter(removed_points_2(:,1), removed_points_2(:,2), '*', 'black')

r = [24.4768, -16.6409]-[24.5907, -13.9252];
r = r./norm(r,2);
dp = 10*r;
diff = 2.8;
start_1 = -15;
start_2= -83;

%%%%%% DOWN ARROWS %%%%%%
p = [19.5, start_1];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+diff*dp, p + (diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+2*diff*dp, p + (2*diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);

p = [48.5, start_1];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+diff*dp, p + (diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+2*diff*dp, p + (2*diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);

p = [77, start_1];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+diff*dp, p + (diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+2*diff*dp, p + (2*diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);

p = [106, start_1];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+diff*dp, p + (diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);

%%%%%% UP ARROWS %%%%%%
dp = -10*r;
p = [31, start_2];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+diff*dp, p + (diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+2*diff*dp, p + (2*diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);

p = [60, start_2];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+diff*dp, p + (diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+2*diff*dp, p + (2*diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);

p = [89, start_2];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+diff*dp, p + (diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+2*diff*dp, p + (2*diff+1)*dp,'tipangle', 15, 'Length', 10, 'width', 1);
hold off

saveas(fig, 'OurSolution_Ikea.png')


