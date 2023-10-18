open Graphics
open Logging
open Zenith.Config
open Math.Vector
open Zenith.Mesh
open Zenith.Renderer

let clear_window color =
  let fg = foreground in
  set_color color;
  fill_rect 0 0 (size_x ()) (size_y ());
  set_color fg

let evenly_spaced_positions meshes =
  let n = List.length meshes in
  let largest_dist = largest_distance meshes in
  _log Log_Debug (string_of_float largest_dist);
  let radius = if n > 1 then 1. +. largest_dist else 0. in
  let delta_theta = 2.0 *. Float.pi /. float_of_int n in

  let rec generate_positions theta count acc =
    if count <= 0 then acc
    else
      let x = radius *. Float.cos theta in
      let y = radius *. Float.sin theta in
      generate_positions (theta +. delta_theta) (count - 1) (acc @ [ v3 x y 0. ])
  in

  generate_positions 0.0 n []

let to_draw = ref []
let break_mainloop = ref false
let euler = ref zvec
let translation = ref zvec

let update_euler n d =
  let eulerx, eulery, eulerz =
    match !euler with { x; y; z; w = __ } -> (x, y, z)
  in
  match n with
  | 0 -> euler := { x = eulerx +. d; y = eulery; z = eulerz; w = 0. }
  | 1 -> euler := { x = eulerx; y = eulery +. d; z = eulerz; w = 0. }
  | 2 -> euler := { x = eulerx; y = eulery; z = eulerz +. d; w = 0. }
  | _ ->
      fatal rc_MatchError
        ("Tried to update euler angle " ^ string_of_int n
       ^ ", but expected [0:2]")

let update_translation n d =
  let tx, ty, tz = match !translation with { x; y; z; w = __ } -> (x, y, z) in
  match n with
  | 0 -> translation := { x = tx +. d; y = ty; z = tz; w = 0. }
  | 1 -> translation := { x = tx; y = ty +. d; z = tz; w = 0. }
  | 2 -> translation := { x = tx; y = ty; z = tz +. d; w = 0. }
  | _ ->
      fatal rc_MatchError
        ("Tried to update translation " ^ string_of_int n
       ^ ", but expected [0:2]")

let input_dispatch key =
  match key with
  (* X Translation *)
  | 'a' -> update_translation 0 (-.translation_incr)
  | 'd' -> update_translation 0 translation_incr
  (* Y Translation *)
  | 'w' -> update_translation 1 translation_incr
  | 's' -> update_translation 1 (-.translation_incr)
  (*Z Translation *)
  | 'q' -> update_translation 2 (-.translation_incr)
  | 'e' -> update_translation 2 translation_incr
  (* Pitch *)
  | 'i' -> update_euler 0 (-.rotation_incr)
  | 'k' -> update_euler 0 rotation_incr
  (* Yaw *)
  | 'j' -> update_euler 1 (-.rotation_incr)
  | 'l' -> update_euler 1 rotation_incr
  (* Roll *)
  | 'u' -> update_euler 2 (-.rotation_incr)
  | 'o' -> update_euler 2 rotation_incr
  (* Reset scene *)
  | 'r' ->
      euler := zvec;
      translation := zvec
  (* Escape *)
  | x when x = char_of_int 27 -> break_mainloop := true
  | _ ->
      print_int (int_of_char key);
      print_endline ""

let framecount = ref 0

let rotate_mode = false

let draw_scene () =
  display_mode false;
  clear_window black;
  (* Draw each mesh at their offset *)
  for i = 0 to List.length !to_draw - 1 do
    if rotate_mode then (
      update_euler 0 (0.125 *. Float.sin (0.025 *. float_of_int !framecount));
    update_euler 1 0.25;
    update_euler 2 (0.125 *. Float.cos (0.025 *. float_of_int !framecount))
    );
    
    let mesh, offset = List.nth !to_draw i in
    draw_mesh mesh !euler (v3_add !translation offset)
  done;
  let input = wait_next_event [ Poll ] in
  synchronize ();
  display_mode true;
  if input.keypressed then input_dispatch (read_key ());
  framecount := !framecount + 1

let rec main_loop () =
  draw_scene ();
  if !break_mainloop then () else main_loop ()

let start meshes =
  (* Evenly-space meshes *)
  let mesh_positions = evenly_spaced_positions meshes in
  to_draw := List.combine meshes mesh_positions;
  auto_synchronize false;
  open_graph (" " ^ string_of_int viewportw ^ "x" ^ string_of_int viewporth);
  set_window_title "ZENITH";
  main_loop ()
