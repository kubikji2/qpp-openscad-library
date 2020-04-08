
module round_cube (x=40,y=30,z=2,d=10)
{
    assert(x >= d && y >= d, str("given diameter(d=",d,") exceed one of sides(x=",x,",y=",y,")! Use round_cube_lazy to automatically choose diameter."));
    
    A = x-d;
    B = y-d;
    C = z;
    
    translate([d/2,d/2,0])
    hull()
    {
        cylinder(d=d, h=C);
        translate([A,0,0]) cylinder(d=d, h=C);
        translate([A,B,0]) cylinder(d=d, h=C);
        translate([0,B,0]) cylinder(d=d, h=C);
    }   
}

//round_cube(x=5,y=10,d=20);

module round_cube_lazy(x=40,y=30,z=2,d=10)
{
    if (x<d || y<d)
    {
        echo("Avoiding dissaster by choosing new diameter.");
    }
    
    _d = min([x,y,d]);
    round_cube(x,y,z,_d);
}

round_cube_lazy(x=5,y=10,d=20);

$fn = 90;
module box (x=82,y=154,z=52,d=20,t=2)
{
    A = x-d;
    B = y-d;
    C = z;
    
    //%translate([-d/2,-d/2,0]) cube([x,y,z]);
    difference()
    {
        hull()
        {
            cylinder(d=d, h=C);
            translate([A,0,0]) cylinder(d=d, h=C);
            translate([A,B,0]) cylinder(d=d, h=C);
            translate([0,B,0]) cylinder(d=d, h=C);
        }
        
        translate([-t/2,-t/2,t])
        hull()
        {
            translate([t,t,0]) cylinder(d=d-t, h=C);
            translate([A,t,0]) cylinder(d=d-t, h=C);
            translate([A,B,0]) cylinder(d=d-t, h=C);
            translate([t,B,0]) cylinder(d=d-t, h=C);
        }
    }
}

//box();