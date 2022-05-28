%% Optimal angle script
clc; close all; clear


%% DEFINING VARIABLES
% Parking slot size:
w = 2.4;
h = 5;

% Free space values:
angles = pi/2 - [0, 30, 45, 60, 75, 90]/180*pi;
free_space = [2.5, 2.5, 3.2, 4.2, 5.5, 7];

% Calculating max angle:
max_angle = atan(h/w);
disp(['Max angle is equal to ', num2str(max_angle*180/pi), ' degrees when w = ', num2str(w), ' and h = ', num2str(h), '.'])

%% SOLVE FOR OPTIMUM ANGLE
n = length(angles);
angle_opt = [];
for i=1:n-1
    a = (free_space(i+1)-free_space(i))/(angles(i+1)-angles(i));
    b = free_space(i) - a*angles(i);
    starting_point = (angles(i+1)-angles(i))/2;
    [angle_temp, stat] = newton(0.5, @green_area, starting_point, a, b, w, h, angles, free_space);
    
    % Saving angle_temp to angle_opt if it found optimum
    if ~isempty(angle_temp) && angle_temp >= angles(i+1) && angle_temp <= angles(i)
        angle_opt = [angle_opt, angle_temp];
    end
    
end

disp(['Optimal angle is equal to ', num2str(angle_opt*180/pi), ' degrees.'])

rho_opt = density(angle_opt, w, h, angles, free_space);
disp(['Optimal density is equal to ', num2str(rho_opt), '.'])


%% FUNCTIONS
function rho = density(alpha, w, h, angles, free_space)

L = interp1(angles, free_space, alpha);

rho = 2*h./(L./cos(alpha) + 2*h + tan(alpha).*w);

end

function [area, df, ddf] = green_area(alpha, a, b, w, h, angles, free_space)

L = interp1(angles, free_space, alpha);

area = L/cos(alpha) + 2*h + tan(alpha)*w;

df = a/cos(alpha) + (a*alpha + b)*sin(alpha)/cos(alpha)^2 + (1 + tan(alpha)^2)*w;

ddf = 2*a*sin(alpha)/cos(alpha)^2 + 2*(a*alpha + b)*sin(alpha)^2/cos(alpha)^3 ...
    + (a*alpha + b)/cos(alpha) + 2*tan(alpha)*(1+tan(alpha)^2)*w;

end
