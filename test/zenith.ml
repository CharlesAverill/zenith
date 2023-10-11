open Zenith.Matrix

(* Functions to test *)
module To_test = struct
  let transpose = transpose
end

let test_transpose mat mat' =
  Alcotest.(check bool) "same bool" true (To_test.transpose mat = mat')

let test_transpose_1x1 () =
  test_transpose
    { arr = [| 99. |]; dim = (1, 1) }
    { arr = [| 99. |]; dim = (1, 1) }

let test_transpose_2x2 () =
  test_transpose
    { arr = [| 78.; -5.; 0.; -0.1 |]; dim = (2, 2) }
    { arr = [| 78.; 0.; -5.; -0.1 |]; dim = (2, 2) }

let test_transpose_4x4 () =
  test_transpose
    {
      arr =
        [|
          1.; 2.; 3.; 4.; 5.; 6.; 7.; 8.; 9.; 10.; 11.; 12.; 13.; 14.; 15.; 16.;
        |];
      dim = (4, 4);
    }
    {
      arr =
        [|
          1.; 5.; 9.; 13.; 2.; 6.; 10.; 14.; 3.; 7.; 11.; 15.; 4.; 8.; 12.; 16.;
        |];
      dim = (4, 4);
    }

(* Run tests *)
let () =
  let open Alcotest in
  run "Tests"
    [
      ( "Transpose",
        [
          test_case "1x1" `Quick test_transpose_1x1;
          test_case "2x2" `Quick test_transpose_2x2;
          test_case "4x4" `Quick test_transpose_4x4;
        ] );
    ]
