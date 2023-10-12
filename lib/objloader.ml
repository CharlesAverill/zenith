open Graphics
open Mesh
open Math.Vector
open Logging

type vernacular =
  | Vertex of vec
  | Edge of ((int * int) * color option)
  | MaterialFilename of string
  | UseMaterial of string

type material = { name : string; color : color }

let pairs_of_consecutive_elements lst =
  let rec aux first = function
    | [] -> []
    | [ x ] ->
        [ (x, first) ]
        (* Empty list or a list with only one element cannot form pairs. *)
    | x :: y :: rest -> (x, y) :: aux first (y :: rest)
  in
  match lst with [] | [ _ ] -> [] | h :: _ :: _ -> aux h lst

let parse_obj_line line current_mtl : vernacular list option =
  match String.split_on_char ' ' line with
  | "v" :: xs ->
      let v = List.map float_of_string xs in
      Some [ Vertex (v3 (List.nth v 0) (List.nth v 1) (List.nth v 2)) ]
  | "l" :: xs ->
      let parsed_edge = List.map (fun s -> int_of_string s - 1) xs in
      Some
        [
          Edge
            ( (List.nth parsed_edge 0, List.nth parsed_edge 1),
              Some current_mtl.color );
        ]
  | "f" :: xs ->
      let vertices =
        List.map
          (fun s ->
            int_of_string
              (if String.contains s '/' then String.sub s 0 (String.index s '/')
               else s)
            - 1)
          xs
      in
      let edges = pairs_of_consecutive_elements vertices in
      Some (List.map (fun x -> Edge (x, Some current_mtl.color)) edges)
  | [ "mtllib"; name ] -> Some [ MaterialFilename name ]
  | [ "usemtl"; name ] -> Some [ UseMaterial name ]
  | _ -> None

let scan_file filename =
  let lines = ref [] in
  try
    let chan = open_in filename in
    try
      while true do
        lines := input_line chan :: !lines
      done;
      !lines
    with End_of_file ->
      close_in chan;
      List.rev !lines
  with
  | Sys_error s when String.ends_with ~suffix:"No such file or directory" s ->
    []

let parse_mtls obj_fn mtl_fn : material list =
  let lines = scan_file (Filename.concat (Filename.dirname obj_fn) mtl_fn) in
  let found_materials : material list ref = ref [] in
  let _ =
    List.fold_left
      (fun (name, color) line ->
        if name != None && color != None then
          match (name, color) with
          | Some n, Some c ->
              found_materials := { name = n; color = c } :: !found_materials;
              (None, None)
          | _ -> failwith "This never happens"
        else
          match String.split_on_char ' ' line with
          | "newmtl" :: n -> (Some (String.concat " " n), color)
          | [ "Kd"; r; g; b ] ->
              let kd_to_comp kd = int_of_float (float_of_string kd *. 255.) in
              (name, Some (rgb (kd_to_comp r) (kd_to_comp g) (kd_to_comp b)))
          | _ -> (name, color))
      (None, None) lines
  in
  if List.length lines != 0 && List.length !found_materials = 0 then
    fatal rc_MaterialError
      ("Material file " ^ mtl_fn
     ^ " did not contain both a material name and diffuse color")
  else !found_materials

let get_material l name obj_fn =
  match
    List.fold_left
      (fun s i ->
        if s != None then s else if i.name = name then Some i else None)
      None l
  with
  | Some m -> m
  | _ ->
      fatal rc_MaterialError
        ("Object file " ^ obj_fn ^ " tried to use material \"" ^ name
       ^ "\" that has not been declared yet")

let rec parse_obj_lines obj_fn lines (materials : material list) current_mtl
    vertices edges =
  match lines with
  | [] -> (List.rev vertices, edges)
  | line :: rest -> (
      match parse_obj_line line current_mtl with
      | Some [ Vertex v ] ->
          parse_obj_lines obj_fn rest materials current_mtl (v :: vertices)
            edges
      | Some [ Edge e ] ->
          parse_obj_lines obj_fn rest materials current_mtl vertices (e :: edges)
      | Some (Edge e :: t) ->
          parse_obj_lines obj_fn rest materials current_mtl vertices
            (List.map
               (fun x -> match x with Edge _e -> _e | _ -> edge 0 0)
               (Edge e :: t)
            @ edges)
      | Some [ MaterialFilename mtl_fn ] ->
          parse_obj_lines obj_fn rest
            (parse_mtls obj_fn mtl_fn @ materials)
            current_mtl vertices edges
      | Some [ UseMaterial mtl_name ] ->
          parse_obj_lines obj_fn rest materials
            (get_material materials mtl_name obj_fn)
            vertices edges
      | _ -> parse_obj_lines obj_fn rest materials current_mtl vertices edges)

let load_obj obj_fn : mesh =
  let obj_lines = scan_file obj_fn in
  parse_obj_lines obj_fn obj_lines []
    { name = "Default"; color = Config.edge_color }
    [] []
