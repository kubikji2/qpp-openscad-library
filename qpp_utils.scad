// check variable size, three possible outcomes:
//  0 if variable size is scalar
//  1 if variable size is vector of expected_size
// -1 if variable size is vector of different size
function _qpp_is_valid_sized_list(size, expected_size) =
    //echo(str(size,", ", expected_size))
    is_list(size) && len(size) == expected_size ? 
        1 :
        is_list(size) ? -1 : 0;

// MINI UNIT TEST
/*
echo(str([1,3,9],"~", _qpp_is_valid_sized_list([1,3,9])));
echo(str(1,"~", _qpp_is_valid_sized_list(1)));
echo(str([12,2],"~", _qpp_is_valid_sized_list([12,2], expected_size=2)));
echo(str([1,3,9],"~", _qpp_is_valid_sized_list([1,3,9], expected_size=2)));
*/

// check variable size, three possible outcomes:
//  0 if variable size is scalar
//  1 if variable size is 3D vector
// -1 if variable size is vector of different size
function qpp_is_valid_3D_list(size) = _qpp_is_valid_sized_list(size,expected_size=3);

// check variable size, three possible outcomes:
//  0 if variable size is scalar
//  1 if variable size is 2D vector
// -1 if variable size is vector of different size
function qpp_is_valid_2D_list(size) = _qpp_is_valid_sized_list(size,expected_size=2);

// attempts to unpack single item list from variable size, returns:
// - scalar containg size[0] if size is a list of size 1
// - original list size, otherwise
function qpp_try_to_unpack_list(size) =
    is_list(size) && len(size) == 1 ?
        size[0] :
        size;

// MINI UNIT TEST
/*
echo(str([2]," has extract form ", qpp_try_to_unpack_list([2])));
echo(str([1,2]," has extract form ", qpp_try_to_unpack_list([1,2])));
echo(str(2," has extract form ", qpp_try_to_unpack_list(2)));
*/

function qpp_assert_len_txt(module_name, arr, arr_name,exp_len=3) = 
    str("[QPP-",str(module_name),"] the '",str(arr_name),"' variable is a list of unacceptable size (", str(len(arr)) ,"), only scalar and list of sizes 1 or ", str(exp_len) , " are accepted.");