// ===========================================
// (c) 2018 by Jiri Kubik (jiri.kub@gmail.com)
// ===========================================

include<qpp_constants.scad>

// constants from law about biohazzard law:
// https://law.resource.org/pub/us/cfr/ibr/002/ansi.z35.1.1968.html
__qpp_bio_A = 1;
__qpp_bio_B = 3.5;
__qpp_bio_C = 4;
__qpp_bio_D = 6;
__qpp_bio_E = 11;
__qpp_bio_F = 15;
__qpp_bio_G = 21;
__qpp_bio_H = 30;
__qpp_bio_angles = [90,210,330];


module __qpp_bio_outer_ring(sf=1, h=1)
{
    _C = sf*__qpp_bio_C;
    _E = sf*__qpp_bio_E;
    _G = sf*__qpp_bio_G;
    _H = sf*__qpp_bio_H;

    difference(){
        translate([_E,0,0])
            cylinder(d=_H, h=h);
        // the outer most cubioid cuts
        translate([_G,0,0-qpp_eps])
            translate([_C/2,-_C/2,0])
                cube([_C,_C,h+2*qpp_eps]);
    }
}


// the outer cylindrical cuts
module __qpp_bio_main_body_holes(sf=1, h=1)
{
    _F = sf*__qpp_bio_F;
    _G = sf*__qpp_bio_G;

    for (_a=__qpp_bio_angles)
    {
        rotate([0,0,_a])
            translate([_F,0,-qpp_eps])
                cylinder(d=_G,h=h+qpp_eps);
    }
}


// the main body consisting of the outer rings
module __qpp_bio_main_body(sf=1,h=1)
{
    for (_a=__qpp_bio_angles)
    {
        rotate([0,0,_a])
            __qpp_bio_outer_ring(sf,h);
    }
}


module __qpp_bio_outer_tentacles(sf=1,h=1)
{
    difference()
    {
        __qpp_bio_main_body(sf,h);
        __qpp_bio_main_body_holes(sf,h+2*qpp_eps);
    }
}


module __qpp_bio_inner_cut(sf=1,h=1)
{   
    _A = sf*__qpp_bio_A;
    _D = sf*__qpp_bio_D;

    translate([0,0,-qpp_eps])
        cylinder(d=_D,h=h);
    
    for (_a=__qpp_bio_angles)
    {
        rotate([0,0,_a-90])
            translate([-_A/2,0,-qpp_eps])
                cube([_A,_D,h]);
    }
}


module __qpp_bio_inner_ring(sf=1,h=1,dr=0)
{
    
    _A = sf*__qpp_bio_A;
    _B = sf*__qpp_bio_B;
    _E = sf*__qpp_bio_E;

    _outer=_E-_A+_B+dr;
    _inner=_E-_A-dr;
    difference()
    {
        cylinder(r=_outer,h=h);
        translate([0,0,-qpp_eps])
        cylinder(r=_inner,h=h+2*qpp_eps);
    }
}


module __qpp_bio_middle_ring(sf=1,h=1)
{

    _A = sf*__qpp_bio_A;
    _F = sf*__qpp_bio_F;
    _G = sf*__qpp_bio_G;

    difference()
    {
        // from the middle ring...
        __qpp_bio_inner_ring(sf,h);

        // ... cut the segments next to the tentacles
        render()
        difference()
        {   
            // ... first take middle ring, saled up a bit
            translate([0,0,-qpp_eps])
                __qpp_bio_inner_ring(sf,h+2*qpp_eps,dr=qpp_eps);
            
            // ... the cut the circles
            for(_a=__qpp_bio_angles){
                rotate([0,0,_a])
                    translate([_F,0,-2*qpp_eps])
                        cylinder(d=_G-2*_A,h=h+4*qpp_eps);
            }
        }
    }
}

module qpp_biohazard_logo(scale=1, height=1)
{
    _sf = 1;
    _h = 1;
    difference()
    {
        __qpp_bio_outer_tentacles(_sf,_h);
        __qpp_bio_inner_cut(_sf, _h+2*qpp_eps);
    }
    __qpp_bio_middle_ring(_sf,_h);
}


