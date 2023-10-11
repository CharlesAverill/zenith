open Zenith.Mesh
open Zenith.Objloader

type arguments = { obj_meshes : mesh list }

let copies l n =
  if n <= 0 then []
  else List.concat (List.map (fun x -> List.init n (fun _ -> x)) l)

let parse_arguments () =
  let obj_files = ref [] in
  let objs = ref [ cube ] in
  let num_each = ref 1 in

  let speclist =
    [
      ( "-n",
        Arg.Int (fun n -> num_each := n),
        "How many of each object to render" );
    ]
  in
  let usage_msg = "Usage: zenith [OBJ]+" in

  Arg.parse speclist (fun n -> obj_files := n :: !obj_files) usage_msg;

  if !obj_files != [] then objs := List.map load_obj !obj_files;

  if !num_each != 1 then objs := copies !objs !num_each;

  { obj_meshes = !objs }
