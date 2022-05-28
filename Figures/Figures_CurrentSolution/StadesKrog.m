%% Creating current solution for Stades Krog
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

%% PLACING PARKING SLOT ON THE SIDES
r = area(2,:) - area(1,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
points = [];
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
point = area(2,:) + r * (2*parking_size(1)/2+5) + n * (parking_size(2)/2);
v = acos([-1,0]*r')*180/pi; 
for i = 1:9
    points = [points; point, v, 1];
    points = [points; point+n*(parking_size(2)+parking_size(3)), v, 3];
    point = point + r * parking_size(1);
end

r = area(14,:) - area(15,:);
r = r/norm(r,2);
n = -[-r(2), r(1)];
point = area(15,:) + r * (parking_size(1)/2) + n * (parking_size(2)/2);
v = acos([-1,0]*r')*180/pi; 
for i = 1:7
    points = [points; point, v, 3];
    points = [points; point+n*(parking_size(2)+parking_size(3)), v, 1];
    points = [points; point+n*(parking_size(2)*2+parking_size(3)+1), v, 3];
    points = [points; point+n*(parking_size(2)*3+2*parking_size(3)+1), v, 1];
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

%% PLOTTING CURRENT SOLUTION    
figure
plot_parking_spaces(points, area, parking_size(1:2), 4)