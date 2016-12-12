function [ p ] = int_point( l1, l2)
    p(1) = (l2.n - l1.n) / (l1.m - l2.m);
    p(2) = (l2.n * l1.m - l1.n * l2.m) / (l1.m - l2.m);
end

