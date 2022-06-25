use <constants.scad>

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
module qpp_trapezoid(size=[1,1,1,0.5,0.5], base=undef, top=undef, h=undef, xy_off=undef)
{
    // TODO check size dimensions
    
}