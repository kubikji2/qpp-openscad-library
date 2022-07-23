# Q++ Openscad Library

Set of useful geometries variants and utilities for descriptive modeling tool OpenScad.

## Roadmap

Features that are planned for the library and its development state.

### Geometries

- [X] utilities
  - [x] unit tests
  - [x] vector arithmetics
    - [x] additions, subtraction, dot product, cross product wrapper
    - [x] vector norms, number of (un)def elements in list
  - [x] vector/array length, sum, checkers
- [X] ***Cube++***
  - [X] ***dice***
    - [ ] TODO handle *diceoid* and adaptive corners in `dice_exp` branch
  - [X] ***cylindrocube*** - cylinder-cube hybrid (corners and sides are rouned in xy-plane only)
  - [x] ***spherocube*** - sphere-cube hybrid
  - [x] ***cornerless_cube*** - cube with all corners cut off
  - [x] ***edgelesss_cube*** - cube with edges cut off
- [ ] **Box++** box variants for *cube++*
  - interface defines additionally bottom- and wall-thickness
  - foreseen issue: handle the corners/edges cuts parameters
  - [ ] *box* regular cuboid
  - [ ] *cylindrobox*
  - [ ] *spherobox*
  - [ ] *cornerless_box*
  - [ ] *edgesless_box*
- [x] ***trapezoid***
- [x] ***tetrahedron***
  - this is just a spicy prism, check for possible merge
  - [x] *regular tetrahedron*
  - [ ] ~~*spherotetrahedron*~~ hard to solve analytically
  - [x] *regular spherotetrahedron*
- [x] ***prisms***
  - [x] *prism*
  - [x] *cylindroprism*
  - [x] *spheroprism*
  - [x] *regular prism* - prism with an n-sided regular polygon as a base
  - [x] *regular cylindroprism*
  - [x] *regular spheroprism*
- [ ] ***pyramid***
  - [x] *pyramid*
  - [ ] *spheropyramid*
  - [x] *regular pyramid*
  - [ ] *regular spheropyramid*
  - [x] *cone* wrapper
  - [ ] *sherocone*
  - [x] *regular cone*
  - [ ] *regular spherocone*
- [ ] ***wrinkled geometries***
  - [x] *wrinkled cylinder* - can-like geometry
  - [x] *wrinkled cylinder with toroid wrinkles*
  - [ ] *wrinkled prism*
  - [ ] *wrinkled prism with toroid wrinkles*
- [x] ***basic geometries***
  - [x] *toroid*
  - [x] *annular cylinder* or *ring*
  - [x] *"conical ring with a conical hole"*
  - [x] *spheroring*
- [ ] ***randomly wrapped cuboid*** - for damage like-feel
- [ ] ***rotary polynomials*** - for different polynomial degrees

### Shapes and logos

- [x] radiation logo
- [x] biohazard logo

### Library

- [ ] extract each geometry into separate files
- [ ] create geometries collections grouped by similar properties using includes a.k.a. library files
  - [ ] **sphero-** geometries
    - [ ] *spherocube*/*spherocuboid*
    - [ ] *spherocylinder*
    - [ ] *spheroring*
    - [ ] ~~*spheroprism*~~
    - [ ] *regular spheroprism*
    - [ ] *regular tetrahedron*
    - [ ] TODO add other
  - [x] **Cube++**
    - [x] *cylindrocube* / *cylindrocuboid*
    - [x] *spherocube* / *spherocuboid*
    - [x] *cornerless cube* / *cuboid*
    - [x] *edgeless cube* / *cuboid*
    - [x] *dice* ???
    - [ ] TODO add others
- some stuff for "ring" alternative
- box and lids library

### Features

- [x] ***repeat*** transformation
- [x] ***conditional difference*** transformation
- [ ] make all geometries alignable to center in xyz and to center in xy-plane
  - TODO: define a reasonable and unified interface
- [ ] debug utilities
  - [ ] coordinate frame - for transforms
- [ ] functions to get a transform (translation and rotation) to the center of each side, edge, and corner of geometries given its parameters.
  - [ ] basic geometries
  - [ ] implement for basic geometries equivalents (cylindrocubes, spherocubes...)
  - [ ] implement for non-basic geometries (prisms, pyramids,...)
- [ ] create modules for shell-like geometries
- [ ] create modules for box-like geometries, including the lid and the box itself
- [ ] create patterns generators for pattern cutters
