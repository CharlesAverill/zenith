# Success 2

I have an `.obj` loader!

![teapot](teapot.gif)

Thankfully the format is extremely simple. I don't support faces, so I had to import an existing Utah Teapot `.obj` to Blender, remove its faces, and re-export to get the one rendered here. But this is surprisingly performant. Drawing vertices does deal a pretty large blow to runtime, so I've left it off for this gif. I think now I want to expand the capabilities of this rendering engine, possibly by making a game engine. Goals:
- Multiple objects
- Rotation, transformation, scale functions per object that update over time
- Camera movement
- Colors
- Composite meshes
