function density = find_density(area, n, parking_size)
% Purpose: Find the fraction of the area occupied by parking slots
% Authors: Marcus Førby & Oscar J. Andersen

%% INPUT
%         area: A list of points determining a polygon
%       points: The centers of all the parking-slots which have been placed
% parking_size: The dimensions of a parking slot. The first entry is width,
%               the second is height and the third is need free space in 
%               front of the car

%% OUTPUT
% density: The fraction of the parking space occupied by parking slots

%% CODE


area_occupied_by_slots = n*parking_size(1)*parking_size(2);

area_total = 1/2*(area(:, 1)'*area([2:end, 1], 2) - area([2:end, 1], 1)'*area(:, 2));

density = area_occupied_by_slots/area_total;


end
