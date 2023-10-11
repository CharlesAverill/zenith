open Graphics
open Zenith.Mesh
open Zenith.Render
open Zenith.Config
open List

let clear_window color =
  let fg = foreground in
  set_color color;
  fill_rect 0 0 (size_x ()) (size_y ());
  set_color fg

let break_mainloop = ref false
let angle = ref 0.

let draw_scene () =
  clear_window black;
  set_color white;
  draw_mesh triangle !angle;
  angle := !angle +. 0.075;
  let input = wait_next_event [ Poll ] in
  synchronize ();
  if input.button then break_mainloop := false else ()

let rec main_loop () =
  draw_scene ();
  if !break_mainloop then () else main_loop ()

let () =
  open_graph (" " ^ string_of_int viewportw ^ "x" ^ string_of_int viewporth);
  main_loop ()
