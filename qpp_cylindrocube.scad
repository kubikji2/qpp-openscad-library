use<qpp_utils.scad>
include<qpp_constants.scad>

// this module creates cylindrocube/cylindrocuboid
// '-> variable "size" is either:
//     '-> [x,y,z,rx,ry] - where x,y,z are cuboid dimensions the rx,ry are respective radii of its corner cuts 
//     '-> [x,y,z,r] - where x,y,z are cuboid dimensions and the r is the radius of its corner cuts
//     '-> [a,r] - where the a is the lendght of the cube edge and the r is the radius of its corner cuts
// '-> one can override the "size" by "xyz" and "r" variables iff both are defined
// '-> variable "xyz" can either be:
//     '-> [x,y,z], [a] or a
// '-> variable "r" can either be:
//     '-> r, [r] or [rx,ry]
// NOTE that using "xyz" and "r" supports wider range of combination
// '-> parameter "fn" is used to define the granurality of the corner spheres 
module qpp_cylindrocube(size=[1,1,1,0.5], xyz=undef, r=undef, $fn=qpp_fn)
{

}