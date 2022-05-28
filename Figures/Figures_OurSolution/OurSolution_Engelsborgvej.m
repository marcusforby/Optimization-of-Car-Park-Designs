%% Generate figures for Stades Krog our solution in report
clc; close all; clear

%% DEFINING VARIABLES
area = [23.693477153,	-12.2231989881; ...
        18.2524477671,	-21.6347092772; ...
        23.8405484142,	-54.5749298445; ...
        26.0463547253,	-65.6041089094; ...
        97.2208233772,	-53.1043832521; ...
        117.367311694,	-18.1053743519; ...
        90.3092543927,	-2.37052581277; ...
        79.499729116,	-18.7441577853; ...
        47.0491283011,	-24.6052795184];

parking_size = [2.4, 5, 7];
angle = 35;
out_edge = 3;
side = 4;

%% MAKING SOLUTION
angles = 90 - [0, 30, 45, 60, 75, 90];
free_space = [2.5, 2.5, 3.2, 4.2, 5.5, 7];
parking_size_temp = parking_size;
parking_size_temp(3) = interp1(angles, free_space, angle);

points = heuristic_polygon_angled(area, parking_size_temp, angle, side, []);

%% PLOTTING THE CURRENT SOLUTION
remove_indices = [74, 75, 105];
removed_points = points(remove_indices, :);
points(remove_indices, :) = [];
our_indices = [25, 26, 50, 74, 75, 103, 132, 147, 148, 149];
our_points = points(our_indices, :);
points(our_indices, :) = [];

fig = figure;
plot_parking_spaces(points, area, parking_size(1:2), out_edge);
hold all;
if ~isempty(removed_points)
    scatter(removed_points(:,1),removed_points(:,2), '*', 'red')
end
if ~isempty(our_points)
    scatter(our_points(:,1),our_points(:,2), '*', 'green')
end
k = 8.5;
p = [35, -43];
dp = points(2, 1:2) - points(1, 1:2);
dp = k*dp/norm(dp, 2);

% CENTER LANE
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p + 2.5*dp, p + 3.5*dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p + 5*dp, p + 6*dp,'tipangle', 15, 'Length', 10, 'width', 1);

% BOTTOM LANE
p = [37, -56.3];
arrow(p + dp, p,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p + 3.5*dp, p + 2.5*dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p + 6*dp, p + 5*dp, 'tipangle', 15, 'Length', 10, 'width', 1);

% TOP LANE
p = [33, -29.50];
arrow(p + dp, p,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p + 4.3*dp, p + 3.3*dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p + 7.5*dp, p + 6.5*dp, 'tipangle', 15, 'Length', 10, 'width', 1);

% RIGHT SIDE
dp = area(6, :) - area(5, :);
dp = k*dp/norm(dp, 2);
p1 = [99.2, -43.7];
p2 = [107.6, -28];
arrow(p1 + dp, p1,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p2, p2 + dp,'tipangle', 15, 'Length', 10, 'width', 1);

% LEFT SIDE
dp = area(3, :) - area(2, :);
dp = k*dp/norm(dp, 2);
p1 = [23, -33.5];
p2 = [26, -47.5];
arrow(p1, p1 + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p2 + dp, p2,'tipangle', 15, 'Length', 10, 'width', 1);


saveas(fig, 'OurSolution_Engelsborgvej.png');


