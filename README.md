# OPTIMIZATION OF CAR PARK DESIGNS
Authors: Oscar J. Andersen and Marcus F. Petersen

For any issues, plz contact us on either of the following e-mails:

s194316@student.dtu.dk 

s194343@student.dtu.dk


This is a folder of code developed for a bachelor thesis on DTU. 

To understand the code we recommend the reader to read the paper before using the code. The paper is listed in this folder named BachelorThesis_GitHub.pdf. 

The code has been written in MatLab version R2021a and Julia v1.6.2. In Julia we use the CBC MILP solver v2.10.5 and the GLPK solver v0.14.12.

All files below named *.m is MatLab files, and all files named *.jl is from Julia. 

Before using any MatLab code, please always start by running following script:

	- SETUP.m: adds the path to all the folders containing functions


The folder includes the following algorithms:

	- calling_script.m: head script that is called from main
	- main.m: the main script that assembles all function. From here it is possible to call all algorithms by chancing the parameters in this script
	- SETUP.m: adds the path to all the folders containing functions


Outputs folder: An empty folder that will be filled with result after using the main.m script


OperationsResearch folder:

	- area.txt: the area corner-points which is an output from the discrete or continuous Julia script 
	- ContinuousProblem.jl: the continuous operations research model described in the paper
	- DiscreteProblem.jl: the discrete operations research model described in the paper
	- parking_size.txt: the parking slot sizes which is an output from the discrete or continuous Julia script 
	- plot_result.m: a script that plots the solutions which are in area.txt, parking_size.txt and points.txt 
	- points.txt: the center points of parking slots which is an output from the discrete or continuous Julia script 


Figures folder: 

	- Figures_CurrentSolution: a folder containing MatLab script to create the current solutions illustrated in the paper
	- Figures_HeuristicSection: a folder containing MatLab script to create figures from the heuristic section illustrated in the paper
	- Figures_OurSolution: a folder containing MatLab script to create our modified solutions illustrated in the paper


ReportResults folder:

	- TimeTest.m: a script that times the heuristics. This script is used to create table 4 listed in the paper

OptimalAngle folder: 

		- Newton.m: newtons method for finding roots numerically 
		- SCRIPT_optimal_angle.m: a script calculating the optimal angle and density which is listed in section 2.2 in the paper

Function folder:

	Functions_Heuristic folder:
		- check_for_crosses.m: check if the sides of the polygon crosses each other, and if they do, return a new polygon without crossing sides
		- check_if_in_area.m: check if point is in area
		- find_density.m: find the fraction of the area occupied by parking slots
		- find_max_diff.m: finds max diff from point and into the area
		- find_next_intersection.m: Find the intersection between the line originating in point, along the direction vector, and the area.
		- find_x_interval.m: Find the highest x-coordinate at which we can place a parking slot within the polygon with given y-coordinates.
		- heuristic_boundary_double.m: places a double back-to-back rows of parking slots on all sides in convex car parks
		- heuristic_boundary_single.m: places a single row of parking slots on all sides in convex car parks
		- heuristic_polygon_angled_first_side.m: places one row of angled parking slots on one side and afterwards straight rows of angled parking slots along all other sides in all non-intersecting car parks 
		- heuristic_polygon_angledv: places straight rows of angled parking slots in all non-intersecting car parks
		- heuristic_polygon_straight.m: places straight rows of parking slots in all non-intersecting car parks
		- plot_parking_spaces.m: plots the car park that has been designed
		- rotate_area.m: Rotate the area, such that the longest side lays on the x-axis, starting in origo
	
	Functions_PathOut folder:
		- add_edges.m: add edges between the new nodes
		- add_remove_XY.m: add nodes to the grid, and remove the ones conflicting with chosen_points
		- checking_path_out.m: the main script for the path out algorithm
		- create_edges_combine_slots.m: create edges between slots that are close together
		- create_edges_first_point.m: create edges to the first point from centers
		- create_edges_path_out.m: create edges between nodes with higher index, which are situated within a certain interval
		- create_XY.m: create nodes with X and Y coordinates, such that all nodes are within the area
		- depth_first_algorithm.m: depth first search algorithm, which recursively tries to find a way out of a network
		- depth_first_init.m: initialize the depth first search algorithm
		- find_index.m: creates list of indexes for parking slots that we should try removing
		- find_what_to_remove.m: find and remove parking slots
		- pick_first_point.m: find the first points, which represent the parking slot in the grid
		- remove_used_parking_slots.m: remove parking slots which have been chosen
		- remove_XY.m: remove coordinates from the grid, which overlap with the chosen points
		



