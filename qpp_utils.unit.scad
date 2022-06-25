include <qpp_utils.scad>
include <qpp_unit.scad>

module qpp_test_is_valid_3D_list()
{
    args = [
            [[1,3,9],1],
            [1,0],
            [[12,3],-1],
            [[1,3,5,4],-1]
           ];
    
    f = function(x) qpp_is_valid_3D_list(x);
    qpp_unit_test_function(fcn=f,data=args);
    echo(str("[UNIT-TEST] ALL TESTS for fcn \"", str(f),"\" PASSED")); 
}

qpp_test_is_valid_3D_list();

module qpp_test_is_valid_2D_list()
{
    args = [
            [[1,3],1],
            [1,0],
            [[12],-1],
            [[1,3,5,4],-1]
           ];
    
    f = function(x) qpp_is_valid_2D_list(x);
    qpp_unit_test_function(fcn=f,data=args);
    echo(str("[UNIT-TEST] ALL TESTS for fcn \"", str(f),"\" PASSED")); 
}

qpp_test_is_valid_2D_list();

module qpp_test_try_to_unpack_list()
{
    args = [
            [[2],2],
            [[1,2],[1,2]],
            [4,4],
            [[1,3,5,4],[1,3,5,4]]
           ];
    
    f = function(x) qpp_try_to_unpack_list(x);
    qpp_unit_test_function(fcn=f,data=args);
    echo(str("[UNIT-TEST] ALL TESTS for fcn \"", str(f),"\" PASSED")); 
}

qpp_test_try_to_unpack_list();

module qpp_test_check_len()
{
    args = [
            [2,[3,2],true],
            [2,[3,1],false],
            [2,[2],true]
           ];
    f = function(x,y) qpp_check_lens(x,y);
    qpp_unit_test_function(fcn=f,nargs=2,data=args);
    echo(str("[UNIT-TEST] ALL TESTS for fcn \"", str(f),"\" PASSED")); 
}

qpp_test_check_len();