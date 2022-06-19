
// UNIT TEST
// test function "fcn" using "data"
// '-> data[0] - list of inputs to fcn
// '-> data[1] - list of associated expected outputs of fcn
// input and outputs are conviniently concatanated in single variable for better test design
module unit_test_function(fcn,data)
{
    //echo(str("is function = ", is_function(fcn)));
    for (c_data=data)
    {
        // get arguments
        args = c_data[0];
        // get reference
        ref = c_data[1];
        // get real results
        res = fcn(args);
        
        // check it
        assert(ref==res, str("[UNIT-TEST] fcn \"", str(fcn),"\" FAILED, input: ", args, " expected: ", ref, ", but got: ", res, " instead!"));
    }   
}

//////////////////////////
// HIC SUNT FUTURE WORK //
//////////////////////////

/*
// Faigl forgive me!
// '-> AFAIK, there is no way how to expand list so here we are, killing Coding-style God
function get_results(fcn,nargs,data) =
    nargs == 1 ? 
        //echo(str(data[0]))
        fcn(data[0]) : nargs == 2 ?
            echo(str(data, ": ",data[0],", ",data[1]))
            fcn(data[0], data[1]) : nargs == 3 ?
                //echo(data[0], data[1], data[2])
                fcn(data[0], data[1], data[2]) : nargs == 4 ?
                    //echo(data[0], data[1], data[2], data[3]) 
                    fcn(data[0], data[1], data[2], data[3]) : nargs == 5 ?
                        //echo(data[0], data[1], data[2], data[3], data[4])
                        fcn(data[0], data[1], data[2], data[3], data[4]) : undef;


module unit_test_function(fcn,nargs,data)
{
    for (c_data=data)
    {
        //echo([for (i=[0:nargs-1]) each [c_data[i]]]);
        _args = [for (i=[0:nargs-1]) each [c_data[i]]];
        echo(str("is function = ", is_function(fcn)));
        //echo(str("ret value = ", fcn(_args)));
        
        ref = c_data[nargs];
        res = get_results(fcn, nargs, _args);

        assert(ref==res, str("[UNIT-TEST] fcn \"", str(fcn)[1],"\" FAILED, input: ", _args, " expected: ", ref, ", but got: ", res, " instead!"));

        echo(str("Variable = ", res));
    }
    
}
*/