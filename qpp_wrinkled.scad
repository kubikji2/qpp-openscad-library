use <qpp_utils.scad>

// wrinkled cylinder
// '-> argument "H" defines the height of the cylinder
// '-> argument "R"|"D" define the radius/diameter of the cylinder
// '-> argument "d" defines the depth of the wrinkles
// '-> argument "h" defines the height of the wrinkles
// '-> additional argument "n_wrinkles" defines the number of wrinkles
//     '-> overrides argument "H"
// '-> additional argument "use_circular" specifies the wrinkles shape
//     '-> false - the wrinkles are v shapes
//     '-> true  - the wrinkles are half-circles
//         '-> the "d" argument is ignored
module qpp_wrinkled_cylinder(H=1, R=0.5, D=undef, d=0.05, h=0.1, n_wrinkles=undef, use_circular=false)
{

}

