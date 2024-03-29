// function evaluation (execution) based on the number of arguments
// Faigl forgive me!
// '-> AFAIK, there is no way how to expand list so here we are, killing Coding-style God
function get_results(fcn,nargs,data) =
    nargs == 1 ? 
        //echo(str(data[0]))
        fcn(data[0]) : nargs == 2 ?
            //echo(str(data, ": ",data[0],", ",data[1]))
            fcn(data[0], data[1]) : nargs == 3 ?
                //echo(data[0], data[1], data[2])
                fcn(data[0], data[1], data[2]) : nargs == 4 ?
                    //echo(data[0], data[1], data[2], data[3]) 
                    fcn(data[0], data[1], data[2], data[3]) : nargs == 5 ?
                        //echo(data[0], data[1], data[2], data[3], data[4])
                        fcn(data[0], data[1], data[2], data[3], data[4]) : undef;

// UNIT TEST
// test multiparameter function "fcn" with "nargs" arguments using "data"
// each row r of "data" can be devided to:
// '-> r[0:nargs-1] - inputs to fcn
// '-> r[nargs] - expected output of fcn
// inputs and outputs are conviniently concatanated in single variable for better test design
module qpp_unit_test_function(fcn,data,nargs=1)
{
    // check for negative arguments
    assert(nargs > 0, str("[QPP-UNIT-TEST] number of arguments \"nargs\" cannot be negative!"));
    // check for too many arguments
    assert(nargs <= 5, str("[QPP-UNIT-TEST] number of arguments \"nargs\" cannot be greater then 5, sorry!"));
    
    for (c_data=data)
    {
        // extract args
        args = [for (i=[0:nargs-1]) each [c_data[i]]];      
        // extract expected result
        ref = c_data[nargs];
        
        // get real result
        res = get_results(fcn, nargs, args);

        // check results
        assert(ref==res, str("[UNIT-TEST] fcn \"", str(fcn)[1],"\" FAILED, input: ", args, " expected: ", ref, ", but got: ", res, " instead!"));
    }    
}
