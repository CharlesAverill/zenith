open Logging
open Vector

type matrix = { arr : float array; dim : int * int }

let get_matrix n m = { arr = Array.make (n * m) 0.0; dim = (n, m) }
let xdim m = fst m.dim
let ydim m = snd m.dim
let xy_to_i m x y = (x * xdim m) + y
let get mat n m = Array.get mat.arr (xy_to_i mat n m)
let set mat n m x = Array.set mat.arr (xy_to_i mat n m) x

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

let matmul a b =
  if xdim a != ydim a || a.dim != b.dim then
    fatal rc_OOB "Can only matmul square matrices of identical shape";
  let dim = xdim a in
  let dest = id_matrix dim dim in
  for y = 0 to dim - 1 do
    let col = y * dim in
    for x = 0 to dim - 1 do
      for i = 0 to dim - 1 do
        Array.set dest.arr (col + x)
          (Array.get b.arr (i + col) *. Array.get a.arr (x + (i * 4)))
      done
    done
  done;
  dest

let vecmatmul v m =
  let arr = Array.get m.arr in
  {
    x = vec_dot v { x = arr 0; y = arr 4; z = arr 8; w = arr 12 };
    y = vec_dot v { x = arr 1; y = arr 5; z = arr 9; w = arr 13 };
    z = vec_dot v { x = arr 2; y = arr 6; z = arr 10; w = arr 14 };
    w = vec_dot v { x = arr 3; y = arr 7; z = arr 11; w = arr 15 };
  }

let clip_matrix fov aspect_ratio near far =
  let out = id_matrix 4 4 in
  let f = 1. /. Float.tan (fov *. 0.5) in
  set out 0 0 (f *. aspect_ratio);
  set out 1 1 f;
  set out 2 2 ((far +. near) /. (far -. near));
  set out 2 3 1.;
  set out 3 2 (2. *. near *. far /. (near -. far));
  set out 3 3 0.;
  out
