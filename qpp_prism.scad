include <qpp_constants.scad>
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
// '-> argument "points" is a list of points defining the base of the shape in xy-plane
//     '-> points are expected to be 2D, or 3D (see case below)
// '-> argument "h" is the height of the prism in z-axis
// '-> optional "off" is the arbitrary 3D vector transforming the origin between the base and the top of the origin
//     '-> "off" overrides the argument "h"
//     '-> if present the "points" must be a list of 3D points
module qpp_prism(points=[[0,0],[1,0],[0,1]], h=1, off=undef)
{
    _module_name = "[QPP-prism]";
    // check the length of points
    assert(is_list(points),      str(_module_name, " argument \"points\" is not a list!"));
    assert(qpp_len(points) >= 3, str(_module_name, " argument \"points\" must contain at least three elements!"));

    _is_2D = is_undef(off);
    for(_point=points)
    {
        assert(!_is_2D || qpp_len(_point) == 2, str(_module_name, " some point in argument \"points\" is not 2D!"));
        assert( _is_2D || qpp_len(_point) == 3, str(_module_name, " some point in argument \"points\" is not 3D!"));
    }

    // TODO check self-intersection
    
    // check off
    assert(is_undef(off) || qpp_len(off)==3, str(_module_name, " argument \"off\" is not 3D vector!"));
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

// module for creating vertical prisms with rounded corners in xy-plane
// '-> argument "points" is a list of points defining the base of the shape in xy-plane
//     '-> points are expected to be 2D, or 3D (see case below)
// '-> argument "h" is the height of the prism in z-axis
// '-> argument "d" or "r" defines rounding diameter or radius respectively
// NOTE: that argument "off" is not avaliable since there is no hull operation keeping the z-dimension for two 2D object
//       '-> see: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#hull
module qpp_cylindroprism(points=[[0,0],[1,0],[0,1]], h=1, r = 0.1, d = undef, $fn=qpp_fn)
{
    // module name
    _module_name = "[QPP-cylindroprism]";
    
    // check points similar to qpp_prism
    assert(is_list(points),      str(_module_name, " argument \"points\" is not a list!"));
    assert(qpp_len(points) >= 3, str(_module_name, " argument \"points\" must contain at least three elements!"));

    // check points dimension size
    for(_point=points)
    {
        assert(qpp_len(_point) == 2, str(_module_name, " some point in argument \"points\" is not 2D!"));
    }

    // get radius
    _r = is_undef(d) ? r : d/2;
    // check radius
    assert(_r >= 0, str(_module_name, " argument \"r\", neither \"d\" can be negative!"));

    // height
    _h_cylinder = h/5;
    _h_prism = h - _h_cylinder;

    minkowski()
    {
        // base prism
        linear_extrude(_h_prism)
            offset(r=-_r)
                polygon(points=points);
        // cylinder
        cylinder(r=_r,h=_h_cylinder,$fn=$fn);
    }
}

// module for creating vertical prisms with corners rounded in all axis
// '-> argument "points" is a list of points defining the base of the shape in xy-plane
//     '-> points are expected to be 2D, or 3D (see case below)
// '-> argument "h" is the height of the prism in z-axis
// '-> argument "d" or "r" defines rounding diameter or radius respectively
// NOTE: that argument "off" is not avaliable since there is no hull operation keeping the z-dimension for two 2D object
//       '-> see: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#hull
module qpp_spheroprism(points=[[0,0],[1,0],[0,1]], h=1, r = 0.1, d = undef, $fn=qpp_fn)
{
    // module name
    _module_name = "[QPP-cylindroprism]";
    
    // check points similar to qpp_prism
    assert(is_list(points),      str(_module_name, " argument \"points\" is not a list!"));
    assert(qpp_len(points) >= 3, str(_module_name, " argument \"points\" must contain at least three elements!"));

    // check points dimension size
    for(_point=points)
    {
        assert(qpp_len(_point) == 2, str(_module_name, " some point in argument \"points\" is not 2D!"));
    }

    // get radius
    _r = is_undef(d) ? r : d/2;
    // check radius
    assert(_r >= 0, str(_module_name, " argument \"r\", neither \"d\" can be negative!"));
    assert(2*_r <= h, str(_module_name, " argument \"h\" (height) is not big enought for provided arguments \"r\"|\"d\"!"));

    // height
    _h_prism = h - 2*_r;

    translate([0,0,_r])
        minkowski()
        {
            // base prism
            linear_extrude(_h_prism)
                offset(r=-_r)
                    polygon(points=points);
            // cylinder
            sphere(r=_r,$fn=$fn);
        }
}

// module for regular prism
// '-> argument "n_sides" defines number of regular polygon used as prism base
// '-> argument "h" is the height of the regular prism in z-axis
// '-> argument "D" or "R" defines the diameter or radius of the base incircled/excircled circle respectively.
// '-> argument "side" is a length of the the regular prism base side
// '-> argument "align_along_x" defines whether the prism sides should be aligned with the x axis
// TODO: add optional tip with given height "ht"
module qpp_regular_prism(n_sides=5, h=1, R=0.5, D=undef, side=undef, incircle=true, align_along_x=true, __module_name="[QPP-regular_prism]")
{
    // module name
    _module_name = __module_name;
    
    // check number of sides
    assert(n_sides >= 3, str(_module_name, " argument \"n_sides\" must be at least three!"));

    // get side
    _using_side = !is_undef(side);

    // get radius
    __r = is_undef(D) ? R : D/2;
    
    // check radius
    assert( _using_side ||  __r >= 0, str(_module_name, " argument \"R\", neither \"D\" can be negative!"));
    assert(!_using_side || side >= 0, str(_module_name, " argument \"side\" cannot be negative!"));

    // compute radius
    _r = _using_side ?
            (side/2)/sin(360/(2*n_sides)) : 
            incircle ? __r : __r/(cos(360/(2*n_sides)));

    // handle rotation alignment
    _z_rot = align_along_x ? -90-360/(2*n_sides) : 0;
    rotate([0,0, _z_rot])
        // base shape
        cylinder(r=_r, h=h,$fn=n_sides);
}

// module for regular prism with corners rounded in all axis
// '-> argument "n_sides" defines number of regular polygon used as prism base
// '-> argument "h" is the height of the regular prism in z-axis
// '-> argument "D" or "R" defines the diameter or radius of the base incircled/excircled circle respectively.
// '-> argument "side" is a length of the the regular prism base side
// '-> argument "d" or "r" defines rounding diameter or radius respectively
// '-> argument "align_along_x" defines whether the prism sides should be aligned with the x axis
// TODO: make "d" and "r" to possibly be 2D array
// TODO: add optional tip with given height "ht"
module qpp_regular_spheroprism(n_sides=5, h=1, R=0.5, D=undef, side=undef, r=0.1, d=undef, incircle=true, align_along_x=true, $fn=qpp_fn)
{
    // module name
    _module_name = "[QPP-regular_sphreroprism]";
    
    // compute radius
    _r = is_undef(d) ? r : d/2;

    // check the rounding radius
    assert(_r >= 0, str(_module_name, " argument \"r\", neither \"d\" can be negative!"));
    assert(2*_r <= _h, str(_module_name, " argument \"h\" (height) is not big enought for provided arguments \"r\"|\"d\"!"));

    // compute new _R and _D
    _r_diff = _r/(cos(360/(2*n_sides)));
    _R = R - _r_diff;
    _D = is_undef(D) ? D : D-2*_r_diff;
    _h = h - 2*_r;

    // crreating shape using minkowski sum 
    minkowski()
    {
        // basic shape
        translate([0,0,_r])
            qpp_regular_prism(n_sides=n_sides, h=_h, R=_R, D=_D, side=side, incircle=incircle, align_along_x=align_along_x, __module_name=_module_name);
        // sphere
        sphere(r=_r, $fn=$fn);
    }
}

// module for regular prism with corners rounded in xy-axis
// '-> argument "n_sides" defines number of regular polygon used as prism base
// '-> argument "h" is the height of the regular prism in z-axis
// '-> argument "D" or "R" defines the diameter or radius of the base incircled/excircled circle respectively.
// '-> argument "side" is a length of the the regular prism base side
// '-> argument "d" or "r" defines rounding diameter or radius respectively
// '-> argument "align_along_x" defines whether the prism sides should be aligned with the x axis
// TODO: make "d" and "r" to possibly be 2D array
// TODO: add optional tip with given height "ht"
module qpp_regular_cylindroprism(n_sides=5, h=1, R=0.5, D=undef, side=undef, r=0.1, d=undef, incircle=true, align_along_x=true, $fn=qpp_fn)
{
    // module name
    _module_name = "[QPP-regular_cylindroprism]";
    
    // compute radius
    _r = is_undef(d) ? r : d/2;

    // check the rounding radius
    assert(_r >= 0, str(_module_name, " argument \"r\", neither \"d\" can be negative!"));

    // compute new _R and _D
    _R = R-_r;
    _D = is_undef(D) ? D : D-2*_r;
    _h_cylinder = h/5;
    _h_prism = h - _h_cylinder;

    // crreating shape using minkowski sum 
    minkowski()
    {
        // basic shape
        qpp_regular_prism(n_sides=n_sides, h=_h_prism, R=_R, D=_D, side=side, incircle=incircle, align_along_x=align_along_x, __module_name=_module_name);
        // cylinder
        cylinder(r=_r, h=_h_cylinder, $fn=$fn);
   }

}