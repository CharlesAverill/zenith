# ZENITH
Zen Engine for Navigating wIreframes In Three-dimensional Holographic space

![teapot](media/success2/teapot.gif)

## Usage

ZENITH is built with [dune](https://dune.build), and depends on the OCaml `Graphics` library. To run:

```
make run                    # Will render the Utah teapot .obj file
OBJ=path_to_obj make run    # Will override teapot path
```

## Writeups

| Checkpoint | Summary |
| ----- | ----- | 
| [Bad Perspective](media/bad_perspective/BadPerspective.md) | My meshes are close to rendering correctly, but some issue with my perspective transformation maps some vertices to the origin | 
| [Success 1](media/success1/Success1.md) | My meshes now render properly |
| [Success 2](media/success2/Success2.md) | I can now load meshes from `.obj` files |

## Notes
```
  Y
  |
  |
  | 
   --------- X
  /
 /
/
Z
```
