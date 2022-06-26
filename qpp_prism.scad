use <qpp_utils.scad>

// generate prism shell idx based on the total number of sides
function qpp_prism_shell_idx(n_sides) =
    [   for (i=[0:n_sides-1])
        [
            n_sides + i,
            n_sides + (i+1) % n_sides,
            (i+1) % n_sides,
            i
        ]
    ];

// module for creating vertical prisms
// '-> variable "points" is a list of points defining the base of the shape in xy-plane
//     '-> points are expected to be 2D, or 3D (see case below)
// '-> variable "h" is the height of the prism in z-axis
// '-> optional "off" is the arbitrary 3D vector transforming the origin between the base and the top of the origin
//     '-> "off" overrides the variable "h"
//     '-> if present the "points" must be a list of 3D points
module qpp_prism(points=[[0,0],[1,0],[0,1]], h=1, off=undef)
{
    _module_name = "[QPP-prism]";
    // check the length of points
    assert(is_list(points),      str(_module_name, " variable \"points\" is not a list!"));
    assert(qpp_len(points) >= 3, str(_module_name, " variable \"points\" must contain at least three elements!"));

    _is_2D = is_undef(off);
    for(_point=points)
    {
        assert(!_is_2D || qpp_len(_point) == 2, str(_module_name, " some point in variable \"points\" is not 2D!"));
        assert( _is_2D || qpp_len(_point) == 3, str(_module_name, " some point in variable \"points\" is not 3D!"));
    }

    // TODO check points orientation using vector product and scalar product
    // '-> first get normal of the plane using vector product of vecotors (B - A) x (C - A)
    // '-> second:
    //     '-> for 3D points get scalar product on normal and the offset vector
    //     '-> for 2D points create offset vector
    // '-> lastly compute scalar product on normalized normal and normalized offset vectors
    //     '-> for scalar product > 0, ok
    //     '-> for scalar prodcut < 0, there are fucked up orders
    
    // check off
    assert(is_undef(off) || qpp_len(off)==3, str(_module_name, " variable \"off\" is not 3D vector!"));
    _off = _is_2D ? [0,0,h] : off;

    _points = _is_2D ? [for (_point=points) [_point[0],_point[1], 0] ] : points;
    // create base and top points
    _3D_points_base = _points;
    //echo(_3D_points_base);
    _3D_points_top = [for (_point=_points) [_point[0]+_off[0],_point[1]+_off[1],_point[2]+_off[2]] ];
    //echo(_3D_points_top);

    // create points
    _3D_points = [for (_point=_3D_points_base) _point, for (_point=_3D_points_top) _point];
    //echo(_3D_points);

    // create facets
    _n_sides = len(points);
    // '-> create shell
    _shell_idxs = qpp_prism_shell_idx(_n_sides);
    // '-> join base, shell and top into the facet
    _faces = [
                // base
                [for(i=[0:_n_sides-1]) i],
                // expanded shell
                each _shell_idxs,
                // top, but in inversed order
                [for(i=[0:_n_sides-1]) 2*_n_sides-i-1]
             ];
    //echo(_faces)

    // create geometry
    polyhedron(_3D_points, _faces);

}