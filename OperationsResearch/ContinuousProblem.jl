using JuMP
using GLPK
using DelimitedFiles

######## USER DEFINED VARIABLES ########
xmin = 0
xmax = 9
ymin = 0
ymax = 30.5
n = 9
parking_size = [2.5 5 7];
########################################

## LOADING VARIABLES
m = Model(GLPK.Optimizer)
w = parking_size[1];
h = parking_size[2];
f = parking_size[3];
area = [xmin ymin; xmax ymin; xmax ymax; xmin ymax];
M = max(ymax-ymin, xmax-xmin)

## DEFINING VARIABLES
@variable(m, x[1:n])
@variable(m, y[1:n])
@variable(m, z[1:n], Bin)
@variable(m, 0<=r[1:n]<=1, Bin)
@variable(m, 0<=b[1:n, 1:n]<=1, Bin)
@variable(m, 0<=uxy[1:n, 1:n]<=1, Bin)

## DEFINING OBJECTIVE FUNCTION
@objective(m, Max, sum(z[i] for i=1:n))

## DEFINING CONSTRAINTS
@constraint(m, [i=1:n], xmax - w/2 >= x[i] >= w/2 + xmin) # (1)
@constraint(m, [i=1:n], ymax - h/2 - r[i]*f >= y[i]) # (2)
@constraint(m, [i=1:n], y[i] >= h/2 + (1-r[i])*f + ymin) # (3)
@constraint(m, [j=2:n, i=1:j-1], w <= x[j] - x[i] + (2 - z[i] - z[j])*M + uxy[i, j]*M) # (4)
@constraint(m, [j=2:n, i=1:j-1], h + f*(1-b[i, j]) <= y[j] - y[i] + (2 - z[i] - z[j])*M + (1-uxy[i, j])*M) # (5)
@constraint(m, [i=1:n-1], 0 <= y[i+1] - y[i]) # (6)
@constraint(m, [j=2:n, i=1:j-1], b[i, j] <= r[j]) # (7)
@constraint(m, [j=2:n, i=1:j-1], b[i, j] <= (1 - r[i])) # (8)
@constraint(m, [i=1:n-1], z[i] >= z[i+1]) # (9)

## OPTIMIZE
println("Optmizing")
optimize!(m)


## SAVE SOLUTION
file =  open("points.txt","w")
points = [value.(x), value.(y), value.(z)];

for i=1:n
    if value(z[i]) == 1
        if value(r[i]) == 1
            write(file, "$(JuMP.value.(x)[i]), $(JuMP.value.(y)[i]), 0, 3 \n")
        else
            write(file, "$(JuMP.value.(x)[i]), $(JuMP.value.(y)[i]), 0, 1 \n")
        end
        println("(", value(x[i]), ",", value(y[i]), ")")
    end
end
close(file)

file =  open("area.txt","w")

for i=1:4
    write(file, "$(area[i, 1]), $(area[i, 2]) \n")
end
close(file)

file =  open("parking_size.txt","w")
write(file, "$w, $h, $f \n")
close(file)

## PRINT SOLUTION
println("Objective Value: ", objective_value(m))

println("x-values = ", value.(x))
println("y-values = ", value.(y))
println("z-values = ", value.(z))
println("uxy-values = ", value.(uxy))
println("r-values = ", value.(r))
println("b-values = ", value.(b))
