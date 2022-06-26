use <qpp_utils.scad>
use <qpp_tetrahedron.scad>
include <qpp_constants.scad>

// module used to cut corners
module _qpp_compose_corner_cut(points,offs,h)
{
    for(i=[0:3])
    {
        // select point oposite to the leftout corner
        _peak_idx = (i+2)%4;
        // move peak point to by "h" in z-axis
        _peak_point = qpp_add_vec(points[_peak_idx],[0,0,h]);
        // different order is used to handle normals
        _points = h > 0 ? 
                    [for(j=[0:3]) if (j != i) points[j], _peak_point] :
                    [_peak_point, for(j=[0:3]) if (j != i) points[j]];

        // geometry
        translate(offs[i])
            qpp_tetrahedron(points=_points);
    }
} 

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
    _cut = qpp_try_to_unpack_list(cut);
    _is_non_uniform_cut = is_list(_cut);
    _cx = _is_non_uniform_cut ? _cut[0] : _cut;
    _cy = _is_non_uniform_cut ? _cut[1] : _cut;
    _cz = _is_non_uniform_cut ? _cut[2] : _cut;

    // compose cuts coordinates and its offsets
    eps = 0.001;
    _xy_cuts = [
                [   -eps,    -eps, -eps],
                [_cx+eps,    -eps, -eps],
                [_cx+eps, _cy+eps, -eps],
                [   -eps, _cy+eps, -eps]        
               ];
    
    _xy_offs = [
                [_x-_cx, _y-_cy, 0],
                [     0, _y-_cy, 0],
                [     0,      0, 0],
                [_x-_cx,      0, 0],
               ];

    // translate the coordinates and offsets for the top face
    _xy_offs_tops = [for(_point=_xy_offs) qpp_add_vec(_point,[0,0,_z])];
    _xy_cuts_tops = [for(_point=_xy_cuts) qpp_add_vec(_point,[0,0,2*eps])];

    // construct the guoemetry
    difference()
    {
        // basic shape
        cube([_x,_y,_z]);
        // lower cuts
        _qpp_compose_corner_cut(points=_xy_cuts,offs=_xy_offs,h=_cz+eps);
        // upper cuts
        _qpp_compose_corner_cut(points=_xy_cuts_tops,offs=_xy_offs_tops,h=-_cz-eps);
    }
    
}