// check variable size, three possible outcomes:
//  0 if variable size is scalar
//  1 if variable size is vector of expected_size
// -1 if variable size is vector of different size
function _qpp_is_valid_sized_list(size, expected_size) =
    //echo(str(size,", ", expected_size))
    is_list(size) && len(size) == expected_size ? 
        1 :
        is_list(size) ? -1 : 0;

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

// returns the text for failed list length
function qpp_assert_len_txt(module_name, arr, arr_name, exp_len=3) = 
    str("[QPP-",str(module_name),"] the '",str(arr_name),"' variable is a list of unacceptable size (", str(len(arr)) ,"), only scalar and list of sizes 1 or ", str(exp_len) , " are accepted.");

// check whether the "cur_len" is list "pos_lens"
// '-> in case pos_lens is a scalar, the "cur_len" is compared to "pos_lens" directly
function qpp_check_lens(cur_len, pos_lens) =
    // echo(str("[QPP-utils] cur_len=",str(cur_len), ", pos_lens", str(pos_lens)))
    !is_list(pos_lens)
        ? cur_len == pos_lens
        : len(search(cur_len,pos_lens)) > 0;

// safe implementation of length applicable to:
// - list/vectors -> return its length
// - scalars      -> returns 0
// - >undef<      -> returns -1 
// NOTE: use this to avoid warning in asserts...
function qpp_len(array) =
    is_list(array) ?
        len(array) :
        is_undef(array) ?
            -1 : 0;

// text representation of qpp_len:
// - list/vectors -> return its length as strin
// - scalars      -> returns ">scalar<"
// - >undef<      -> returns ">undef<"
function qpp_len_s(array) = 
    is_list(array) ?
        str(len(array)) :
        is_undef(array) ?
            ">undef<" : ">scalar<";

// adding two vectors of the same lenght
function qpp_add_vec(arr1,arr2) =
    is_list(arr1) && is_list(arr2) && len(arr1)==len(arr2) ?
        [for (i=[0:len(arr1)-1]) arr1[i]+arr2[i]] :
        undef;

// substract two vectors of the same lenght
function qpp_sub_vec(arr1,arr2) =
    is_list(arr1) && is_list(arr2) && len(arr1)==len(arr2) ?
        [for (i=[0:len(arr1)-1]) arr1[i]-arr2[i]] :
        undef;