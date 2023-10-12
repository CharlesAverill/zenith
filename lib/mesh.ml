open Graphics
open Math.Vector

(* Vertices, edges, edge colors *)
type mesh = vec list * ((int * int) * color option) list

let print_mesh (mesh : mesh) =
  let vertices, edges = mesh in
  Printf.printf "Vertices:\n";
  List.iteri (fun i v -> Printf.printf "%d: %s\n" i (string_of_vec v)) vertices;
  Printf.printf "\nEdges:\n";
  List.iter
    (fun ((a, b), c) ->
      Printf.printf "(%d, %d) Color: %s\n" a b
        (match c with None -> "None" | Some x -> string_of_int x))
    edges

let map_verts (mesh : mesh) (f : vec -> vec) : mesh =
  let verts, edges = mesh in
  (List.map f verts, edges)

let edge a b = ((a, b), None)

let triangle : mesh =
  ([ v3 0.5 0. 0.; v3 1. 0. 0.; v3 1. 1. 0. ], [ edge 0 1; edge 1 2; edge 2 0 ])

let square : mesh =
  ( [ v3 0. 0. 0.; v3 0. 1. 0.; v3 1. 0. 0.; v3 1. 1. 0. ],
    [ edge 0 1; edge 0 2; edge 3 1; edge 3 2 ] )

let cube : mesh =
  ( [
      v3 0. 0. 0.;
      v3 0. 0. 1.;
      v3 0. 1. 0.;
      v3 0. 1. 1.;
      v3 1. 0. 0.;
      v3 1. 0. 1.;
      v3 1. 1. 0.;
      v3 1. 1. 1.;
    ],
    [
      edge 0 1;
      edge 0 2;
      edge 0 4;
      edge 1 3;
      edge 1 5;
      edge 2 3;
      edge 2 6;
      edge 3 7;
      edge 4 5;
      edge 4 6;
      edge 5 7;
      edge 6 7;
    ] )

let pyramid : mesh =
  ( [ v3 0. 0. 0.; v3 1. 0. 0.; v3 1. 0. 1.; v3 0. 0. 1.; v3 0.5 1. 0.5 ],
    [
      edge 0 1;
      edge 1 2;
      edge 2 3;
      edge 3 0;
      edge 0 4;
      edge 1 4;
      edge 2 4;
      edge 3 4;
    ] )

let filter_duplicates meshes =
  let rec aux acc seen = function
    | [] -> List.rev acc
    | mesh :: rest ->
        if List.exists (fun m -> m = mesh) seen then aux acc seen rest
        else aux (mesh :: acc) (mesh :: seen) rest
  in
  aux [] [] meshes

let largest_distance (meshes : mesh list) =
  let max_distance =
    List.fold_left
      (fun acc (verts, _) ->
        List.fold_left
          (fun acc_vert_i vert_i ->
            List.fold_left
              (fun acc_vert_j vert_j ->
                let dist = v3_sub vert_i vert_j in
                let max_dist = max (max dist.x dist.y) dist.z in
                max acc_vert_j max_dist)
              acc_vert_i verts)
          acc verts)
      0.0 (filter_duplicates meshes)
  in

  max_distance
