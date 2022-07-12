use <qpp_utils.scad>
include<qpp_constants.scad>

// wrinkled cylinder
// '-> 2-mutex argument "H" defines the height of the cylinder
// '-> argument "R"|"D" define the radius/diameter of the cylinder
// '-> argument "d" defines the depth of the wrinkles
//     '-> negative values of "d" results in "hills" rather than usual "ravines"
// '-> 2-mutex argument "h" defines the width of the wrinkles
// '-> 2-mutex argument "n_wrinkles" defines the number of wrinkles
//     '-> overrides argument "H"
// '-> additional argument "use_circular" specifies the wrinkles shape
//     '-> false - the wrinkles are v shapes
//     '-> true  - the wrinkles are half-circles
//         '-> the "d" argument is ignored
module qpp_wrinkled_cylinder(H=undef, R=0.5, D=undef, d=0.05, h=undef, n_wrinkles=undef, use_circular=false, $fn=qpp_fn)
{

    _module_name = "[QPP-wrinkled_cylinder]";
    
    // computing number of mutex variable
    _mtx_args = [H, h, n_wrinkles];
    _def_mtx_arg_cnt = qpp_sum_vec([for(_arg=_mtx_args) is_undef(_arg) ? 0 : 1]);
    
    // default parameter
    __H = _def_mtx_arg_cnt < 2 ? 1 : H;
    __h = _def_mtx_arg_cnt < 2 ? 0.1 : h;

    // defines which mutex args are used
    _is_Hh_def = !is_undef(H) && !is_undef(h);
    _is_Hn_def = !is_undef(H) && !is_undef(n_wrinkles);
    _is_nh_def = !is_undef(n_wrinkles) && !is_undef(h);

    // handle mtx cnt
    assert(_def_mtx_arg_cnt == 0 || _def_mtx_arg_cnt == 2, str(_module_name, " none or 2 arguments must be defined in 2-mutex argument group (\"H\",\"h\",\"n_wrinkles\"), but ", str(_def_mtx_arg_cnt) ," are defined!"));

    // handle R and D
    _R = is_undef(D) ? R : D/2;
    assert( _R > 0, str(_module_name, " argument \"R\"|\"D\" must be positive!"));

    // handle d
    _d = d;
    // no check, negative number means inverse wrinkle 

    // handle h
    _h = _is_Hn_def ? H/n_wrinkles : __h;
    assert( _h > 0, str(_module_name, " argument \"h\" must be positive!"));

    // handle H
    _H = _is_nh_def ? h*n_wrinkles : __H;
    assert( _H > 0, str(_module_name, " argument \"H\" must be positive!"));
    
    // handle n_wrinkles
    _n = _is_Hh_def || _def_mtx_arg_cnt==0 ? _H/_h : n_wrinkles;
    assert( _n > 0 && abs(round(_n)-_n) < qpp_eps, str(_module_name, _is_Hh_def ?
                                                                        " arguments \"h\" and \"H\" are not comprime numbers!" :
                                                                        " argument \"n_wrinkles\" is not integer or positive!"));

    // base geometry
    for(i=[0:_n-1])
    {
        translate([0,0,i*_h])
        {
            cylinder(r1=_R, r2=_R-_d, h=_h/2, $fn=$fn);
            translate([0,0,_h/2]) cylinder(r1=_R-_d, r2=_R, h=_h/2, $fn=$fn);
        }
    }
    /*
    qpp_repeat(n=_n,l=_h,dir="z")
    {
        cylinder(r1=_R, r2=_R-_d, h=_h/2, $fn=$fn);
            translate([0,0,_h/2]) cylinder(r1=_R-_d, r2=_R, h=_h/2, $fn=$fn);
    }
    */


}

