include<qpp_constants.scad>
use<qpp_utils.scad>
use<qpp_prism.scad>

module _qpp_place_prisms(pts,offs,dir)
{
    for(i=[0:3])
    {
        _points = [ for(j=[0:3]) if (j != i) pts[j]];
        translate(offs[i])
            qpp_prism(points=_points,off=dir);
    }
}


// edgeless cube geometry
// '-> variable "size" defines the basic shape size
//     '-> a or [a] for cube of size [a,a,a] with edges cut off
//     '-> [x,y,z] for cubioid of size [x,y,z] with edges cut off
// '-> variable "bevel" specify how much the edges are edges cut off
///    '-> b or [b] for uniform cut across all axis
//     '-> [bx,by,bz] for different cut at each axis
module qpp_edgelesscube(size=[1,1,1], bevel=0.1)
{
    _module_name = "[QPP-EdgelessCube]";
    // check size
    assert(qpp_is_valid_3D_list(size) != -1, str(_module_name, " variable \"size\" is neither scalar equivalent nor 3D array!"));
    // check bevel
    assert(qpp_is_valid_3D_list(size) != -1, str(_module_name, " variable \"bevel\" is neither scalar equivalent nor 3D array!"));

    // expand size
    _size = qpp_try_to_unpack_list(size);
    _is_uniform_size = !is_list(_size);
    _x = _is_uniform_size ? _size : _size[0];
    _y = _is_uniform_size ? _size : _size[1]; 
    _z = _is_uniform_size ? _size : _size[2];

    // expand bevel
    _bevel = qpp_try_to_unpack_list(bevel);
    _is_uniform_bevel = !is_list(_bevel);
    _bx = _is_uniform_bevel ? _bevel : _bevel[0];
    _by = _is_uniform_bevel ? _bevel : _bevel[1];
    _bz = _is_uniform_bevel ? _bevel : _bevel[2];

    // create geometry

    difference()
    {
        // basic shape
        //translate([eps,eps,eps])
        cube([_x,_y,_z]);

        eps = qpp_eps;
        
        // X-AXIS cuts
        _x_dir = [_x+2*eps,0,0];
        _x_pts = [
                    [-eps, _by+eps, _bz+eps],
                    [-eps,    -eps, _bz+eps],
                    [-eps,    -eps,    -eps],
                    [-eps, _by+eps,    -eps]
                 ];
        // offsets for x-axis direction
        _x_offs = [
                    [0,      0,      0],
                    [0, _y-_by,      0],
                    [0, _y-_by, _z-_bz],
                    [0,      0, _z-_bz],
                  ];
        // generate cuts, if there are any
        if ((_by > 0) && (_bz > 0))
        { 
            _qpp_place_prisms(pts=_x_pts,offs=_x_offs,dir=_x_dir);
        }

        // Y-AXIS cuts
        _y_dir = [0,_y+2*eps,0];
        _y_pts = [
                    [_bx+eps, -eps, _bz+eps],
                    [   -eps, -eps, _bz+eps],
                    [   -eps, -eps,    -eps],
                    [_bx+eps, -eps,    -eps]
                 ];
        // offsets for y-axis direction
        _y_offs = [
                    [0,      0,     0],
                    [_x-_bx, 0,     0],
                    [_x-_bx, 0, _z-_bz],
                    [0,      0, _z-_bz],
                  ];
        // generate cuts, if there are any
        if ((_bx > 0) && (_bz > 0))
        {
            _qpp_place_prisms(pts=_y_pts,offs=_y_offs,dir=_y_dir);
        }

        // Z-AXIS cuts
        _z_dir = [0,0,_z+2*eps];
        _z_pts = [
                    [_bx+eps, _by+eps, -eps],
                    [   -eps, _by+eps, -eps],
                    [   -eps,    -eps, -eps],
                    [_bx+eps,    -eps, -eps]
                 ];
        // offsets for z-axis direction
        _z_offs = [
                    [0,           0, 0],
                    [_x-_bx,      0, 0],
                    [_x-_bx, _y-_by, 0],
                    [0,      _y-_by, 0],
                  ];
        // generate cuts, if there are any
        if ((_bx > 0) && (_by > 0))
        {
            _qpp_place_prisms(pts=_z_pts,offs=_z_offs,dir=_z_dir);
        }
    }
}