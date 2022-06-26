use <qpp_utils.scad>

// this module creaters the corneless cube
// '-> argument "size" defines the size of the geometry, following options are supported:
//    '-> [a] or a - cube of size [a,a,a]
//    '-> [x,y,z]  - cuboid of size [x,y,z]
// '-> argument "cut" defines the cut on the corners
//     '-> [c] or c for uniform cuts
//     '-> [cx,cy,cz] for different cuts for particular axis
module qpp_cornerlesscube(size=[1,1,1],cut=0.1)
{
    _module_name = "[QPP-CornerlessCube]";
    // check size
    assert(qpp_is_valid_3D_list(size) != -1, str(_module_name, " argument \"size\" is neither scalar equivalent nor 3D vector!"));
    // check cut
    assert(qpp_is_valid_3D_list(size) != -1, str(_module_name, " argument \"cut\" is neither scalar equivalent nor 3D vector!"));

    // expand size
    _size = qpp_try_to_unpack_list(size);
    _is_cuboid = is_list(_size);
    _x = _is_cuboid ? _size[0] : _size;
    _y = _is_cuboid ? _size[1] : _size;
    _z = _is_cuboid ? _size[2] : _size;
    
    // expand cut
    _cut = qpp_test_try_to_unpack_list(cut);
    _is_non_uniform_cut = is_list(_cut);
    _x = _is_non_uniform_cut ? _cut[0] : _cut;
    _y = _is_non_uniform_cut ? _cut[1] : _cut;
    _z = _is_non_uniform_cut ? _cut[2] : _cut;

    

}