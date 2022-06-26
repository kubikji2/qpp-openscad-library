use <qpp_utils.scad>

function qpp_prism_shell_idx(n_sides) =
    [for (i=[0:n_sides-1]) [i, (i+1)%n_sides, n_sides+(i+1)%n_sides, n_sides+i]];

// module for creating vertical prisms
// '-> points is a list of points defining the base of the shape in xy-plane
//     '-> points are expected to be 2D
// '-> h is the height of the prisim
module qpp_prism(points=[[0,0],[0,1],[1,0]],h=1)
{
    _module_name = "[QPP-prism]";
    // check the length of points
    assert(is_list(points),str(_module_name, " variable \"points\" is not a list!"));
    assert(qpp_len(points) >= 3,str(_module_name, " variable \"points\" must contain at least three elements!"));

    for(_point=points)
    {
        assert(qpp_len(_point) == 2, str(_module_name, " some point in variable \"points\" is not 2D!"));
    }

    _3D_points_base = [for (_point=points) [_point[0],_point[1],0]];
    //echo(_3D_points_base);
    _3D_points_top = [for (_point=points) [_point[0],_point[1],h]];
    //echo(_3D_points_top);

    _3D_points = [for (_point=_3D_points_base) _point, for (_point=_3D_points_top) _point];
    echo(_3D_points);

    _n_sides = len(points);
    _shell_idxs = qpp_prism_shell_idx(_n_sides);
    //echo(_shell_idxs);

    _faces = [ [for(i=[0:_n_sides-1]) i] , each _shell_idxs, [for(i=[0:_n_sides-1]) i + _n_sides]];
    echo(_faces)
    polyhedron(_3D_points, _faces);

}