use <qpp_utils.scad>
use <qpp_tetrahedron.scad>
include <qpp_constants.scad>

module _qpp_compose_corner_cut(points,offs,h)
{
    for(i=[0:3])
    {
        _peak_idx = (i+2)%4;
        _cp = points[_peak_idx];
        _peak_point = [_cp[0],_cp[1],_cp[2]+h];
        _points = [for(j=[0:3]) if (j != i) points[j], _peak_point];
        echo(_points);

        translate(offs[i])
            qpp_tetrahedron(points=_points);
    }
} 
//    [ for (_point=points) [_point[0]+off[0],_point[1]+off[1],_point[2]+off[2]]];

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

    eps = qpp_eps;
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

    _qpp_compose_corner_cut(points=_xy_cuts,offs=_xy_offs,h=_cz);
    
    
}