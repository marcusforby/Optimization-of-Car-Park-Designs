%% MAIN SCRIPT FOR CALLING FUNCTIONS
clc; close all; clear
% Remember to run SETUP.m before using any scripts

%% Parking_size
% Define parking sizes for [width, height, free space]
parking_size = [2.4, 5, 7];

%% DEFINE AREA
% Stades Krog:
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

% Engelsborgvej:
area = [23.693477153,	-12.2231989881; ...
    18.2524477671,	-21.6347092772; ...
    23.8405484142,	-54.5749298445; ...
    26.0463547253,	-65.6041089094; ...
    97.2208233772,	-53.1043832521; ...
    117.367311694,	-18.1053743519; ...
    90.3092543927,	-2.37052581277; ...
    79.499729116,	-18.7441577853; ...
    47.0491283011,	-24.6052795184];

% IKEA:
area = [113.441561409,	-13.3308421882; ...
        11.5662584181,	-8.86056330403; ...
        9.68403573006,	-54.7397413254; ...
        14.5072313682,	-54.7397413254; ...
        13.3308421882,	-88.8550275465; ...
        23.6830669725,	-98.5014188228; ...
        92.1489172506,	-84.6200264984; ...
        92.7371118406,	-68.6211336499; ...
        111.088783049,	-69.4446060759];

%% ALGORITHM INDEX
% Can be 1 to 4:
algoritms_index = [1:3];
% 1: straight parking spaces
% 2: straight parking spaces in different angles
% 3: straight parking spaces in different angles using a special first side
% 4: boundary parking spaces (the area has to be convex)

%% ANGLE INTERVAL INDEX
% Define an angle interval between 1 and 90
angle_interval = 1;

%% PATH OUT INDEX
% 0: no use of path out method
% 1: use path out method on best solution
% 2: use path out method on all best solutions
% 3: use path out method on all solutions
path_out_index = 2;

% Define interval for the grid in path out
interval = 0.25;

%% OUT EDGE INDEX
% Define an outedge between 1 and number of edges
% Ikea: 1, Engelsborgvej: 3, Stades krog: 4
out_edge = 1;

%% CALLING SCRIPT
struct = calling_script(area, parking_size, algoritms_index, angle_interval, path_out_index, out_edge, interval);
save([cd,'/Outputs/struct.mat'], 'struct')

%% PLOTTING SOLUTIONS

if ~isempty(struct)
    if path_out_index == 1
        eval('points_max = struct.best_solution.points_max;');
        fig = figure;   
        plot_parking_spaces(points_max, area, parking_size(1:2), []);
        hold all
        eval('removed_points = struct.best_solution.removed_points;');
        eval('end_point = struct.best_solution.end_point;');
        eval('X = struct.best_solution.X;');
        eval('Y = struct.best_solution.Y;');
        
        if ~isempty(X) && ~isempty(Y)
            scatter(X, Y, 'o', 'y')
        end
        if ~isempty(end_point)
            scatter(end_point(:,1),end_point(:,2), '*', 'blue')
        end
        if ~isempty(removed_points)
            scatter(removed_points(:,1),removed_points(:,2), '*', 'red')
        end
        hold off

        saveas(fig, [cd,'/Outputs/figure_best_solution'])
        saveas(fig, [cd,'/Outputs/figure_best_solution.png'])
    end
    
    for i = 1:length(algoritms_index)
        index = algoritms_index(i);
        eval(['points_max = struct.algorithm',num2str(index), '.points_max;']);
        fig = figure;   
        plot_parking_spaces(points_max, area, parking_size(1:2), []);
        hold all
        if path_out_index > 1
            
            eval(['removed_points = struct.algorithm',num2str(index), '.removed_points;']);
            eval(['end_point = struct.algorithm',num2str(index), '.end_point;']);
            
            eval(['X = struct.algorithm',num2str(index), '.X;']);
            eval(['Y = struct.algorithm',num2str(index), '.Y;']);
            if ~isempty(X) && ~isempty(Y)
                scatter(X, Y, 'o', 'y')
            end
            
            
            if ~isempty(end_point)
                scatter(end_point(:,1),end_point(:,2), '*', 'blue')
            end
            if ~isempty(removed_points)
                scatter(removed_points(:,1),removed_points(:,2), '*', 'red')
            end
        end
        hold off

        saveas(fig, [cd,'/Outputs/figure_algorithm', num2str(index)])
        saveas(fig, [cd,'/Outputs/figure_algorithm', num2str(index), '.png'])
    end
end


