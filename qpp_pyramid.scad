use <qpp_utils.scad>

// pyramid
// '-> argument "n" is the number of edges
// '-> argument "a" is the length of the base edge
// '-> argument "h" is he height of the pyramid
// '-> additional argument "R"|"D" defines the radius/diameter of the base incircled/excircled circle
//     '-> "R" or "D" overrides argument "a"
// '-> additional argument "align_along_x" defines whether the base edge should be aligned with the x-axis
// '-> additional argument "incircle" defines whether the pyramid base is incircled or excircled to the providede "R"|"D"
// '-> private argument "__module_name" defines name used in the asserts
module qpp_pyramid(n=3, a=1, h=1, R=undef, D=undef, incircle=true, align_along_x=true, __module_name="[QPP-pyramid]")
{
    _module_name = __module_name;
    
    // check number of base edges
    assert(n >= 3, str(_module_name, " argument \"n\" (number of sides) cannot be less then 3!"));
    _n = n;
    // check heigh
    assert(h > 0, str(_module_name, " argument \"h\" (height) muset be positive!"));
    _h = h;
    // check base edge length
    _use_a = is_undef(R) && is_undef(D);
    assert(!_use_a || a > 0, str(_module_name, " argument \"a\" (base edge length) must be positive!"));
    // check the R or D if provided
    __R = !_use_a && !is_undef(D) ? D/2 : R;
    assert(_use_a || __R > 0, str(_module_name, " argument \"R\"|\"D\" must be positive!"));

    // compute radius
    _R = _use_a ?
            (a/2)/sin(360/(2*_n)) : 
            incircle ? __R : __R/(cos(360/(2*_n)));

    // handle rotation alignment
    _z_rot = align_along_x ? -90-360/(2*_n) : 0;
    rotate([0,0, _z_rot])
        // base shape
        cylinder(r2=0, r1=_R, h=_h,$fn=_n);
    
}

module qpp_regular_pyramid(a=1, n=3)
{

}

module qpp_cone(r=0.5, d=undef, h=1)
{

}

module qpp_regular_cone(r=0.5, d=undef)
{

}