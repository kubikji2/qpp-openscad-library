/*********************************************************************************************
* CUBE++ (cubepp)                                                                            *
* '-> by Jiri Kubik (jiri.kub@gmail.com) in 2020-2021                                        *
* '-> simple but essential library which adds two new cube designs.                          *
*     '-> _round_cube creates cube with corners rounded in XY-plane                          *
*     '-> _shpere_cube creates cube with corners rounded in all 3 dimensions                 *
*     '-> _chopped_cube (planned for the future) coppes corners of the cube                  *
* '-> recommended module to be used is cube_{r,s,c} with same interface as the original      *
*     cube, see documentation bellow                                                         *
*********************************************************************************************/

// CURRENT VERSION: 0.0.1
// Change log
// '-> 0.0.1 - modules for cube_r and cube_s finalized
// '-> 0.0.2 - box and box_r added
// '-> 0.0.2.1 - box and box_r fixed
// '-> 0.0.3.0 - cube_c for cube with corners cut of

// planned
// solve issue with carved box
// carved cube and box

$fn = 45;
NAN = acos(2);

/*********************************************************************************************
* '-> ROUND CUBE */

// creates cube of given dimensions x,y,z with the corner rounded in the XY plane by diameter d
// '-> x - dimension in x axis
// '-> y - dimension in y axis
// '-> z - dimension in z axis
// '-> d - diameter of corners rounded in XY-plane
// '-> center same as in cube module
module _round_cube(x,y,z,d,center=false,fn=$fn)
{
    assert(x >= d && y >= d, str("given diameter(d=",d,") exceed one of sides(x=",x,",y=",y,")! Use round_cube_lazy to automatically choose diameter."));
    
    A = x-d;
    B = y-d;
    C = z;
    
    // solve center transform
    t = center ? [d/2-x/2,d/2-y/2,-y/2] : [d/2,d/2,0];
    
    // hull-less implementation to speed up process
    translate(t)
    {
        // corners
        cylinder(d=d, h=C, $fn=fn);
        translate([A,0,0]) cylinder(d=d, h=C, $fn=fn);
        translate([A,B,0]) cylinder(d=d, h=C, $fn=fn);
        translate([0,B,0]) cylinder(d=d, h=C, $fn=fn);
        
        // fill
        translate([-d/2,0,0]) cube([x,y-d,z]);
        translate([0,-d/2,0]) cube([x-d,y,z]);
    }
    
    // hull-based implementation
    /*
    translate([d/2,d/2,0])
    hull()
    {
        cylinder(d=d, h=C);
        translate([A,0,0]) cylinder(d=d, h=C);
        translate([A,B,0]) cylinder(d=d, h=C);
        translate([0,B,0]) cylinder(d=d, h=C);
    } 
    */
}

// wrapper for _round_cube module
module round_cube (x,y,z,d, center=false)
{
    _round_cube(x,y,z,d, center);
}

// wrapper for _round_cube module
// '-> dimensions t=[x,y,z]
// '-> d - diameter of corners rounded in XY-plane
module round_cube (t,d, center=false)
{   
    assert(len(t)==3, str("given size vector has size, ", len(t), " but size 3 is required"));
    _round_cube(t.x,t.y,t.z,d, center);
}

// wrapper for _round_cube module
// '-> similar interface and naming convetion as cube module
module cube_r(t,d, center=false)
{
    round_cube(t,d, center);
}

/*********************************************************************************************
* '-> SPHERE CUBE */

// creates cube of given dimenions x,y,z with corners rounded in XYZ by diameter d
// '-> x - dimension in x axis
// '-> y - dimension in y axis
// '-> z - dimension in z axis
// '-> d - rounded corners diameter
// '-> center same as in cube module
module _sphere_cube (x,y,z,d, center=false, fn=$fn)
{
    assert(x >= d && y >= d, str("given diameter(d=",d,") exceed one of sides(x=",x,",y=",y,")! Use round_cube_lazy to automatically choose diameter."));
    
    A = x-d;
    B = y-d;
    C = z-d;
    R = d/2;
    
    // solve center transform
    t = center ? [R-x/2,R-y/2,R-z/2] : [R,R,R];
       
    // minkowski implementation
    translate(t)
    minkowski()
    {
        cube([A,B,C]);
        sphere(r=R, $fn=fn);
    }
    
}

// _sphere_cube wrapper with same arguments as original function
module sphere_cube(x,y,z,d, center=false)
{
    _sphere_cube(x,y,z,d, center);
}

// wrapper for _sphere_cube module
// '-> dimensions t=[x,y,z]
// '-> d - rounded corners diameter
module sphere_cube(t,d, center=false)
{
    assert(len(t)==3, str("given size vector has size, ", len(t), " but size 3 is required"));
    _sphere_cube(t.x,t.y,t.z,d, center);
}

// wrapper for _sphere_cube module
// '-> similar interface and naming convetion as cube module
module cube_s (t,d, center=false)
{
    sphere_cube(t,d, center);
}

/*********************************************************************************************
* '-> CHOPPED CUBE */

// creates cube of given dimenions x,y,z with corners chopped in XY by a
// '-> x - dimension in x axis
// '-> y - dimension in y axis
// '-> z - dimension in z axis
// '-> a - distance of the cut from corners in XY plane
// '-> center same as in cube module
module _chopped_cube(x,y,z,a, center=false)
{
    _round_cube(x,y,z,2*a,center,fn=4);
}

// _chopped_cube wrapper with same arguments as original function
module chopped_cube(x,y,z,a, center=false)
{
    _chopped_cube(x,y,z,a, center);
}

// wrapper for _sphere_cube module
// '-> dimensions s=[x,y,z]
// '-> a - distance of the cut from corners
module chopped_cube(s,a, center=false)
{
    assert(len(s)==3, str("given size vector has size, ", len(s), " but size 3 is required"));
    _sphere_cube(s.x,s.y,s.z,a, center);
}

// wrapper for _sphere_cube module
// '-> similar interface and naming convetion as cube module
module cube_c(s,a, center=false)
{
    chopped_cube(s,a, center);
}

//_chopped_cube(10,10,10,2);

/*
module _carved_cube(x,y,z,a, center=false)
{
    assert(x >= 2*a && y >= 2*a, str("given carve parameter (d=",a,") exceed one of sides(x=",x,",y=",y,")! Use round_cube_lazy to automatically choose diameter."));
    
    A = x-d;
    B = y-d;
    C = z-d;
    R = a;
    
    // solve center transform
    t = center ? [R-x/2,R-y/2,R-z/2] : [R,R,R];
       
    // minkowski implementation
    translate(t)
    minkowski()
    {
        cube([A,B,C]);
        rotate([45,45,45])
            cube([a,a,a]);
    }
}

%cube([10,10,10]);
_carved_cube(10,10,10,2);
*/


/********
* BOXES *
********/

// basic box
// '-> x,y,z - outer dimensions
// bt - bottom thickness
// wt - wall thickness
module _box(x,y,z,wt,bt, center=false)
{   
    echo(str(x,y,z,wt,bt,center));
    assert(wt>0, str("given wall thickness wt=",wt," must be greater than zero"));
    if (wt!=bt)
    {
        assert(bt>0, str("given botton thickness bt=",bt," must be greater than zero"));
    }
    // solve center transform
    tf = center ? [-x/2,-y/2,-z/2] : [0,0,0];
    
    translate(tf)
    difference()
    {
        
        // outer shell
        cube([x,y,z]);
        
        // hole
        translate([wt,wt,bt])
            cube([x-2*wt,y-2*wt,z]);
    }
}

// _box wrapper
module box_xyz(x,y,z,wt,bt=NAN, center=false)
{
    _bt = is_num(bt) ? bt : wt;
    _box(x,y,z,wt,_bt, center);
}


// _box wrapper
module box(s,wt,bt=NAN, center=false)
{
    assert(len(s)==3, str("given size vector has size, ", len(s), " but size 3 is required"));
    _bt = is_num(bt) ? bt : wt;
    _box(s.x,s.y,s.z,wt,_bt, center);
}

// box with corners round in XY plane
// x,y,z - outer dimensions
// d - rounding diameter
// bt - bottom thickness
// wt - wall thickness
module _box_r(x,y,z,d,wt,bt, center=false, fn=$fn)
{
    assert(wt>0, str("given wall thickness wt=",wt," must be greater than zero"));
    if (wt!=bt)
    {
        assert(bt>0, str("given botton thickness bt=",bt," must be greater than zero"));
    }
    
    assert(d>=2*wt, str("given diameter d=",d," must be at least twice of wall thickness wt=", wt));  
   
    // solve center transform
    tf = center ? [-x/2,-y/2,z/2] : [0,0,0];
    
    translate(tf)
    difference()
    {
        
        // outer shell
        cube_r([x,y,z],d,$fn=fn);
        
        // hole
        translate([wt,wt,bt])
            cube_r([x-2*wt,y-2*wt,z],d-2*wt,$fn=fn);
    }
}

// _box_r wrapper
module box_r_xyz(x,y,z,d,wt,bt=NAN, center=false)
{   
    _bt = is_num(bt) ? bt : wt;
    _box_r(x,y,z,d,wt,_bt, center);
}


// _box_r wrapper
module box_r(s,d,wt,bt=NAN, center=false)
{
    assert(len(s)==3, str("given size vector has size, ", len(s), " but size 3 is required"));
    _bt = is_num(bt) ? bt : wt;
    _box_r(s.x,s.y,s.z,d,wt,_bt, center);
}

/* 

// TODO it looks strange

// basic box
// '-> x,y,z - outer dimensions
// '-> a - distance of the cut from corners in XY plane
// '-> wt - wall thickness
// '-> bt - bottom thickness
module _box_c(x,y,z,a,wt,bt, center=false)
{
    _box_r(x,y,z,2*a,wt,bt, center, fn=4);
}

_box_c(10,10,10,2,1,1);
*/


////////////////////////////////////////////////////////////////////////////
// trash to be removed

/*
module round_cube_lazy(x=40,y=30,z=2,d=10)
{
    if (x<d || y<d)
    {
        echo("Avoiding dissaster by choosing new diameter.");
    }
    
    _d = min([x,y,d]);
    round_cube(x,y,z,_d);
}


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
*/
