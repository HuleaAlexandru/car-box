function draw_car_box( img, width, height )
    figure;
    orig_axes = axes;
    imshow(img);
    hold on;

    vl = imline;
    setColor(vl, 'r');

    hl = imline;
    setColor(hl, 'g');
    
    figure;
    car_axes = axes;
        
    %first call
    car_box = plot([]);
    
    d_box = [[0, width, width, 0]; [0, 0, height, height]]';
    callback([]);

    addNewPositionCallback(vl, @(pos)callback(pos));
    addNewPositionCallback(hl, @(pos)callback(pos));
            
    function callback(pos)
        display(pos);
        delete(car_box);
        
        v_pos = getPosition(vl);
        h_pos = getPosition(hl);
        
        v = line_eq_2_points(v_pos(:, 1), v_pos(:, 2));
        h = line_eq_2_points(h_pos(:, 1), h_pos(:, 2));
        
        s = line_eq_point_slope(v_pos(1, :), h.m);
        n = line_eq_point_slope(v_pos(2, :), h.m);
        v = line_eq_point_slope(h_pos(1, :), v.m);
        e = line_eq_point_slope(h_pos(2, :), v.m);
        
        p1 = int_point(v, s);
        p2 = int_point(s, e);
        p3 = int_point(e, n);
        p4 = int_point(n, v);
        
        s_box = [p1; p2; p3; p4];
        p = [s_box; p1];
        car_box = plot(orig_axes, p(:, 1), p(:, 2), 'g'); 
        
       % compute affine trans
        a = find_affine_trans(d_box, s_box);
        
        car = zeros(height, width, 3);
        [x, y] = ind2sub([width, height], 1:height * width);
        new_xy = int16(a.m * [x; y] + a.t);
        
        [orig_indices] = sub2ind(size(img), new_xy(1, :), new_xy(2, :));
        
        r = img(:, :, 1);
        g = img(:, :, 2);
        b = img(:, :, 3);
        
        c_r = r(orig_indices);
        c_g = g(orig_indices);
        c_b = b(orig_indices);
        
        car(:, :, 1) = reshape(c_r, [height, width]);
        car(:, :, 2) = reshape(c_g, [height, width]);
        car(:, :, 3) = reshape(c_b, [height, width]);
        
        imshow(car, 'Parent', car_axes);
    end
end

