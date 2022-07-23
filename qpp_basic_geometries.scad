include<qpp_constants.scad>
use <qpp_utils.scad>


// module used internally by qpp_toroid and qpp_ring since they most of the code is shared
/*
module __qpp_toroid_or_ring(is_toroid, R=undef, D=undef, r=undef, d=undef, t=undef, h=undef, fn=$fn)
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
        rotate_extrude(convexity=4, $fn=fn)
        translate([_R-_t,0,0])
            circle(r=_t, $fn=fn);
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
*/

// ring a.k.a. annular cylinder
// '-> argument 'R'|'D' defines the radius/diameter of the outer circle projected to xy-plane
// '-> argument 'r'|'d' defines the radius/diameter of the inner circle projected to xy-plane
// '-> argument 't' is the width of the the annulus projected to xy-plane
// NOTE: {"R"|"D", "r"|"d", "t" } is 2-mutex group meaning that 2 parameters must be defined
// '-> argument "h" is a height of the ring
// '-> argument "fn" is just $fn
/*
module qpp_ring(R=undef, D=undef, r=undef, d=undef, t=undef, h=1, fn=$fn)
{

    _module_name = "[QPP-ring]";

    // process h
    _h = h;
    assert(h>0, str(_module_name, " argument \"h\" (heigh) muset be positive!"));

    __qpp_toroid_or_ring(is_toroid=false, R=R, D=D, r=r, d=d, t=t, h=_h, fn=fn);

}
*/


// toroid shape
// '-> argument "R"|"D" is radius/diameter of the outer circle if projected to xy-plane
// '-> argument "r"|"d" is radius/diameter of the inner circle if projected to the xy-plane
// '-> argument "t" is the thickness of the torioid, i.e. diameter of the circle if projected to the xz-plane
// NOTE: {"R"|"D", "r"|"d", "t" } is 2-mutex group meaning that 2 parameters must be defined
// '-> argumen "fn" is just $fn
module qpp_toroid(R=undef, D=undef, r=undef, d=undef, t=undef, fn=$fn)
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
    rotate_extrude(convexity=4, $fn=fn)
        translate([_R-_t,0,0])
            circle(r=_t, $fn=fn);
    
}

// ring a.k.a. annular cylinder
// '-> argument 'R'|'D' defines the radius/diameter of the outer circle projected to xy-plane
//     '-> for conical variant use 'R1,R2'|'D1,D2'
//         '-> 'R1'|'D1' defines the radius/diameter of the outer circle projected to xy-plane at z=0
//         '-> 'R2'|'D2' defines the radius/diameter of the outer circle projected to xy-plane at z='h'
// '-> argument 'r'|'d' defines the radius/diameter of the inner circle projected to xy-plane
//     '-> for conical variant use 'r1,r2'|'d1,d2'
//         '-> 'r1'|'d1' defines the radius/diameter of the inner circle projected to xy-plane at z=0
//         '-> 'r2'|'d2' defines the radius/diameter of the inner circle projected to xy-plane at z='h'
// '-> argument 't' defines the width of the the annulus projected to xy-plane
//     '-> for conical variant use 't1,t2'
//         '-> 't1' defines the width of the the annulus projected to xy-plane at z=0
//         '-> 't2' defines the width of the the annulus projected to xy-plane at z='h'
// NOTE: {"R"|"D", "r"|"d", "t" } is 2-mutex group meaning that 2 arguments must be defined
// NOTE: conical and non-conical argument versions can be combined, but at least two arguments must always be defined
// '-> argument "h" is a height of the ring
// '-> argument "fn" is just $fn
module qpp_ring(R=undef, R1=undef, R2=undef,
                D=undef, D1=undef, D2=undef,
                r=undef, r1=undef, r2=undef,
                d=undef, d1=undef, d2=undef,
                t=undef, t1=undef, t2=undef, h=1, fn=$fn)
{

    _module_name = "[QPP-ring]";

    // check the triplets
    assert(is_undef(R1)==is_undef(R2), str(_module_name, " both argument \"R1\" and \"R2\ must be defined!"));
    assert(is_undef(r1)==is_undef(r2), str(_module_name, " both argument \"r1\" and \"r2\ must be defined!"));
    assert(is_undef(D1)==is_undef(D2), str(_module_name, " both argument \"D1\" and \"D2\ must be defined!"));
    assert(is_undef(d1)==is_undef(d2), str(_module_name, " both argument \"d1\" and \"d2\ must be defined!"));
    assert(is_undef(t1)==is_undef(t2), str(_module_name, " both argument \"t1\" and \"t2\ must be defined!"));

    __R1 = is_undef(R1) ? R : R1;
    __R2 = is_undef(R2) ? R : R2;
    __D1 = is_undef(D1) ? D : D1;
    __D2 = is_undef(D2) ? D : D2;

    __r1 = is_undef(r1) ? r : r1;
    __r2 = is_undef(r2) ? r : r2;
    __d1 = is_undef(d1) ? d : d1;
    __d2 = is_undef(d2) ? d : d2;

    _t1 = is_undef(t1) ? t : t1;
    _t2 = is_undef(t2) ? t : t2;

    _r1 = is_undef(__d1) ? __r1 : __d1/2;
    _r2 = is_undef(__d2) ? __r2 : __d2/2;
    _R1 = is_undef(__D1) ? __R1 : __D1/2;
    _R2 = is_undef(__D2) ? __R2 : __D2/2;


    // call general ring module
    __qpp_general_ring(R1=_R1, R2=_R2, r1=_r1, r2=_r2, t1=_t1, t2=_t2, h=1, fn=fn);

}


module __qpp_general_ring(R1=undef, R2=undef, r1=undef, r2=undef, t1=undef, t2=undef, h=1, fn=$fn)
{

    _module_name = "[QPP-ring]";

    // decide whther use default parameters
    _use_default = qpp_count_def([R1, r1, t1]) == 0;
    __R1 = _use_default ? 1 : R1;
    __R2 = _use_default ? 1 : R2;
    __r1 = _use_default ? 0.2 : r1;
    __r2 = _use_default ? 0.2 : r2;
    __t1 = t1;
    __t2 = t2;
    
    // get total number of defined parameters
    _def_mtx_arg_cnt = qpp_count_def([__R1, __r1, __t1]);

    // there must be 0 or 2 defined variables
    assert(_def_mtx_arg_cnt == 0 || _def_mtx_arg_cnt == 2, str(_module_name,  "none or 2 arguments must be defined in 2-mutex argument group (\"R|R1,R2\"|\"D|D1,D2\",\"r|r1,r2\"|\"d|d1,d2\",\"t|t1,t2\"), but ", str(_def_mtx_arg_cnt) ," are defined!"));

    // select appropriate pairs used
    _is_Rr_def = qpp_count_def([__R1,__r1]) == 2;
    _is_Rt_def = qpp_count_def([__R1,__t1]) == 2;
    _is_rt_def = qpp_count_def([__r1,__t1]) == 2;

    // finalize variables
    _r1 = _is_Rt_def ? __R1-__t1 : __r1;
    _r2 = _is_Rt_def ? __R2-__t2 : __r2;
    _R1 = _is_rt_def ? __r1+__t1 : __R1;
    _R2 = _is_rt_def ? __r2+__t2 : __R2;

    // construct geometry
    // TODO improve visuals
    difference()
    {
        cylinder(r1=_R1,r2=_R2, h=h);
        cylinder(r1=_r1,r2=_r2, h=h);        
    }

}
