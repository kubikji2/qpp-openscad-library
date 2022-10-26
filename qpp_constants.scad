// number fo fragments used in this library for curves approximation
qpp_fn = 30;

// epsilon value usef by across this library for some small insignificant offsets
qpp_eps = 0.01;


// side names
QPP_FRONT_SIDE = "front";
QPP_BACK_SIDE = "back";
QPP_LEFT_SIDE = "left";
QPP_RIGHT_SIDE = "right";
QPP_TOP_SIDE = "top";
QPP_BOTTOM_SIDE = "bottom";

// Basically a dictionary with translation and rotation to the cube-like geometries
// '-> Each entry contains:
//     '-> side name (key)
//     '-> translation direction relative to the cuboid size
//     '-> rotation with y-axis symetry being perserved with the highest priority
QPP_CUBOID_SIDES = [    
                        [QPP_FRONT_SIDE,    
                            [  0.0, -0.5,  0.0],    [  90,   0,  0 ] ],
                        [QPP_BACK_SIDE,
                            [  0.0,  0.5,  0.0],    [ -90,   0,  0 ] ],
                        [QPP_LEFT_SIDE,    
                            [ -0.5,  0.0,  0.0],    [   0, -90,  0 ] ],
                        [QPP_RIGHT_SIDE,
                            [  0.5,  0.0,  0.0],    [   0,  90,  0 ] ],
                        [QPP_TOP_SIDE,      
                            [  0.0,  0.0,  0.5],    [   0,   0,  0 ] ],
                        [QPP_BOTTOM_SIDE,   
                            [  0.0,  0.0, -0.5],    [   0, 180, 0 ] ],
                   ];