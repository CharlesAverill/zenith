open Logging
open Vector

type matrix = { arr : float array; dim : int * int }

let get_matrix n m = { arr = Array.make (n * m) 0.0; dim = (n, m) }
let xdim m = fst m.dim
let ydim m = snd m.dim
let xy_to_i m x y = (x * xdim m) + y
let get mat n m = Array.get mat.arr (xy_to_i mat n m)
let set mat n m x = Array.set mat.arr (xy_to_i mat n m) x
let string_of_dim dim = Printf.sprintf "(%dx%d)" (fst dim) (snd dim)
let dim_eq a b = fst a = fst b && snd a = snd b

let id_matrix n m =
  let mat = get_matrix n m in
  List.fold_left
    (fun _ i -> if i < n && i < m then set mat i i 1. else ())
    ()
    (List.init (max n m) (fun x -> x));
  mat

let print_matrix mat =
  print_string "[";
  for x = 0 to xdim mat - 1 do
    if x != 0 then print_string " ";
    print_string "[";
    for y = 0 to ydim mat - 1 do
      print_float (get mat x y);
      print_string ";";
      if y + 1 != ydim mat then print_string " "
    done;
    print_string "]";
    if x + 1 != xdim mat then print_endline ""
  done;
  print_endline "]"

let transpose mat =
  let n, m = mat.dim in
  let transposed = get_matrix m n in
  for i = 0 to n - 1 do
    for j = 0 to m - 1 do
      set transposed j i (get mat i j)
    done
  done;
  transposed

let matmul a b =
  if not (dim_eq a.dim b.dim) then
    fatal rc_OOB
      (Printf.sprintf
         "Can only matmul square matrices of identical shape, got %s and %s"
         (string_of_dim a.dim) (string_of_dim b.dim));

  let rows_a = xdim a in
  let cols_a = ydim a in
  let cols_b = ydim b in

  let result = get_matrix rows_a cols_b in

  for i = 0 to rows_a - 1 do
    for j = 0 to cols_b - 1 do
      let dot_product = ref 0.0 in
      for k = 0 to cols_a - 1 do
        dot_product := !dot_product +. (get a i k *. get b k j)
      done;
      set result i j !dot_product
    done
  done;

  result

let vecmatmul v m =
  let arr = Array.get m.arr in
  {
    x = vec_dot v { x = arr 0; y = arr 1; z = arr 2; w = arr 3 };
    y = vec_dot v { x = arr 4; y = arr 5; z = arr 6; w = arr 7 };
    z = vec_dot v { x = arr 8; y = arr 9; z = arr 10; w = arr 11 };
    w = vec_dot v { x = arr 12; y = arr 13; z = arr 14; w = arr 15 };
  }
