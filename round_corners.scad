/*
 * Creates cube with round corners in xy-plane
 */
module round_cube (x=40,y=30,z=2,d=10,fn=$fn)
{
    A = x-d;
    B = y-d;
    C = z;
    
    translate([d/2,d/2,0])
    hull()
    {
        cylinder(d=d, h=C, $fn=fn);
        translate([A,0,0]) cylinder(d=d, h=C, $fn=fn);
        translate([A,B,0]) cylinder(d=d, h=C, $fn=fn);
        translate([0,B,0]) cylinder(d=d, h=C, $fn=fn);
    }
    
    
}

/*
 * Creates box-like structure with corners rounded in xy-plane.
 */
module box (x=82,y=154,z=52,d=20,t=2,fn=$fn)
{
    A = x-d;
    B = y-d;
    C = z;
    
    difference()
    {
        hull()
        {
            cylinder(d=d, h=C, $fn=fn);
            translate([A,0,0]) cylinder(d=d, h=C, $fn=fn);
            translate([A,B,0]) cylinder(d=d, h=C, $fn=fn);
            translate([0,B,0]) cylinder(d=d, h=C, $fn=fn);
        }
        
        translate([-t/2,-t/2,t])
        hull()
        {
            translate([t,t,0]) cylinder(d=d-t, h=C, $fn=fn);
            translate([A,t,0]) cylinder(d=d-t, h=C, $fn=fn);
            translate([A,B,0]) cylinder(d=d-t, h=C, $fn=fn);
            translate([t,B,0]) cylinder(d=d-t, h=C, $fn=fn);
        }
    }
}
