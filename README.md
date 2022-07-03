# Q++ Openscad Library

Set of useful geometries variants and utilities for descriptive modeling tool OpenScad.

## Roadmap

Features that are planned for the library and its development state.

### Geometries

- [X] utilities
  - [x] unit tests
  - [x] vector arithmetics
    - [x] additions, subtraction, dot product, cross product wrapper
  - [x] vector/array length, sum, checkers
- [X] ***dice*** (first, since it is an easy shape)
- [ ] ***cylindrocube*** - cylinder-cube hybrid (corners and sides are rouned in xy-plane only)
- [x] ***spherocube*** - sphere-cube hybrid
- [x] ***cornerless_cube*** - cube with all corners cut off
- [x] ***edgelesss_cube*** - cube with edges cut off
- [x] ***trapezoid***
- [x] ***tetrahedron***
  - [ ] *regular tetrahedron*
  - [ ] *spherotetrahedron*
  - [ ] *regular spherotetrahedron*
- [x] ***prisms***
  - [x] *prism*
  - [x] *cylindroprism*
  - [x] *spheroprism*
  - [x] *regular prism* - prism with an n-sided regular polygon as a base
  - [x] *regular cylindroprism*
  - [x] *regular spheroprism*
- [ ] ***pyramid***
  - [ ] *regular pyramid*
  - [ ] *regular spheropyramid*
- [ ] ***wrapped cylinder*** - can-like geometry
- [ ] ***randomly wrapped cuboid***

### Shapes and logos

- [ ] radiation logo
- [ ] biohazard logo

### Features

- [ ] make all geometries alignable to center in xyz and to center in xy-plane
  - TODO: define reasonable and unified interface
- [ ] debug utilities
  - [ ] coordinate frame - for transforms
- [ ] create functions to get transform (translation and rotation) to the center of each side, edge, and corner of geometries given its parameters.
  - [ ] basic geometries
  - [ ] implement for basic geometries equivalents (cylindrocubes, spherocubes...)
  - [ ] implement for non-basic geometries (prisms, pyramid,...)
- [ ] create modules for shell-like geometries
- [ ] create modules for box-like geometries including the lid and the box itself
- [ ] create patterns generators for pattern cutters