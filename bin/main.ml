open Argparse
open Driver

let () =
  let args = Argparse.parse_arguments () in
  start args.obj_meshes
