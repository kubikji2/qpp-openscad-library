include<qpp_constants.scad>
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


// regular pyramid (all edges have same length)
// '-> argument "n" is the number of edges
// '-> argument "a" is the length of the base edge
// '-> additional argument "R"|"D" defines the radius/diameter of the base incircled/excircled circle
//     '-> "R" or "D" overrides argument "a"
// '-> additional argument "align_along_x" defines whether the base edge should be aligned with the x-axis
// '-> additional argument "incircle" defines whether the pyramid base is incircled or excircled to the providede "R"|"D"
// '-> private argument "__module_name" defines name used in the asserts
module qpp_regular_pyramid(n=3, a=1, R=undef, D=undef, incircle=true, align_along_x=true, __module_name="[QPP-regular_pyramid]")
{

    _module_name = __module_name;
    // compute h
    // '-> check number of base edges
    assert(n >= 3 && n < 6, str(_module_name, " argument \"n\" (number of sides) cannot be less then 3, or more then 5!"));
    _n = n;
    // '-> check base edge length
    _use_a = is_undef(R) && is_undef(D);
    assert(!_use_a || a > 0, str(_module_name, " argument \"a\" (base edge length) must be positive!"));
    // '-> check the R or D if provided
    __R = !_use_a && !is_undef(D) ? D/2 : R;
    assert(_use_a || __R > 0, str(_module_name, " argument \"R\"|\"D\" must be positive!"));

    // compute radius
    _ang = 360/(2*_n);
    _R = _use_a ?
            (a/2)/sin(_ang) : 
            incircle ? __R : __R/(cos(_ang));
    _a = _use_a ? 
            a :
            2*_R*sin(_ang);
    _h = sqrt(_a*_a-_R*_R);

    // call base module
    qpp_pyramid(n=n, a=a, h=_h, R=R, D=D, incircle=incircle,
                align_along_x=align_along_x, __module_name=_module_name);

}


// cone
// '-> argument "h" is he height of the cone
// '-> argument "R"|"D" defines the radius/diameter of the base
// '-> private argument "__module_name" defines name used in the asserts
// '-> argument "$fn" is regular $fn
module qpp_cone(h=1, R=1, D=undef, __module_name="[QPP-cone]", $fn=qpp_fn)
{
    qpp_pyramid(n=$fn, h=h, R=R, D=D, __module_name=__module_name);
}

// shperocone
// '-> argument "h" is he height of the spherocone envelope
// '-> argument "R"|"D" defines the radius/diameter of the base
// '-> argument "r"|"d" defines the bevel radius/diameter
// '-> private argument "__module_name" defines name used in the asserts
// '-> argument "$fn" is regular $fn
module qpp_spherocone(h=1, R=1, D=undef, r=0.1, d=undef, $fn=qpp_fn)
{
    // module name
    _module_name="[QPP-shperocone]";
    // radius and and check
    _R = is_undef(D) ? R : D/2;
    assert(_R > 0, str(_module_name, " argument \"R\"|\"D\" must be positive!"));
    // bevel radius
    _r = is_undef(d) ? r : d/2;
    assert(_r > 0, str(_module_name, " argument \"r\"|\"d\" must be positive!"));
    
    // compose xz-plane projection points
    points = [[_R,0], [0,h], [-_R,0]];
    
    // extrude element
    rotate_extrude($fn=$fn)
    difference()
    {
        // create xz-plane projection with rounded corners
        offset(r=_r)
            offset(r=-_r)
                polygon(points);
        // cut off the x<0 plane
        translate([-_R,-qpp_eps])
            square([_R,h+2*qpp_eps]);
    }
}

// regular cone (all edges have same length)
// '-> argument "h" is he height of the pyramid
// '-> additional argument "R"|"D" defines the radius/diameter of the base
//     '-> "R" or "D" overrides argument "a"
// '-> private argument "__module_name" defines name used in the asserts
module qpp_regular_cone(R=0.5, D=undef, $fn=qpp_fn)
{
    _module_name="[QPP-regular_cone]";
    // check radius
    _R = is_undef(D) ? R : D/2;
    assert(_R > 0, str(_module_name, " argument \"R\"|\"D\" must be positive!"));
    // compute heigh
    _h = sqrt(4*_R*_R-_R*_R);

    // base module
    qpp_cone($fn=$fn, h=_h, R=R, D=D, __module_name=_module_name);
}
