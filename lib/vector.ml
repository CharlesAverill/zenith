type vec = { x : float; y : float; z : float; w : float }

let v3 x y z = { x; y; z; w = 0. }
let zvec = { x = 0.; y = 0.; z = 0.; w = 1. }
let vec_length vec = (vec.x *. vec.x) +. (vec.y *. vec.y) +. (vec.z *. vec.z)

let vec_unit vec =
  let len = vec_length vec in
  { x = vec.x /. len; y = vec.y /. len; z = vec.z /. len; w = vec.w /. len }

let vec_dot a b = (a.x *. b.x) +. (a.y *. b.y) +. (a.z *. b.z) +. (a.w *. b.w)
let vec_div v n = { x = v.x /. n; y = v.y /. n; z = v.y /. n; w = v.w }
