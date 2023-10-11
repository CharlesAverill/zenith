type vec = { x : float; y : float; z : float; w : float }

let v3 x y z = { x; y; z; w = 1. }
let zvec = { x = 0.; y = 0.; z = 0.; w = 0. }
let vec_length vec = (vec.x *. vec.x) +. (vec.y *. vec.y) +. (vec.z *. vec.z)

let vec_unit vec =
  let len = vec_length vec in
  { x = vec.x /. len; y = vec.y /. len; z = vec.z /. len; w = vec.w /. len }

let vec_dot a b = (a.x *. b.x) +. (a.y *. b.y) +. (a.z *. b.z) +. (a.w *. b.w)
let vec_div v n = { x = v.x /. n; y = v.y /. n; z = v.y /. n; w = v.w }

let v3_add v1 v2 =
  { x = v1.x +. v2.x; y = v1.y +. v2.y; z = v1.z +. v2.z; w = v1.w }

let v3_sub v1 v2 =
  { x = v1.x -. v2.x; y = v1.y -. v2.y; z = v1.z -. v2.z; w = v1.w }

let min_vec a b = v3 (min a.x b.x) (min a.y b.y) (min a.z b.z)
let max_vec a b = v3 (max a.x b.x) (max a.y b.y) (max a.z b.z)

let string_of_vec vec =
  Printf.sprintf "<%f, %f, %f, %f>" vec.x vec.y vec.z vec.w
