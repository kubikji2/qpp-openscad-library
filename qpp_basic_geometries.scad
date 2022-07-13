include<qpp_constants.scad>
use <qpp_utils.scad>

module __qpp_toroid_or_ring(is_toroid, R=undef, D=undef, r=undef, d=undef, t=undef, h=undef, $fn=qpp_fn)
{
    _module_name = is_toroid ? "[QPP-toroid]" : "[QPP-ring]";

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
    if (is_toroid)
    {
        rotate_extrude(convexity=4, $fn=$fn)
        translate([_R-_t,0,0])
            circle(r=_t, $fn=$fn);
    }
    else
    {
        difference()
        {
            cylinder(r=_R,h=h);
            translate([0, 0, -qpp_eps])
                cylinder(r=_r,h=h+2*qpp_eps);
        }
    }

}


// toroid shape
// '-> argument "R"|"D" is radius/diameter of the outer circle if projected to xy-plane
// '-> argument "r"|"d" is radius/diameter of the inner circle if projected to the xy-plane
// '-> argument "t" is the thickness of the torioid, i.e. diameter of the circle if projected to the xz-plane
// NOTE: {"R"|"D", "r"|"d", "t" } is 2-mutex group meaning that 2 parameters must be defined
// '-> argumen "$fn" is just $fn
module qpp_toroid(R=undef, D=undef, r=undef, d=undef, t=undef, $fn=qpp_fn)
{

    __qpp_toroid_or_ring(is_toroid=true, R=R, D=D, r=r, d=d, t=t, $fn=$fn);
    
}

// ring a.k.a. annular cylinder
// '-> argument 'R'|'D' defines the radius/diameter of the outer circle projected to xy-plane
// '-> argument 'r'|'d' defines the radius/diameter of the inner circle projected to xy-plane
// '-> argument 't' is the width of the the annulus projected to xy-plane
// NOTE: {"R"|"D", "r"|"d", "t" } is 2-mutex group meaning that 2 parameters must be defined
// '-> argument "h" is a height of the ring
// '-> argument "$fn" is just $fn
module qpp_ring(R=undef, D=undef, r=undef, d=undef, t=undef, h=1, $fn=qpp_fn)
{

    _module_name = "[QPP-ring]";

    // process h
    _h = h;
    assert(h>0, str(_module_name, " argument \"h\" (heigh) muset be positive!"));

    __qpp_toroid_or_ring(is_toroid=false, R=R, D=D, r=r, d=d, t=t, h=_h, $fn=$fn);

}
