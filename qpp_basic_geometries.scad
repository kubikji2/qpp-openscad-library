include<qpp_constants.scad>
use <qpp_utils.scad>

// toroid shape
// '-> argument "R"|"D" is radius/diameter of the outer circle if projected to xy-plane
// '-> argument "r"|"d" is radius/diameter of the inner circle if projected to the xy-plane
// '-> argument "t" is the thicknes of the torioid, i.e. diameter of the circle if projected to the xz-plane
module qpp_toroid(R=undef, D=undef, r=undef, d=undef, t=undef, $fn=qpp_fn)
{
    _module_name = "[QPP-toroid]";

    // select arguments
    ___R = is_undef(D) ? R : D/2;
    ___r = is_undef(d) ? r : d/2;
    __t = t;

    // decide whther use default parameters
    _use_default = qpp_count_def([___R, ___r, __t]) == 0;
    __R = _use_default ? 1 : ___R;
    __r = _use_default ? 0.2 : ___r;
    
    // get total number of defined parameters
    _def_mtx_arg_cnt = qpp_count_def([__R, __r, __t]);

    // there must be 0 or 2 defined variables
    assert(_def_mtx_arg_cnt == 0 || _def_mtx_arg_cnt == 2, str(_module_name,  "none or 2 arguments must be defined in 2-mutex argument group (\"R\"|\"D\",\"r\"|\"d\",\"t\"), but ", str(_def_mtx_arg_cnt) ," are defined!"));

    // select appropriate pairs used
    _is_Rr_def = qpp_count_def([__R,__r]) == 2;
    _is_Rt_def = qpp_count_def([__R,__t]) == 2;
    _is_rt_def = qpp_count_def([__r,__t]) == 2;

    // finalize variables
    _r = _is_Rt_def ? __R-__t : __r;
    _R = _is_rt_def ? __r+__t : __R;
    _t = _is_Rr_def ? __R-__r : __t;

    // construct geometry
    rotate_extrude(convexity=4, $fn=$fn)
        translate([_t+_r,0,0])
            circle(r=_t, $fn=$fn);

}