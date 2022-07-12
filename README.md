# Q++ Openscad Library

Set of useful geometries variants and utilities for descriptive modeling tool OpenScad.

## Roadmap

Features that are planned for the library and its development state.

### Geometries

- [X] utilities
  - [x] unit tests
  - [x] vector arithmetics
    - [x] additions, subtraction, dot product, cross product wrapper
    - [x] vector norms added
  - [x] vector/array length, sum, checkers
- [X] ***dice*** (first, since it is an easy shape)
- [X] ***cylindrocube*** - cylinder-cube hybrid (corners and sides are rouned in xy-plane only)
- [x] ***spherocube*** - sphere-cube hybrid
- [x] ***cornerless_cube*** - cube with all corners cut off
- [x] ***edgelesss_cube*** - cube with edges cut off
- [x] ***trapezoid***
- [x] ***tetrahedron***
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
  - [ ] *wrinkled cylinder* - can-like geometry
  - [ ] *wrinkled prism*
  - [ ] sphere-like wrapped alternatives
- [ ] ***basic geometries***
  - [x] *toroid*
  - [ ] *annular cylinder* or *ring*
  - [ ] *"ring with a conical hole"*
  - [ ] *spheroring*
- [ ] ***randomly wrapped cuboid*** - for damage like-feel
- [ ] ***rotary polynomials*** - for different polynomial degrees

### Shapes and logos

- [x] radiation logo
- [x] biohazard logo

### Features

- [x] ***repeat*** transformation
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
