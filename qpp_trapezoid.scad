use <qpp_constants.scad>
use <qpp_utils.scad>

// trapezoidal shape
// size variable can either be:
// '-> [A,a]
//      '-> the resulting shape has base of size A.A, the height of size A and the top of size a.a
// '-> [A,h,a]
//      '-> the resulting shape has base of size A.A, the height of size h and the top of size a.a
// '-> [A,B,h,a,b]
//      '-> the resulting shape has base of size A.B, the height of size h and the top of size a.b
// base variable can either be:
// '-> A, [A] or [A,B]
// top variable can either be:
// '-> a, [a] or [a,b]
// h variable is height of the object:
// '-> h or [h]
// xy_off is the xy offset of the top facet relative to the base facet
// '-> o, [o] or [ox,oy]  
// '-> if not provided top facet is centered
module qpp_trapezoid(size=[1,1,1,0.5,0.5], base=undef, top=undef, h=undef, xy_off=undef)
{
    // check size dimensions
    assert(qpp_check_lens(len(size),[2,3,5]), str("[QPP-trapeziod]",str(qpp_check_lens(len(size),[2,3,5]))," variable \"size\" has len=",str(len(size))," but it should be in [2,3,5]!"));

    // check all base, top and h variables for undef
    _any_def = !is_undef(base) || !is_undef(top) || !is_undef(h);
    _all_def = !is_undef(base) && !is_undef(top) && !is_undef(h);
    assert(_any_def==false || _all_def,
        str("[QPP-trapezoid] not all variable \"base\"=",
            (is_undef(base) ? ">undef<" : base),
            ", \"top\"=",
            (is_undef(top) ? ">undef<" : top),
            " and \"h\"=",
            (is_undef(h) ? ">undef<" : h),
            " are defined!"));
    
    // use size iff alternative arguments are not valid
    _use_size = !_all_def;
    
    // parse size
    _size = len(size) == 5 ?
                size :
                len(size) == 3 ?
                    [size[0],size[0],size[1],size[2],size[2]] :
                    [size[0],size[0],size[0],size[1],size[1]];

    // parse alternative arguments
    _base_u = qpp_try_to_unpack_list(base);
    _base = is_list(_base_u) ? _base_u : [_base_u, _base_u];
    _top_u = qpp_try_to_unpack_list(top);
    _top = is_list(_top_u) ? _top_u : [_top_u, _top_u];

    // parse all arguments
    _A = _use_size ? _size[0] : _base[0];
    _B = _use_size ? _size[1] : _base[1];
    _h = _use_size ? _size[2] : h;
    _a = _use_size ? _size[3] : _top[0];
    _b = _use_size ? _size[3] : _top[1];

    // check if xy_off is defined
    _xy_off_u = is_undef(xy_off) ? [(_A-_a)/2,(_B-_b)/2] : qpp_try_to_unpack_list(xy_off);
    // check xy_off dimensions
    assert(qpp_is_valid_2D_list(_xy_off_u) != -1,str("[QPP-trapezoid] variable \"xy_off\"=",str(_xy_off_u)," is neither scalar nor 2D array."));
    // parse _xy_off
    _xy_off = is_list(_xy_off_u) ? _xy_off_u : [_xy_off_u,_xy_off_u];
    _x_off = _xy_off[0];
    _y_off = _xy_off[1];
    
    // creating geometry
    // inspired by: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
    _points = [
                [ 0, 0, 0],
                [_A, 0, 0],
                [_A,_B, 0],
                [ 0,_B, 0],
                [_x_off   ,_y_off   ,_h],
                [_x_off+_a,_y_off   ,_h],
                [_x_off+_a,_y_off+_b,_h],
                [_x_off   ,_y_off+_b,_h],
              ];
    _facets = [
                [0,1,2,3],  // bottom
                [4,5,1,0],  // front
                [7,6,5,4],  // top
                [5,6,2,1],  // right
                [6,7,3,2],  // back
                [7,4,0,3]   // left
              ];
    
    // create polyhedron
    polyhedron(_points,_facets);
}