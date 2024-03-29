include <qpp_utils.scad>
include <qpp_unit.scad>

function test_passed_text(f) =
    str("[QPP-UNIT-TEST] ALL TESTS for fcn \"", str(f),"\" PASSED");

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
    echo(test_passed_text(f)); 
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
    echo(test_passed_text(f)); 
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
    qpp_unit_test_function(fcn=f, data=args);
    echo(test_passed_text(f)); 
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
    qpp_unit_test_function(fcn=f, nargs=2, data=args);
    echo(test_passed_text(f)); 
}

qpp_test_check_len();


module qpp_test_len()
{
    args = [
            [[1],1],
            [1,0],
            [undef,-1],
            [[1,2,3],3]
           ];
    
    f = function(x) qpp_len(x);
    qpp_unit_test_function(fcn=f, data=args);
    echo(test_passed_text(f));
}

qpp_test_len();


module qpp_test_len_s()
{
    args = [
            [[1],"1"],
            [1,">scalar<"],
            [undef,">undef<"],
            [[1,2,3],"3"]
           ];
    
    f = function(x) qpp_len_s(x);
    qpp_unit_test_function(fcn=f, data=args);
    echo(test_passed_text(f));
}

qpp_test_len_s();


module qpp_test_add_vec()
{
    args = [
            [[1,2],[1],undef],
            [[1,2],1,undef],
            [[1,2],[11,2,3],undef],
            [[1,2,3],[3,2,1],[4,4,4]],
            [[1,2],[1,2],[2,4]]    
    ];

    f = function(x,y) qpp_add_vec(x,y);
    qpp_unit_test_function(fcn=f, data=args, nargs=2);
    echo(test_passed_text(f));
}

qpp_test_add_vec();


module qpp_test_sub_vec()
{
    args = [
            [[1,2],[1],undef],
            [[1,2],1,undef],
            [[1,2],[11,2,3],undef],
            [[1,2,3],[3,2,1],[-2,0,2]],
            [[1,2],[1,2],[0,0]]    
    ];

    f = function(x,y) qpp_sub_vec(x,y);
    qpp_unit_test_function(fcn=f, data=args, nargs=2);
    echo(test_passed_text(f));
}

qpp_test_sub_vec();

module qpp_test_sum_vec()
{
    args = [
            [0,undef],
            [[1,2,4], 7],
            [[1,-1,0], 0],
            [[-2,3,-4], -3]
           ];

    f = function(x) qpp_sum_vec(x);
    qpp_unit_test_function(fcn=f, data=args);
    echo(test_passed_text(f));
}

qpp_test_sum_vec();

module qpp_test_dot_vec()
{
    args = [
            [0,1, undef],
            [1,[2], undef],
            [[1,1,1],[1,1], undef],
            [[1,1,1],[1,1,1],3],
            [[1,1,1],[1,2,3],6],
            [[1,2,3],[1,2,0],5],
           ];

    f = function(x,y) qpp_dot_vec(x,y);
    qpp_unit_test_function(fcn=f, data=args, nargs=2);
    echo(test_passed_text(f));
}

qpp_test_dot_vec();

module qpp_test_pts2vec()
{
    args = [
            [0,1, undef],
            [1,[2], undef],
            [[1,1,1],[1,1], undef],
            [[1,1,1],[1,1,1],[0,0,0]],
            [[1,1,1],[1,2,3],[0,1,2]],
            [[1,2,3],[1,2,0],[0,0,-3]],
           ];

    f = function(x,y) qpp_pts2vec(x,y);
    qpp_unit_test_function(fcn=f, data=args, nargs=2);
    echo(test_passed_text(f));
}

qpp_test_pts2vec();

module qpp_test_norm()
{
    args = [
            [[0,1], 1],
            [[1,1], sqrt(2)],
            [[0,0,0], 0],
            [[2,2,2], sqrt(12)],
            [[1,2,3], sqrt(14)]
    ];
    f = function(x) qpp_norm_vec(x);
    qpp_unit_test_function(fcn=f, data=args);
    echo(test_passed_text(f));
}

qpp_test_norm();

module qpp_test_norm2()
{
    args = [
            [[0,1], 1],
            [[1,1], 2],
            [[0,0,0], 0],
            [[2,2,2], 12],
            [[1,2,3], 14]
    ];
    f = function(x) qpp_norm2_vec(x);
    qpp_unit_test_function(fcn=f, data=args);
    echo(test_passed_text(f));
}

qpp_test_norm2();

module qpp_test_count_undef()
{
    args = [
            [[1,undef], 1],
            [[undef], 1],
            [[0, undef, undef, 1], 2],
            [[0, undef, undef, 1, undef], 3]
    ];
    f = function(x) qpp_count_undef(x);
    qpp_unit_test_function(fcn=f, data=args);
    echo(test_passed_text(f));
}

qpp_test_count_undef();

module qpp_test_count_def()
{
    args = [
            [[1,undef], 1],
            [[undef], 0],
            [[0, undef, undef, 1], 2],
            [[0, undef, undef, 1, undef], 2]
    ];
    f = function(x) qpp_count_def(x);
    qpp_unit_test_function(fcn=f, data=args);
    echo(test_passed_text(f));
}

qpp_test_count_def();

module qpp_test_const_x_vec()
{
    args = [
            [1,0,           0           ],
            [[1,1],0.5,     [0.5,0.5]   ],
            [[1],[1],       undef       ],
            [0.5, [1,1],    [0.5,0.5]   ]
    ];
    f = function(x,y) qpp_scale_vec(x,y);
    qpp_unit_test_function(fcn=f, data=args, nargs=2);
    echo(test_passed_text(f));
}

qpp_test_const_x_vec();