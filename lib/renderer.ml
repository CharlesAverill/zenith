open Math.Constants
open Config
open Graphics
open Math.Matrix
open Mesh
open Math.Vector

let draw_line a b =
  moveto (int_of_float a.x) (int_of_float a.y);
  lineto (int_of_float b.x) (int_of_float b.y)

let clip_matrix fov aspect_ratio near far =
  let out = id_matrix 4 4 in
  let f = 1. /. Float.tan (fov *. 0.5) in
  set out 0 0 (f *. aspect_ratio);
  set out 1 1 f;
  set out 2 2 ((far +. near) /. (far -. near));
  set out 2 3 1.;
  set out 3 2 (2. *. near *. far /. (near -. far));
  set out 3 3 0.;
  out

let view_matrix eye_pos =
  {
    arr =
      [|
        1.;
        0.;
        0.;
        -.eye_pos.x;
        0.;
        1.;
        0.;
        -.eye_pos.y;
        0.;
        0.;
        1.;
        -.eye_pos.z;
        0.;
        0.;
        0.;
        1.;
      |];
    dim = (4, 4);
  }

let model_matrix euler_rot translation_vec =
  let radx, rady, radz =
    match euler_rot with
    | { x = rotx; y = roty; z = rotz; w = _ } ->
        (deg_to_rad rotx, deg_to_rad roty, deg_to_rad rotz)
  and tx, ty, tz =
    match translation_vec with
    | { x = tx; y = ty; z = tz; w = _ } -> (tx, ty, tz)
  in
  let translation =
    {
      arr = [| 1.; 0.; 0.; tx; 0.; 1.; 0.; ty; 0.; 0.; 1.; tz; 0.; 0.; 0.; 1. |];
      dim = (4, 4);
    }
  in
  let rotation_x, rotation_y, rotation_z =
    ( {
        arr =
          [|
            1.;
            0.;
            0.;
            0.;
            0.;
            Float.cos radx;
            -.Float.sin radx;
            0.;
            0.;
            Float.sin radx;
            Float.cos radx;
            0.;
            0.;
            0.;
            0.;
            1.;
          |];
        dim = (4, 4);
      },
      {
        arr =
          [|
            Float.cos rady;
            0.;
            Float.sin rady;
            0.;
            0.;
            1.;
            0.;
            0.;
            -.Float.sin rady;
            0.;
            Float.cos rady;
            0.;
            0.;
            0.;
            0.;
            1.;
          |];
        dim = (4, 4);
      },
      {
        arr =
          [|
            Float.cos radz;
            -.Float.sin radz;
            0.;
            0.;
            Float.sin radz;
            Float.cos radz;
            0.;
            0.;
            0.;
            0.;
            1.;
            0.;
            0.;
            0.;
            0.;
            1.;
          |];
        dim = (4, 4);
      } )
  in
  let rotation = matmul (matmul rotation_x rotation_y) rotation_z in
  let scale_factor = 1. in
  let scale =
    {
      arr =
        [|
          scale_factor;
          0.;
          0.;
          0.;
          0.;
          scale_factor;
          0.;
          0.;
          0.;
          0.;
          scale_factor;
          0.;
          0.;
          0.;
          0.;
          1.;
        |];
      dim = (4, 4);
    }
  in
  (* translation * rotation * scale *)
  matmul (matmul translation rotation) scale

let projection_matrix fov aspect_ratio z_near z_far =
  let top = Float.tan (deg_to_rad (fov /. 2.) *. Float.abs z_near) in
  let right = top *. aspect_ratio in
  {
    arr =
      [|
        -.z_near /. right;
        0.;
        0.;
        0.;
        0.;
        -.z_near /. top;
        0.;
        0.;
        0.;
        0.;
        (z_near +. z_far) /. (z_near -. z_far);
        2. *. z_near *. z_far /. (z_near -. z_far);
        0.;
        0.;
        1.;
        0.;
      |];
    dim = (4, 4);
  }

let project_mesh mesh euler_rot translation =
  let mvp =
    matmul
      (matmul
         (projection_matrix Config.fov Config.aspect_ratio Config.z_near
            Config.z_far)
         (view_matrix Config.viewpoint))
      (model_matrix euler_rot translation)
  in
  let f1, f2 =
    ( (Config.z_far -. Config.z_near) /. 2.,
      (Config.z_far +. Config.z_near) /. 2. )
  in
  map_verts mesh (fun v ->
      v |> fun x ->
      (* Projection *)
      vecmatmul x mvp |> fun x ->
      (* Homogeneous division *)
      vec_div x x.w |> fun x ->
      (* Viewport transformation *)
      {
        x = 0.5 *. float_of_int viewportw *. (x.x +. 1.);
        y = 0.5 *. float_of_int viewporth *. (x.y +. 1.);
        z = (x.z *. f2) +. f1;
        w = x.w;
      })

let draw_mesh mesh euler_rot translation =
  let c = foreground in
  set_color Config.edge_color;
  let verts, edges = project_mesh mesh euler_rot translation in
  let _ =
    List.fold_left
      (fun visited_verts edge ->
        let v1, v2 = (List.nth verts (fst edge), List.nth verts (snd edge)) in
        draw_line v1 v2;
        if Config.draw_verts then (
          set_color Config.vert_color;
          if not (List.exists (fun x -> x = v1) visited_verts) then
            fill_circle (int_of_float v1.x) (int_of_float v1.y)
              Config.vert_radius;
          if not (List.exists (fun x -> x = v2) visited_verts) then
            fill_circle (int_of_float v2.x) (int_of_float v2.y)
              Config.vert_radius;
          set_color Config.edge_color);
        v1 :: v2 :: visited_verts)
      [] edges
  in
  set_color c
