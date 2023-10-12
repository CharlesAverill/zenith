# ZENITH

![ZENITH Logo](media/logo.gif)

ZENITH ("Zen Engine for Navigating wIreframes In Three-dimensional Holographic space") is a wireframe renderer written in OCaml.

## Usage

ZENITH is built with [dune](https://dune.build), and depends on the OCaml `Graphics` library. To run:

```
# Will render the Utah teapot .obj file
make run
# Will render each object around a circle
OBJS="path_to_obj path_to_another_obj ..." make run
# Renders the demo shown below
OBJS="objs/uv_sphere.obj objs/torus.obj objs/star_destroyer.obj \
    objs/pyramid.obj objs/cube.obj objs/blender_monkey.obj objs/arwing.obj" make run
```

![demo](media/demo.gif)

## Writeups

| Checkpoint | Summary |
| ----- | ----- | 
| [Bad Perspective](media/bad_perspective/BadPerspective.md) | My meshes are close to rendering correctly, but some issue with my perspective transformation maps some vertices to the origin | 
| [Success 1](media/success1/Success1.md) | My meshes now render properly |
| [Success 2](media/success2/Success2.md) | I can now load meshes from `.obj` files |

## Notes

### Blender

If you want to color your Blender models, the only shader compatible with the `Kd` (diffuse color) field of a .MTL file is Principled BSDF.

### Supported .OBJ Vernacular

```obj
# Comments
# Vertices
v 0.0 1.9 -5.8
v 1.1 0.4 -0.7
v 38.4 0.2 7.1
# Lines
l 1 2
l 2 3
# Faces
f 1 2 3
# Faces with vertex normals (ignored)
f 1/1/1 2/2/2 3/3/3
# .MTL File Locations
mtllib mymat.mtl
# Material Usage
usemtl MyMat
```

If two faces share edges but not materials, the face occurring later in the file will overwrite those edges' colors. 

### Supported .MTL Vernacular

```mtl
# Material Name Declarations
newmtl MyMat
# Diffuse Color
Kd 0.5 0.75 1.0
```

### Axis configuration
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
