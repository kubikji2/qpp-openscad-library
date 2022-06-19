include <qpp_utils.scad>
include <qpp_unit.scad>

module test_is_valid_3D_list()
{
    args = [
            [[1,3,9],1],
            [1,0],
            [[12,3],-1],
            [[1,3,5,4],-1]
           ];
    
    f = function(x) is_valid_3D_list(x);
    unit_test_function(fcn=f,data=args);
    echo(str("[UNIT-TEST] ALL TESTS for fcn \"", str(f),"\" PASSED")); 
}

test_is_valid_3D_list();

module test_is_valid_2D_list()
{
    args = [
            [[1,3],1],
            [1,0],
            [[12],-1],
            [[1,3,5,4],-1]
           ];
    
    f = function(x) is_valid_2D_list(x);
    unit_test_function(fcn=f,data=args);
    echo(str("[UNIT-TEST] ALL TESTS for fcn \"", str(f),"\" PASSED")); 
}

test_is_valid_2D_list();

module test_try_to_upack_list()
{
    args = [
            [[2],2],
            [[1,2],[1,2]],
            [4,4],
            [[1,3,5,4],[1,3,5,4]]
           ];
    
    f = function(x) try_to_upack_list(x);
    unit_test_function(fcn=f,data=args);
    echo(str("[UNIT-TEST] ALL TESTS for fcn \"", str(f),"\" PASSED")); 
}

test_try_to_upack_list();
