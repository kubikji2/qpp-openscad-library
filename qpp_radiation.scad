include<qpp_constants.scad>

// constants from law about biohazzard law:
// https://law.resource.org/pub/us/cfr/ibr/002/ansi.z35.1.1968.html

__qpp_rad_Rf = 1;
__qpp_rad_rf = 0.3;
__qpp_rad__rf = 0.2;
__qpp_rad_angles = [30,150,270];

// single radiation fin
module __qpp_rad_fin(r, h, fn=$fn)
{
    _d = 2*r;
    difference()
    {
        // basic shape
        cylinder(h=h, r=__qpp_rad_Rf*r,$fn=fn);
        // cut half of the circle off
        translate([0, -_d,-qpp_eps])
            cube([_d,2*_d,h+2*qpp_eps]);
        // cut 120° segment of circle
        rotate([0,0,120])
            translate([0, -_d,-qpp_eps])
                cube([_d,2*_d,h+2*qpp_eps]);
        // inner cut
        translate([0,0,-qpp_eps])
            cylinder(h=h+2*qpp_eps, r=__qpp_rad_rf*r, $fn=fn);
    }
}

// radiation symbol based on the US law
// '-> varible "r" or "d" defines symbol radius or diameter respectively
// '-> variable "h" define the height of the symbol
// '-> variable "$fn" is just regular $fn
module qpp_radiation_symbol(r=0.5, d=undef, h=0.1, fn=$fn)
{

    _module_name = "[QPP-radiation-symbol]";

    // radius/diameter
    _r = is_undef(d) ? r : d/2;
    assert(_r > 0, str(_module_name, " variable \"r\", neither \"d\" can be negative!"));

    // height
    _h = h;
    assert(_h >= 0, str(_module_name, " variable \"h\" cannot be negative!"));

    // radiation fins
    for (_a=__qpp_rad_angles)
    {
        rotate([0,0,_a])
            __qpp_rad_fin(_r,_h,fn);
    }

    // inner cylinder
    rotate([0,0,30])
    cylinder(r=_r*__qpp_rad__rf, _h, $fn=fn);
    
}