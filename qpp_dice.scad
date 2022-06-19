// use utils
use <qpp_utils.scad>

// include constants
include <qpp_constants.scad>

// TODO improve this to be more perceptually scalable
//function qpp_cube_adaptive_radius(r,min_r,a) = (0.5*r+0.5)*a/min_r;

function qpp_compute_adaptive_radius(r,a) = (r+1)*a;

// QPP DICE geometry
// parameters:
// size - defines size of the basic cuboid , either scalar, 1D or 3D array
// '-> if scalar or 1D array, cuboid xyz dimensions are considered equal to this value, e.g. cube
// '-> if 3D array cuboid xyz dimensions are equal to those value
// r - defines the radius of the sphere intersecting with the cuboid to create typical shape, either scalar, 1D or 3D array
// '-> if scalar or 1D array, ellipsoid xyz dimensions are considered equal to this value, e.g. sphere
// '-> if 3D array ellipsoid xyz dimensions are equal to those value
// fn - just regular fn variable defining the smoothness of the sphere approximation
// adaptive_corners - defines whether the sphere/ellipsoid is adapted to the cuboid size
// '-> if turned on, r is expected to be within the range (0,1)
//     '-> r = 0 -> the resulting shape is sphere/ellipsoid
//     '-> r = 1 -> the resulting shape is cube/cuboid
//     '-> other values iterate between -> TODO how
// unsafe_mode - if activated, all possible combanation of cube/cuboid and sphere/ellispoid
module qpp_dice(size=1, r=0.75, fn=qpp_fn, adaptive_corners=false, unsafe_mode=false)
{   
   // unpack possible single item list
    _size = qpp_try_to_unpack_list(size);
    // check if extracted variable is valid size list
    _is_size_list = qpp_is_valid_3D_list(_size);

    // check for incorrect size len
    assert(_is_size_list != -1, qpp_assert_len_txt("DICE",size,"size"));
    
    // unpack possible single item list
    _r = qpp_try_to_unpack_list(r);
    // check for non)uniform scale
    _nonuniform_scale = qpp_is_valid_3D_list(_r);

    // check for incorrect size len
    assert(_nonuniform_scale != -1, qpp_assert_len_txt("DICE",r,"r"));
    
    // check the size and r for strange cases
    if (_is_size_list == 1 && _nonuniform_scale == 0)
    {
        assert(unsafe_mode, "[QPP-DICE] using uniform corner radius is not recommended for block. If this is intentional set 'unsafe_mode=true'.");
    }

    // check adaptive corners
    if (adaptive_corners)
    {
        assert(!is_list(r) || len(r) == 1,"[QPP-DICE] adaptive corners cannot be combined with non-uniform 'r'! Make 'r' scalar.");
        assert(r > 0 && r < 1, "[QPP-DICE] scale radius 'r' is not within allowed range (0,1).");
    }
    // check for possible adaptivity
    adaptivity_ok = (!adaptive_corners) || (!is_list(_r) && _r > 0 && _r < 1);

    // if all parsing succeed, time for computation
    if (_is_size_list != -1 && _nonuniform_scale != -1 && adaptivity_ok)
    {    
        // unpack/copy size variables
        _x = _is_size_list == 1 ? _size.x : _size;
        _y = _is_size_list == 1 ? _size.y : _size;
        _z = _is_size_list == 1 ? _size.z : _size;

        // decide scale coefs base on the uniformity
        _rx = _nonuniform_scale == 1 ? _r.x : _r;
        _ry = _nonuniform_scale == 1 ? _r.y : _r;
        _rz = _nonuniform_scale == 1 ? _r.z : _r;

        // decicde scale coefs based on the adaptivity
        _sx = adaptive_corners ? qpp_compute_adaptive_radius(_r,_x) : _rx;
        _sy = adaptive_corners ? qpp_compute_adaptive_radius(_r,_y) : _ry;
        _sz = adaptive_corners ? qpp_compute_adaptive_radius(_r,_z) : _rz;

        intersection()
        {
            resize(newsize=[_sx, _sy, _sz]) sphere(r=1, $fn=fn);
            cube([_x,_y,_z], center=true);
        }

    }

}

//R = [8,6,8];
//qpp_dice(size=[10,20,30],r=0.5, unsafe_mode=true, adaptive_corners=true);
//scale(R) sphere(r=1,$fn=qpp_fn);
//%cube([1,1,1], center=true);
