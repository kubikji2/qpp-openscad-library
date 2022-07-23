// use utils
use <qpp_utils.scad>

// include constants
include <qpp_constants.scad>

module qpp_dice(size=1, r=0.75, fn=qpp_fn, unsafe_mode=false)
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

    // if all parsing succeed, time for computation
    if (_is_size_list != -1 && _nonuniform_scale != -1)
    {    
        // unpack/copy size variables
        _a = _is_size_list == 1 ? _size.x : _size;
        _b = _is_size_list == 1 ? _size.y : _size;
        _c = _is_size_list == 1 ? _size.z : _size;

        // create scaling factor to transform sphere to elypsis
        _min_r = _nonuniform_scale == 1 ? min(_r) : _r;
        _sx = _nonuniform_scale == 1 ? _r.x/_min_r : _r/_min_r;
        _sy = _nonuniform_scale == 1 ? _r.y/_min_r : _r/_min_r; 
        _sz = _nonuniform_scale == 1 ? _r.z/_min_r : _r/_min_r;
        
        // create a dice
        intersection()
        {
            scale([_sx,_sy,_sz]) sphere(r=_min_r, $fn=fn);
            cube([_a,_b,_c], center=true);
        }
    }

}

R = [8,6,8];
qpp_dice(size=[10,10,10],r=R, unsafe_mode=true);
scale(R) sphere(r=1,$fn=qpp_fn);
%cube([1,1,1], center=true);
