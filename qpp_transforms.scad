// use utils
use <qpp_utils.scad>

// use qpp_debug
use <qpp_debug.scad>

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
// '-> variable "normalized" defines whether the direction should be normalized or not
//     '-> NOTE: in case of string-based definition of "dir", the direction is composed from unit vectors
module qpp_repeat(n, l, dir="z", normalize=false)
{
    _module_name = "[QPP-repeat]";

    // process n
    assert(n>0, str(_module_name, str(_module_name," variable \"n\" must be greater then 0!")));
    _n = n;
    // process l
    _l = l;
    // process dir
    assert((qpp_is_valid_3D_list(dir)==1) || is_string(dir), str(_module_name, " variable \"dir\" (interpreted as vector) has invalid size != 3, but ", str(qpp_len_s(dir)),"!"));
    
    // get direction componente
    _is_str = is_string(dir);
    _x = _is_str ? (len(search(dir,"x")) > 0 ? 1 : 0) : dir.x;
    _y = _is_str ? (len(search(dir,"y")) > 0 ? 1 : 0) : dir.y;
    _z = _is_str ? (len(search(dir,"z")) > 0 ? 1 : 0) : dir.z;

    // compute norm
    _norm = normalize ? qpp_norm_vec([_x,_y,_z]) : 1;

    // get repetition direction
    _dir = [_x/_norm, _y/_norm, _z/_norm];

    for (i=[0:n-1])
    {
        // get transform
        _t = [for(_el=_dir) i * (_el*_l)];
        translate(_t)
            children();
    }
}

// the child modules are difference iff the condition is fulfilled
// '-> argument "cond" is condition to be fullfilled
// '-> argument "on_fail_abort":
//     '-> is TRUE - all children other then children(0) are aborted (thrown away)
//     '-> is FALSE - the union is constructed
// NOTE: the condition is true by default; therefore, you can use it as regular difference
// TODO: add options to scale objects a bit to improve the preview
module qpp_difference(cond=true, on_fail_abort=true)
{
    if(cond)
    {
        difference()
        {
            children(0);
            children([1:$children-1]);
        }
    }
    else
    {   
        children(0);
        
        if(!on_fail_abort)
        {
            children([1:$children-1]);
        }
    }    
}

// transforms to the cube-like side centers
// '-> size is a 3D vector defining the cubeoid dimensions
//     '-> TODO make it scalar or 1D array, or leave it for the particular cuboid implementation?
// '-> argument 'side_name' defines the particular side, see QPP_*_SIDE constants
// '-> optional argument 'is_cuboid_centered' defines whether the cuboid is centered or not
// '-> optional argument 'show_coord_frame' defines whether show coordinate frame in the new origin
// NOTE: z-axis is always identical to the side normal
// NOTE: rotation with y-axis symmetry being perserved with the highest priority, followed by x-axis
module qpp_transform_to_cuboid_side(size, side_name, is_cuboid_centered=true, show_coord_frame=true)
{
    _idx = search([side_name],QPP_CUBOID_SIDES)[0];
    _is_valid_name = !is_list(_idx);
    assert(_is_valid_name, str("[QPP-transform-cuboid] given side name \'", str(side_name), "\' is not known side name!"));

    // compute translation to compensate for non-centered cuboids
    _centering_dir = is_cuboid_centered ? [0,0,0] : [0.5,0.5,0.5];
    _centering_t = qpp_pointwise_product_vec(size,_centering_dir);

    // get direction from the first position in the entry ...
    _dir = QPP_CUBOID_SIDES[_idx][1];
    // ... and compute translation
    _t = qpp_pointwise_product_vec(_dir,size);
    // get rotation at the second position in the entry
    _r = QPP_CUBOID_SIDES[_idx][2]; 
        
    // translate all objects to the particular transform frame
    translate(_centering_t)
        translate(_t)
            rotate(_r)
            {
                if (show_coord_frame)
                {
                    qpp_coordinate_frame();
                }
                children();
            }
}