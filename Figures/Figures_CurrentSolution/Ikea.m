%% Creating current solution for IKEA
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

%% PLACING PARKING SLOT ON THE SIDES
r = area(3,:) - area(2,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
points = [];
point = area(2,:) + r * (3*parking_size(1)/2) + n * parking_size(2)/2;
v = acos([1,0]*r')*180/pi; 
for i = 1:29
    points = [points; point+n * sum(parking_size([2,3])), -v, 1];
    points = [points; point+n * sum(parking_size([2,2,3])), -v, 3];
    
    if i <= 17
        points = [points; point, -v, 3];
    end
    
    if i <= 27
        points = [points; point+n * sum(parking_size([2,2,2,3,3])), -v, 1];
        points = [points; point+n * sum(parking_size([2,2,2,2,3,3])), -v, 3];
    end
    
    if i <= 25
        points = [points; point+n * sum(parking_size([2,2,2,2,2,3,3,3])), -v, 1];
        points = [points; point+n * sum(parking_size([2,2,2,2,2,2,3,3,3])), -v, 3];
    end
    
    if i <= 24
        points = [points; point+n * sum(parking_size([2,2,2,2,2,2,2,3,3,3,3])), -v, 1];
        points = [points; point+n * sum(parking_size([2,2,2,2,2,2,2,2,3,3,3,3])), -v, 3];
    end
    
    if i <= 19
        points = [points; point+n * sum(parking_size([2,2,2,2,2,2,2,2,2,3,3,3,3,3])), -v, 1];
        points = [points; point+n * sum(parking_size([2,2,2,2,2,2,2,2,2,2,3,3,3,3,3])), -v, 3];
    end
    
    if i >= 3 && i <= 22
        points = [points; point+n * sum(parking_size([2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3])), -v, 1];
    end
    
    
    point = point + r * parking_size(1);
end

%% PLOTTING CURRENT SOLUTION
figure
plot_parking_spaces(points, area, parking_size(1:2), 1)