open Constants
open Graphics
open Matrix
open Mesh
open Vector

let project_clip_meshes w h near far meshes =
  let _halfw, _halfh, aspect =
    ( float_of_int w *. 0.5,
      float_of_int h *. 0.5,
      float_of_int w /. float_of_int h )
  in
  let clip = clip_matrix (60. *. pi /. 180.) aspect near far in
  List.fold_left
    (fun outlist mesh ->
      let mesh' = map_verts mesh (fun v -> vecmatmul v clip) in
      mesh' :: outlist)
    [] meshes

let draw_meshes (meshes : mesh list) =
  List.fold_left
    (fun _ mesh ->
      let verts, edges = (fst mesh, snd mesh) in
      let _ =
        List.map
          (fun edge ->
            let vert_a, vert_b =
              (List.nth verts (fst edge), List.nth verts (snd edge))
            in
            (* print_endline
              ("Drawing " ^ string_of_float vert_a.x ^ " "
             ^ string_of_float vert_a.y); *)
            moveto
              (50 + int_of_float (100. *. vert_a.x))
              (50 + int_of_float (100. *. vert_a.y));
            lineto
              (50 + int_of_float (100. *. vert_b.x))
              (50 + int_of_float (100. *. vert_b.y));
            ())
          edges
      in
      ())
    () meshes
