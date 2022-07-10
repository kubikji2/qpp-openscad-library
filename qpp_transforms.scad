
// skew is based on implementation: https://gist.github.com/boredzo/fde487c724a40a26fa9c

// computes the scew matrix given the six skew angles:
// '-> "xy" - x along y in degrees
// '-> "xz" - x along z in degrees
// '-> "yx" - y along x in degrees
// '-> "yz" - y along z in degrees
// '-> "zx" - z along x in degrees
// '-> "zy" - z along y in degrees
function qpp_compose_skew_matrix(xy=0, xz=0, yx=0, yz=0, zx=0, zy=0) =
    [
        [ 1,        tan(xy),    tan(xz),    0 ],
        [ tan(yx),  1,          tan(yz),    0 ],
        [ tan(zx),  tan(zy),    1,          0 ],
        [ 0,        0,          0,          1 ]
    ];

// this module skew child geometry by provided angles.
// skew takes an array of six angles:
// '-> "xy" - x along y in degrees
// '-> "xz" - x along z in degrees
// '-> "yx" - y along x in degrees
// '-> "yz" - y along z in degrees
// '-> "zx" - z along x in degrees
// '-> "zy" - z along y in degrees
module qpp_skew(xy=0, xz=0, yx=0, yz=0, zx=0, zy=0) {
    // compose skew matrix
    _matrix = qpp_compose_skew_matrix(xy,xz,yx,yz,zx,zy);
    // multiply children by 
    multmatrix(_matrix)
        children();
}


// this module repeats its children n-times in 
// '-> variable "n" is number of repetitions, n > 1
// '-> variable "l" is the length of the children in the direction of repetition
//     '-> l > 0 means the repetition in the given direction,
//     '-> l < 0 means in the oposite direction
// '-> variable "dir" is the direction of the repetition
//     '-> 'x', 'y' or 'z' for the main axis
//     '-> any combination of {'x', 'y', 'z'} for the particular direction
//     '-> [x,y,z] for a specific direction
//     '-> NOTE: all directions will be normalized 
module qpp_repeat(n,l,dir="z")
{

}