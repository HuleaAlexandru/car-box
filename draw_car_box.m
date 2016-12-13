function [car] =  draw_car_box( img, width, height )
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
    
    d_box = [[1, width, width, 1]; [height, height, 1, 1]]';
    plot_offset = 20;
    callback([]);
    
    addNewPositionCallback(vl, @(pos)callback(pos));
    addNewPositionCallback(hl, @(pos)callback(pos));
            
    function callback(pos)
        delete(car_box);
        
        v_pos = getPosition(vl);
        h_pos = getPosition(hl);
        
        ox = v_pos(:, 1);
        oy = v_pos(:, 2);
        [vx, vy] = shrink(ox, oy, plot_offset);
        
        ox = h_pos(:, 1);
        oy = h_pos(:, 2);
        [hx, hy] = shrink(ox, oy, plot_offset);
        
        v = line_eq_2_points(vx, vy);
        h = line_eq_2_points(hx, hy);
        
        s = line_eq_point_slope([vx(1), vy(1)], h.m);
        n = line_eq_point_slope([vx(2), vy(2)], h.m);
        v = line_eq_point_slope([hx(1), hy(1)], v.m);
        e = line_eq_point_slope([hx(2), hy(2)], v.m);
        
        p1 = int_point(v, s);
        p2 = int_point(s, e);
        p3 = int_point(e, n);
        p4 = int_point(n, v);
           
        s_box = [p2; p1; p4; p3];
        p = [s_box; p2];
        
        car_box = plot(orig_axes, p(:, 1), p(:, 2), 'g'); 
        
        % compute affine trans
        a = find_affine_trans(d_box, s_box);
        
        car = uint8(zeros(height, width, 3));
        for i = 1:height
            for j = 1:width
                try
                    n_idx = int16(a.m * [j; i] + a.t);
                    car(i, j, :) = img(n_idx(2), n_idx(1), :);
                catch
                end
            end
        end
        
        imshow(car, 'Parent', car_axes);
    end
end

