%% Generate figures for Stades Krog our solution in report
clc; close all; clear

%% DEFINING VARIABLES
area = [41.2588655423,	-10.085152642; ...
        35.9109231876,	-20.389376676; ...
        37.7369928846,	-46.9978208318; ...
        38.3891606335,	-51.5629950742; ...
        41.2586987287,	-57.5629383642; ...
        55.4759556551,	-52.867330572; ...
        56.5194240533,	-71.2584610915; ...
        69.8236461312,	-69.6932584941; ...
        67.7367093347,	-50.6499602257; ...
        81.6930991615,	-49.0847576283; ...
        83.6496024083,	-68.3889229962; ...
        100.73639743,	-65.6498184508; ...
        97.8668593346,	-46.867387282; ...
        93.8234192913,	-47.1282543816; ...
        90.0408463476,	-24.4328167193; ...
        53.7803195079,	-28.7371238621; ...
        52.9977182092,	-24.1719496197; ...
        56.7802911529,	-14.7807340353];

parking_size = [2.4, 5, 7];
angle = 15;
out_edge = 4;
side = 7;

%% MAKING SOLUTION
angles = 90 - [0, 30, 45, 60, 75, 90];
free_space = [2.5, 2.5, 3.2, 4.2, 5.5, 7];
parking_size_temp = parking_size;
parking_size_temp(3) = interp1(angles, free_space, angle);

points = heuristic_polygon_angled(area, parking_size_temp, angle, side, []);
remove_indices = [1:25, 44:47, 65:75];
removed_points = points(remove_indices, :);
points(remove_indices, :) = [];
X_dots = points(:,1);
Y_dots = points(:,2);

r = area(2,:) - area(1,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(1,:) + r * (parking_size(1)/2) + n * parking_size(2)/2;
v = acos([-1,0]*r')*180/pi; 
for i = 1:4
    points = [points; point, v, 1];
    point = point + r * parking_size(1);
end

r = area(7,:) - area(6,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(6,:) + r * (parking_size(1)/2-1) + n * (parking_size(2)/2);
v = acos([-1,0]*r')*180/pi; 
for i = 1:8
    points = [points; point, v, 1];
    point = point + r * parking_size(1);
end

r = area(11,:) - area(10,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(10,:) + r * (parking_size(1)/2) + n * (parking_size(2)/2);
v = acos([-1,0]*r')*180/pi; 
for i = 1:8
    points = [points; point, v, 1];
    point = point + r * parking_size(1);      
end

r = area(13,:) - area(12,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(12,:) + r * (3*parking_size(1)/2-0.2) + n * (parking_size(2)/2);
v = acos([1,0]*r')*180/pi; 
for i = 1:7
    points = [points; point, v, 3];
    point = point + r * parking_size(1);      
end

r = area(3,:) - area(2,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(2,:) + r * (2*parking_size(1)/2+1) + n * (parking_size(2)/2);
v = acos([-1,0]*r')*180/pi; 
for i = 1:3
    points = [points; point, v, 1];
    point = point + r * parking_size(1);
end

r = area(size(area,1),:) - area(size(area,1)-1,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(size(area,1)-1,:) + r * (2*parking_size(1)/2) + n * (parking_size(2)/2);
v = acos([1,0]*r')*180/pi; 
for i = 1:3
    points = [points; point, v, 3];
    point = point + r * parking_size(1);
end

%% PLOTTING THE CURRENT SOLUTION
fig = figure;
plot_parking_spaces(points, area, parking_size(1:2), out_edge)

hold all
scatter(X_dots, Y_dots, '*', 'black')
p = [50, -48];
dp = [5,0.5];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+5*dp, p + 6*dp,'tipangle', 15, 'Length', 10, 'width', 1);

p = [78, -28.5];
dp = -[5,0.5];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p+5*dp, p + 6*dp,'tipangle', 15, 'Length', 10, 'width', 1);

p = [47, -26];
dp = [-0.5,5];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p + [-2, -0.5] + dp, p + [-2, -0.5], 'tipangle', 15, 'Length', 10, 'width', 1);

p = [66, -65];
dp = [-0.5,5];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p + [-2, -0.5] + dp, p + [-2, -0.5], 'tipangle', 15, 'Length', 10, 'width', 1);

p = [92.5, -62];
dp = [-0.5,5];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p + [-2, -0.5] + dp, p + [-2, -0.5], 'tipangle', 15, 'Length', 10, 'width', 1);

p = [89, -38];
dp = [-0.5,5];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p, p + dp, p, 'tipangle', 15, 'Length', 10, 'width', 1);

p = [39, -38];
dp = -[-0.5,5];
arrow(p, p + dp,'tipangle', 15, 'Length', 10, 'width', 1);
arrow(p, p + dp, p, 'tipangle', 15, 'Length', 10, 'width', 1);

saveas(fig, 'OurSolution_StadesKrog.png')