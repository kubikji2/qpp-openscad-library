include <qpp_utils.scad>

// toroid shape
// '-> argument "R"|"D" is radius/diameter of the outer circle if projected to xy-plane
// '-> argument "r"|"d" is radius/diameter of the inner circle if projected to the xy-plane
// '-> argument "t" is the thicknes of the torioid, i.e. diameter of the circle if projected to the xz-plane
module qpp_toroid(R=undef, D=undef, r=undef, d=undef, t=undef)
{
    _module_name = "[QPP-toroid]";

    // select arguments
    __R = is_undef(D) ? R : D/2;
    __r = is_undef(d) ? r : d/2;
    __t = t;
    
    // get total number of defined parameters
    _mtx_args = [__R, __r, __t];
    _def_mtx_arg_cnt = qpp_sum_vec([for(_arg=_mtx_args) is_undef(_arg) ? 0 : 1]);


}