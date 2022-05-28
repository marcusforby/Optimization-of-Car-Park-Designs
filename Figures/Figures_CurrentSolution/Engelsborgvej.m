%% Creating current solution for Engelsborgvej
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


%% PLACING PARKING SLOT ON THE SIDES
r = area(5,:) - area(4,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
points = [];
point = area(4,:) + r * (5*parking_size(1)/2) + n * parking_size(2)/2;
v = acos([1,0]*r')*180/pi; 
for i = 1:27
    points = [points; point, v, 3];
    point = point + r * parking_size(1);
end

r = area(6,:) - area(5,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(5,:) + r * (2*parking_size(1)/2+1.5) + n * (parking_size(2)/2);
v = acos([1,0]*r')*180/pi; 
for i = 1:15
    points = [points; point, v, 3];
    if i > 2 && i < 14
        points = [points; point+n*(parking_size(2) + parking_size(3)), v, 1];
        if i > 7
            points = [points; point+n*(parking_size(2)*2 + parking_size(3) +1), v, 3];
        end
    end
    point = point + r * parking_size(1);
end

r = area(3,:) - area(2,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(2,:) + r * (2*parking_size(1)/2) + n * (parking_size(2)/2);
v = acos([-1,0]*r')*180/pi; 
for i = 1:7
    points = [points; point, v, 1];
    point = point + r * parking_size(1);
end

r = area(1,:) - area(size(area,1),:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(size(area,1),:) + r * (2*parking_size(1)/2+12) + n * (parking_size(2)/2);
v = acos([1,0]*r')*180/pi; 
for i = 1:3
    points = [points; point, v, 3];
    point = point + r * parking_size(1);
end

r = area(size(area,1),:) - area(size(area,1)-1,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(size(area,1)-1,:) + r * (2*parking_size(1)/2) + n * (parking_size(2)/2);
v = acos([-1,0]*r')*180/pi; 
for i = 1:17
    points = [points; point, v, 1];
    point = point + r * parking_size(1);
end

r = area(5,:) - area(4,:);
r = r/norm(r,2);
n = [-r(2), r(1)];
point = area(4,:) + r * (7*parking_size(1)) + n * (3*parking_size(2)/2+parking_size(3));
v = acos([1,0]*r')*180/pi; 
for i = 1:20
    if i < 20
        points = [points; point, v, 1];
    end
    points = [points; point+n*(parking_size(2)+1), v, 3];
    point = point + r * parking_size(1);
end
    

%% PLOTTING CURRENT SOLUTION
figure
plot_parking_spaces(points, area, parking_size(1:2), 3)