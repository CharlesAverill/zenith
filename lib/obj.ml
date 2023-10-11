open Mesh
open Vector

type vernacular = Vertex of vec | Edge of (int * int)

let parse_obj_line line : vernacular option =
  match String.split_on_char ' ' line with
  | [] -> None
  | [ "#" ] -> None (* Comment line *)
  | "v" :: xs ->
      let v = List.map float_of_string xs in
      Some (Vertex (v3 (List.nth v 0) (List.nth v 1) (List.nth v 2)))
  | "l" :: xs ->
      let edge = List.map (fun s -> int_of_string s - 1) xs in
      Some (Edge (List.nth edge 0, List.nth edge 1))
  | _ -> None

let rec parse_obj_lines lines vertices edges =
  match lines with
  | [] -> (vertices, edges)
  | line :: rest -> (
      match parse_obj_line line with
      | Some (Vertex v) -> parse_obj_lines rest (v :: vertices) edges
      | Some (Edge e) -> parse_obj_lines rest vertices (e :: edges)
      | None -> parse_obj_lines rest vertices edges)

let parse_obj_file filename =
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true do
      lines := input_line chan :: !lines
    done;
    !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines

let load_obj filename : mesh =
  let lines = parse_obj_file filename in
  let vertices, edges = parse_obj_lines lines [] [] in
  let out = (List.rev vertices, List.rev edges) in
  (* print_mesh out; *)
  out
