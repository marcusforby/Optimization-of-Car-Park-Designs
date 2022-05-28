using JuMP
using Cbc
using DelimitedFiles

######## USER DEFINED VARIABLES ########
xmin = 0
xmax = 17
ymin = 0
ymax = 34
interval = 0.5
parking_size = [2.5 5 7];
########################################


## LOADING VARIABLES
m = Model(Cbc.Optimizer)
w = parking_size[1];
h = parking_size[2];
f = parking_size[3];
area = [xmin ymin; xmax ymin; xmax ymax; xmin ymax];
ny = Int(floor((ymax-ymin-h-f)/interval))+1
nx = Int(floor((xmax-xmin-w)/interval))+1
n = ny*nx
M = max(ymax-ymin, xmax-xmin)
xs = collect(range(xmin+w/2, xmax-w/2, length=nx))
ys = collect(range(ymin+h/2, ymax-h/2-f, length=ny))

X = []
for i=1:ny
    append!(X, xs)
end

Y = []
for i=1:ny
    append!(Y, ys[i]*ones(nx))
end

## DEFINING VARIABLES
@variable(m, z[1:nx,1:ny], Bin)

## DEFINING OBJECTIVE FUNCTION
@objective(m, Max, sum(z[i, j] for i=1:nx for j=1:ny))


## DEFINING CONSTRAINTS
for i=1:nx
    for j=1:ny
        x_coordinates = [i]
        y_coordinates = [j]
        for b=i:nx
            for g=j:ny
                if b != i || g != j
                    if w > abs(xs[b] - xs[i])
                        if h + f > abs(ys[j] - ys[g])
                            append!(x_coordinates, b)
                            append!(y_coordinates, g)
                        end
                    end
                end
            end
        end
        @constraint(m, sum(z[x_coordinates[l], y_coordinates[l]] for l=1:length(x_coordinates)) <= 1)
    end
end


## OPTIMIZE
optimize!(m)


## PRINT OUTPUT
println("Objective Value: ", objective_value(m))

file =  open("points.txt","w")

for i=1:nx
    for j=1:ny
        if value(z[i, j]) == 1
            write(file, "$(xs[i]), $(ys[j]), 0, 3 \n")
            println("(", value(xs[i]), ",", value(ys[j]), ")")
        end
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

println("z-values = ", value.(z))
