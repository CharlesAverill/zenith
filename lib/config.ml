open Math.Vector
open Graphics

let viewportw, viewporth = (1000, 1000)
let viewpoint = v3 0. 0. 30.
let fov = 45.0
let aspect_ratio = 1.
let z_near = 0.1
let z_far = 50.
let rotation_incr = 7.5
let translation_incr = 0.5
let draw_verts = false
let vert_radius = 3
let vert_color = red
let edge_color = green
