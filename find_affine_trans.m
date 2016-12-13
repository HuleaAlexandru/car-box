function [ trans ] = find_affine_trans( s, d)
    if sum(size(s) ~= size(d)) ~= 0
        error('input dimmensions don t match');
    end
    
    if size(s, 2) ~= 2
        error('invalid input size');
    end
    
    [n, ~] = size(s);
    ax = horzcat(s, zeros(n, 2), ones(n, 1), zeros(n, 1));
    ay = horzcat(zeros(n, 2), s, zeros(n, 1), ones(n, 1));
    
    a = zeros(2 * n, 6);
    a(1:2:2*n, :) = ax;
    a(2:2:2*n, :) = ay;
    
    b = zeros(2 * n, 1);
    b(1:2:2*n) = d(:, 1);
    b(2:2:2*n) = d(:, 2);
    
    x = pinv(a'*a) * a' * b;
    trans.m = reshape(x(1:4), [2, 2])'; % rotation + scale + shear
    trans.t = x(5:6); % translation
end

