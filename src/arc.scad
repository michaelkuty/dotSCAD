/**
* arc.scad
*
* Creates an arc. You can pass a 2 element vector to define the central angle. 
* Its $fa, $fs and $fn parameters are consistent with the circle module.
* It depends on the circular_sector module so you have to include circular_sector.scad.
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-arc.html
*
**/ 

include <__private__/__frags.scad>;

module arc(radius, angles, width, width_mode = "LINE_CROSS") {

    w_offset = width_mode == "LINE_CROSS" ? [width / 2, -width / 2] : (
        width_mode == "LINE_INWARD" ? [0, -width] : [width, 0]
    );
    
    frags = __frags(radius);
    
    a_step = 360 / frags;
    half_a_step = a_step / 2;
    
    m = floor(angles[0] / a_step) + 1;
    n = floor(angles[1] / a_step);
    
    function unit_xy(a) = [cos(a), sin(a)];
    
    function edge_r_begin(orig_r, a) =
        let(leng = orig_r * cos(half_a_step))
        leng / cos(m * a_step - half_a_step - a);

    function edge_r_end(orig_r, a) =      
        let(leng = orig_r * cos(half_a_step))    
        leng / cos((n + 0.5) * a_step - a);
    
    r_outer = radius + w_offset[0];
    r_inner = radius + w_offset[1];
    
    points = concat(
        // outer arc path
        [edge_r_begin(r_outer, angles[0]) * unit_xy(angles[0])],
        [
            for(i = [m:n]) 
                r_outer * unit_xy(a_step * i)
        ],
        [edge_r_end(r_outer, angles[1]) *  unit_xy(angles[1])],
        // inner arc path
        [edge_r_end(r_inner, angles[1]) *  unit_xy(angles[1])],
        [
            for(i = [m:n]) 
                let(idx = (n + (m - i)))
                r_inner * unit_xy(a_step * idx)

        ],
        [edge_r_begin(r_inner, angles[0]) * unit_xy(angles[0])]        
    );
     
    polygon(points);
}