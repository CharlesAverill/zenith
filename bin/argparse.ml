open Zenith.Mesh
open Zenith.Objloader

type arguments = { obj_mesh : mesh }

let parse_arguments () =
  let obj_file = ref "" in
  let obj = ref cube in

  let speclist =
    [ ("-obj", Arg.String (fun s -> obj_file := s), "An .OBJ file to render") ]
  in

  let usage_msg = "Usage: zenith [OBJ]" in

  Arg.parse speclist (fun _ -> ()) usage_msg;

  if !obj_file != "" then obj := load_obj !obj_file;

  { obj_mesh = !obj }
