// check variable size, three possible outcomes:
//  0 if variable size is scalar
//  1 if variable size is vector of expected_size
// -1 if variable size is vector of different size
function _is_valid_sized_list(size, expected_size) =
    //echo(str(size,", ", expected_size))
    is_list(size) && len(size) == expected_size ? 
        1 :
        is_list(size) ? -1 : 0;

// MINI UNIT TEST
/*
echo(str([1,3,9],"~", _is_valid_sized_list([1,3,9])));
echo(str(1,"~", _is_valid_sized_list(1)));
echo(str([12,2],"~", _is_valid_sized_list([12,2], expected_size=2)));
echo(str([1,3,9],"~", _is_valid_sized_list([1,3,9], expected_size=2)));
*/

// check variable size, three possible outcomes:
//  0 if variable size is scalar
//  1 if variable size is 3D vector
// -1 if variable size is vector of different size
function is_valid_3D_list(size) = _is_valid_sized_list(size,expected_size=3);

// check variable size, three possible outcomes:
//  0 if variable size is scalar
//  1 if variable size is 2D vector
// -1 if variable size is vector of different size
function is_valid_2D_list(size) = _is_valid_sized_list(size,expected_size=2);

// attempts to unpack single item list from variable size, returns:
// - scalar containg size[0] if size is a list of size 1
// - original list size, otherwise
function try_to_upack_list(size) =
    is_list(size) && len(size) == 1 ?
        size[0] :
        size;

// MINI UNIT TEST
/*
echo(str([2]," has extract form ", try_to_upack_list([2])));
echo(str([1,2]," has extract form ", try_to_upack_list([1,2])));
echo(str(2," has extract form ", try_to_upack_list(2)));
*/