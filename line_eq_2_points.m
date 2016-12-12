function [ line ] = line_eq_2_points( x, y )
    line.m = (y(2) - y(1)) / (x(2) - x(1));
    line.n = (y(2) * x(1) - y(1) * x(2)) / (x(1) - x(2));
end

