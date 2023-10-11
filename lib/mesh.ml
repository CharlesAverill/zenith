open Math.Vector

type mesh = vec list * (int * int) list

let print_mesh mesh =
  let vertices, edges = mesh in
  Printf.printf "Vertices:\n";
  List.iteri (fun i v -> Printf.printf "%d: %s\n" i (string_of_vec v)) vertices;
  Printf.printf "\nEdges:\n";
  List.iter (fun (a, b) -> Printf.printf "(%d, %d)\n" a b) edges

let map_verts mesh f = (List.map f (fst mesh), snd mesh)

let triangle =
  ([ v3 0.5 0. 0.; v3 1. 0. 0.; v3 1. 1. 0. ], [ (0, 1); (1, 2); (2, 0) ])

let square =
  ( [ v3 0. 0. 0.; v3 0. 1. 0.; v3 1. 0. 0.; v3 1. 1. 0. ],
    [ (0, 1); (0, 2); (3, 1); (3, 2) ] )

let cube =
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
      (0, 1);
      (0, 2);
      (0, 4);
      (1, 3);
      (1, 5);
      (2, 3);
      (2, 6);
      (3, 7);
      (4, 5);
      (4, 6);
      (5, 7);
      (6, 7);
    ] )

let pyramid =
  ( [ v3 0. 0. 0.; v3 1. 0. 0.; v3 1. 0. 1.; v3 0. 0. 1.; v3 0.5 1. 0.5 ],
    [ (0, 1); (1, 2); (2, 3); (3, 0); (0, 4); (1, 4); (2, 4); (3, 4) ] )
