function [ line ] = line_eq_point_slope( p, m )
    line.m = m;
    line.n = p(2) - m * p(1);
end

