open Math.Matrix
open Math.Vector

(* Functions to test *)
module To_test = struct
  let transpose = transpose
  let vecmatmul = vecmatmul
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

let test_vecmatmul vec mat vec' =
  Alcotest.(check bool) "same bool" true (To_test.vecmatmul vec mat = vec')

let test_vecmatmul_4x4 () =
  test_vecmatmul
    { x = 27.; y = 19.; z = 48.; w = 16.5 }
    {
      arr =
        [|
          1.;
          2.;
          3.;
          4.;
          5.;
          9.;
          749.;
          23.;
          58.;
          23.;
          90.;
          22.5;
          0.;
          7.;
          16.5;
          53.;
        |];
      dim = (4, 4);
    }
    { x = 275.; y = 36637.5; z = 6694.25; w = 1799.5 }

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
      ( "Vector-Matrix Product",
        [ test_case "4x4 * 4x1" `Quick test_vecmatmul_4x4 ] );
    ]
