// [private] single arrow
module __qpp_axis_arrow(clr="white", H=10, fn=$fn)
{
    // arrow body height
    _h = 0.8*H;
    // arrow body diameter
    _d = 0.1*H;
    color(clr)
    {   
        // arrow body
        %cylinder(h=_h,d=_d,$fn=fn);
        // arrow point
        %translate([0,0,_h])
            cylinder(h=H-_h,d1=H-_h,d2=0,$fn=fn);
    }
}

// Coordinate frame consiting of three XYZ-axis
// '-> NOTE: all components have background modifiers so they are not part of resulting model
// '-> height is the length of the particular ax
// '-> txt is optional text to label coordinate frame
module qpp_coordinate_frame(height=10, txt="", fn=$fn)
{
    // x-axis in RED
    rotate([0,90,0])
        __qpp_axis_arrow(clr="red", H=height, fn=fn);

    // y-axis in GREEN
    rotate([-90,0,0])
        __qpp_axis_arrow(clr="green", H=height, fn=fn);
    
    // z-axis in BLUE
    __qpp_axis_arrow(clr="blue", H=height, fn=fn);
    
    // origin in blackish
    _blackish = [0.2,0.2,0.2];
    color(_blackish)
        %sphere(d=0.1*height,$fn=fn);
    
    // adding text denoting the coordinate frame in blackish
    color(_blackish)
        // rotate it outside of the frame cross
        rotate([90, 0, -45])
            translate([0,0,0*height])
                %linear_extrude(0.1*height)
                    text(txt,valign="center", halign="center",size=0.3*height);

    // adding all other children
    children();
}