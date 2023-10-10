open Graphics
open Zenith.Mesh
open Zenith.Render
open List

let clear_window color =
  let fg = foreground in
  set_color color;
  fill_rect 0 0 (size_x ()) (size_y ());
  set_color fg

let break_mainloop = ref false

let draw_scene () =
  clear_window black;
  set_color white;
  draw_meshes (project_clip_meshes (size_x ()) (size_y ()) 0. 10. [ cube ]);
  let input = wait_next_event [ Mouse_motion; Button_down ] in
  synchronize ();
  if input.button then break_mainloop := true else ()

let rec main_loop () =
  draw_scene ();
  if !break_mainloop then () else main_loop ()

let () =
  open_graph " 800x600";
  main_loop ()
