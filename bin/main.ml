open Graphics
open Zenith.Config
open Zenith.Logging
open Zenith.Mesh
open Zenith.Render
open List

let clear_window color =
  let fg = foreground in
  set_color color;
  fill_rect 0 0 (size_x ()) (size_y ());
  set_color fg

let to_draw = ref cube
let break_mainloop = ref false
let euler = ref (0., 0., 0.)

let update_euler n d =
  let eulerx, eulery, eulerz = !euler in
  match n with
  | 0 -> euler := (eulerx +. d, eulery, eulerz)
  | 1 -> euler := (eulerx, eulery +. d, eulerz)
  | 2 -> euler := (eulerx, eulery, eulerz +. d)
  | _ ->
      fatal rc_MatchError
        ("Tried to update euler angle " ^ string_of_int n
       ^ ", but expected [0:2]")

let input_dispatch key =
  match key with
  (* Pitch *)
  | 'w' -> update_euler 0 (-.rotation_incr)
  | 's' -> update_euler 0 rotation_incr
  (* Yaw *)
  | 'a' -> update_euler 1 (-.rotation_incr)
  | 'd' -> update_euler 1 rotation_incr
  (* Roll *)
  | 'q' -> update_euler 2 (-.rotation_incr)
  | 'e' -> update_euler 2 rotation_incr
  (* Escape *)
  | x when x = char_of_int 27 -> break_mainloop := true
  | _ ->
      print_int (int_of_char key);
      print_endline ""

let draw_scene () =
  clear_window black;
  set_color white;
  draw_mesh !to_draw !euler;
  let input = wait_next_event [ Poll ] in
  synchronize ();
  if input.keypressed then input_dispatch (read_key ())

let rec main_loop () =
  draw_scene ();
  if !break_mainloop then () else main_loop ()

let () =
  let args = Argparse.parse_arguments () in
  to_draw := args.obj_mesh;
  open_graph (" " ^ string_of_int viewportw ^ "x" ^ string_of_int viewporth);
  auto_synchronize false;
  main_loop ()
