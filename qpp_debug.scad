module __qpp_axis_arrow(clr="white",fn=$fn)
{
    _h = 8;
    color(clr)
    {
        cylinder(h=_h,d=1,$fn=fn);
        translate([0,0,_h])
            cylinder(h=10-_h,d1=2,d2=0,$fn=fn);
    }
}

module qpp_coordinate_frame(fn=$fn)
{
    // x-axis
    rotate([0,90,0])
        __qpp_axis_arrow(clr="red", fn=fn);
    // y-axis
    rotate([-90,0,0])
        __qpp_axis_arrow(clr="green", fn=fn);
    // z-axis
    __qpp_axis_arrow(clr="blue",fn=fn);
    // origin
    color([0.2,0.2,0.2])
        sphere(d=1,$fn=fn);

    children();
}