use<qpp_utils.scad>
include<qpp_constants.scad>

// this module creates cylindrocube/cylindrocuboid
// '-> variable "size" is either:
//     '-> [x,y,z,rx,ry] - where x,y,z are cuboid dimensions the rx,ry are respective radii of its corner cuts 
//     '-> [x,y,z,r] - where x,y,z are cuboid dimensions and the r is the radius of its corner cuts
//     '-> [a,r] - where the a is the lendght of the cube edge and the r is the radius of its corner cuts
// '-> one can override the "size" by "xyz" and "r" variables iff both are defined
// '-> variable "xyz" can either be:
//     '-> [x,y,z], [a] or a
// '-> variable "r" can either be:
//     '-> r, [r] or [rx,ry]
// NOTE that using "xyz" and "r" supports wider range of combination
// '-> parameter "fn" is used to define the granurality of the corner spheres 
module qpp_cylindrocube(size=[1,1,1,0.45], xyz=undef, r=undef, fn=qpp_fn)
{

    _module_name = "[QPP-CylindroCube]";

    // check size vector
    assert(is_list(size), str(_module_name, " variable \"size\" is not list!"));
    assert(qpp_check_lens(len(size),[2,4,5]), str(_module_name, " variable \"size\" has len=", str(len(size)), " but only len in [2,4,5] is allowed!"));
    
    // check xyz and r for definition
    _all_def = !is_undef(xyz) && !is_undef(r);
    _use_size = !_all_def;
    assert(is_undef(xyz) == is_undef(r), str(_module_name, " not all variables are defined: \"xyz\"=", str(is_undef(xyz)) ? ">undef<" : str(xyz), " and \"r\"=", str(is_undef(r) ? ">undef<" : str(r)), "!"));

    // check xyz
    _xyz_u = qpp_try_to_unpack_list(xyz);
    // check xyz length
    assert(_use_size || qpp_is_valid_3D_list(_xyz_u) != -1, str(_module_name, " variable \"xyz\" has len=", qpp_len_s(xyz), " but only len in [1,3] is allowed!"));
    // expand xyz into 3D vector
    _xyz = is_list(_xyz_u) ?
                _xyz_u :
                [_xyz_u,_xyz_u,_xyz_u];

    // check r
    _r_u = qpp_try_to_unpack_list(r);
    // check r length
    assert(_use_size || qpp_is_valid_2D_list(_r_u) != -1, str(_module_name, " variable \"r\" has len=", qpp_len_s(r), " but only len in [1,2] is allowed!"));
    // expand r into 3D vector
    _r = is_list(_r_u) ? 
            _r_u :
            [_r_u,_r_u];

    // expand size 
    _size = len(size) == 2 ?
                [size[0],size[0],size[0],size[1],size[1]] :
                len(size) == 4 ?
                    [size[0],size[1],size[2],size[3],size[3]] :
                    size;
    // create variables use for the 
    _X  = _use_size ? _size[0] : _xyz[0];
    _Y  = _use_size ? _size[1] : _xyz[1];
    _Z  = _use_size ? _size[2] : _xyz[2];
    _rx = _use_size ? _size[3] : _r[0];
    _ry = _use_size ? _size[4] : _r[1];
    _h = 0.1*_Z;
    
    _x = _X - 2*_rx;
    _y = _Y - 2*_ry;
    _z = _Z - _h;

    // check cuboid size
    assert((_x > 0) && (_y > 0), str(_module_name, " geometry dimensions=", str([_X,_Y]), " are too small for corner cuts=", str([_rx,_ry]), "!"));
    // create final geometry using minkowski sum (fastest known approach)
    translate([_rx,_ry,0])
        minkowski()
        {
            resize([2*_rx,2*_ry,_h])
                cylinder(r=1,$fn=fn);
            cube([_x,_y,_z]);
        }

}