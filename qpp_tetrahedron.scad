use <qpp_utils.scad>
include<qpp_constants.scad>

// tetrahedron
// '-> requires four 3D points to be constructed
//     '-> points[0:2] creates the base according the right-hand rule
//     '-> fourth point is above the base
module qpp_tetrahedron(points=[[0,0,0],[1,0,0],[0,1,0],[0,0,1]])
{
    _module_name = "[QPP-tetrahedron]";

    // check we have four points
    assert(is_list(points) && qpp_len(points) == 4, str(_module_name, " tetrahedron requires four points, but ", qpp_len(points), " were provided!"));   
    // check all points are 3D
    for (_point=points)
    {
        assert(is_list(_point) &&  qpp_len(_point) == 3, str(_module_name, " some of the points are not 3D!"));
    }

    // TODO handle self-intersection

    // compose points
    _points = points;
    // compose facets
    _facets = [
                [0,1,2],
                [3,1,0],
                [3,2,1],
                [3,0,2],
              ];

    // geometry
    polyhedron(_points, _facets);

}


// regular tetrahedron
// '-> variable "a" is the length of the tetrahedron edge
//     '-> a or [a]
module qpp_regular_tetrahedron(a=1)
{
    _module_name = "[QPP-regular_tetrahedron]";
    
    // check side
    _a = qpp_try_to_unpack_list(a);
    assert(_a > 0, str(_module_name, " variable \"a\" cannot be negative!"));

    // create points
    _va = sqrt(_a*_a-(_a/2)*(_a/2));
    _h = sqrt(_a*_a-((2/3)*_va)*((2/3)*_va));
    _points = [ [_a/2,0,0],
                [0,_va,0],
                [-_a/2,0,0],
                [0,(1/3)*_va,_h]
              ];
    
    translate([0,-(1/3)*_va,0])
        qpp_tetrahedron(points=_points);
}


// regular tetrahedron with rounded corners
// '-> variable "a" is the length of the tetrahedron edge
//     '-> a or [a]
// '-> variable "r" is a corner rounding radius
// '-> variable "d" is a corner rounding diameter
module qpp_regular_spherotetrahedron(a=1, r=0.1, d=undef, $fn=qpp_fn)
{
    _module_name = "[QPP-regular_spherotetrahedron]";
    
    // check side
    _a = qpp_try_to_unpack_list(a);
    assert(_a > 0, str(_module_name, " variable \"a\" cannot be negative!"));

    // check radius
    _r = is_undef(d) ? r : d/2;
    assert(_a > 0, str(_module_name, " neither variable \"r\", nor \"d\" cannot be negative!"));

    // compute edge _aa for regular tetrahedron to be rounded
    // '-> yeah that's magic, right?
    // '-> _ang is face-edge-face angle
    _ang = atan(2*sqrt(2));
    // '-> _rp is projection of the distance between the sloped edges to the xy-plane
    _rp = _r/sin(_ang);
    // '-> _da is a difference between the inner tetrahedra and the outer tetrahedra
    _da = _rp/tan(30);
    // '-> _va is auxiliary variable to compute height of the outer tetrahedra
    _va = sqrt(_a*_a-(_a/2)*(_a/2));
    _h = sqrt(_a*_a-((2/3)*_va)*((2/3)*_va));
    // '-> firstly get the a size at the height _r and then subtract _da
    _aa = _a*(1-(_r/_h)) - 2*_da;

    // minkowski sum
    translate([0,0,_r])
    minkowski()
    {
        // regular tetrahedron
        qpp_regular_tetrahedron(a=_aa);
        // sphere
        sphere(r=_r,$fn=$fn);
    }

}
