%% Time tests for table 4 in the report
clc; close all; clear

%% DEFINING VARIABLES
iterations = 100;
parking_size = [2.4, 5, 7];

% The large area
area = [173.767, 108.019; ...
        167.180, 97.785; ...
        164.795, 59.550; ...
        171.924, 56.954; ...
        238.507, 62.571; ...
        261.930, 95.592; ...
        228.875, 115.455] .*3;    

% The small area
area = [195.415,  329.212; ...
        201.660, 311.876; ...
        208.740, 302.708; ...
        214.037, 299.843; ...
        220.802, 299.376; ...
        260.632, 315.004; ...
        211.757, 348.476; ...
        207.7300  347.0070; ...
        200.189, 340.667];

%% Heuristic 1
side = 1; 

t1 = tic;
for i = 1:iterations
    points_temp = heuristic_polygon_straight(area, parking_size, 1, side);
end
t1 = toc(t1);
t1_avg = t1/iterations;


%% Heuristic 2
angle = -5;

t2 = tic;
for i = 1:iterations
    points_temp = heuristic_polygon_angled(area, parking_size, 0, side, []);
end
t2 = toc(t2);
t2_avg = t2/iterations;


%% Heuristic 3
angle_first_side = 5;

t3 = tic;
for i = 1:iterations
    points_temp = heuristic_polygon_angled_first_side(area, parking_size, parking_size, angle, angle_first_side, side);
end
t3 = toc(t3)/size(area,1);
t3_avg = t3/iterations;


%% Heuristic 4
t4 = tic;
for i = 1:iterations
    points_temp = heuristic_boundary_single(area, parking_size, 2, 0, side);
end
t4 = toc(t4);
t4_avg = t4/iterations;

t5 = tic;
for i = 1:iterations
    points_temp = heuristic_boundary_double(area, parking_size, 2, 0, side);
end
t5 = toc(t5);
t5_avg = t5/iterations;


%% PRINTING SOLUTIONS
disp('The total time for each algorithm is:')
disp(' ')
disp([t1,t2,t3,t4, t5])
disp('The average time for each algorithm is:')
disp(' ')
disp([t1_avg, t2_avg, t3_avg, t4_avg, t5_avg])



