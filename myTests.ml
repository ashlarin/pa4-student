open Runner
open Expr
open Printf
open OUnit2

(* Fill in `myTestList` with your own tests. There are two ways to add a test:
 *
 * (1) By adding the code of the program as a string. In this case, add an entry
 *     of this form in `myTestList`:
 *
 *     t <test_name> <program_code> <result>
 *
 * (2) By adding a test inside the 'input/' folder and adding an entry for it
 *     in `myTestList`. The entry in this case should be:
 *
 *     t_file <test_name> <file_name> <result>
 *     
 *     Where name is the name of the file inside 'input/' with the extension
 *     ".ana". For example:
 *
 *     t_file "myTest" "mytest.ana" "6";
 *)

let t_i name program expected args = name>::test_run program name expected args
let t name program expected = name>::test_run program name expected []
let terr_i name program expected args = name>::test_err program name expected args
let t_err name program expected = name>::test_err program name expected []
let t_parse name program expected =
  name>::(fun _ -> assert_equal expected (Runner.parse_string program));;

let myTestList =
  [ 
    t_parse "ENum" "5" (ENumber(5));
    t_parse "EId" "x" (EId("x"));
    t_parse "EBoolT" "true" (EBool(true));
    t_parse "EBoolF" "false" (EBool(false));
    t_parse "add1" "(add1 5)" (EPrim1(Add1, ENumber(5)));
    t_parse "sub1" "(sub1 5)" (EPrim1(Sub1, ENumber(5)));
    t_parse "plus" "(+ 1 2)" (EPrim2(Plus, ENumber(1), ENumber(2)));
    t_parse "minus" "(- 3 4)" (EPrim2(Minus, ENumber(3), ENumber(4)));
    t_parse "times" "(* 5 6)" (EPrim2(Times, ENumber(5), ENumber(6)));
    t_parse "plus&times" "(+ 1 (* 2 4))" (EPrim2(Plus, ENumber(1), (EPrim2(Times, ENumber(2), ENumber(4)))));
    t_parse "let0" "(let ((x 5)) x)" (ELet([("x",ENumber(5))], [EId("x")]));
    t_parse "letx" "(let ((x 5)) (add1 x))" (ELet([("x", ENumber(5))], [EPrim1(Add1, EId("x"))]));
    t_parse "letxy" "(let ((x 10) (y 7)) (* (- x y) 2))" (ELet([("x", ENumber(10)); ("y", ENumber(7))], [EPrim2(Times, EPrim2(Minus, EId("x"), EId("y")), ENumber(2))]));
    t_parse "letxyz" "(let ((x 8) (y 7) (z 9)) (* (- x y) 2))" (ELet([("x", ENumber(8)); ("y", ENumber(7)); ("z", ENumber(9))], [EPrim2(Times, EPrim2(Minus, EId("x"), EId("y")), ENumber(2))]));
    t_parse "letxyza" "(let ((x 8) (y 7) (z 9) (a 1)) (* (- x y) 2))" (ELet([("x", ENumber(8)); ("y", ENumber(7)); ("z", ENumber(9)); ("a", ENumber(1))], [EPrim2(Times, EPrim2(Minus, EId("x"), EId("y")), ENumber(2))]));  
    t_parse "letxy*" "(let ((x 10) (y 7)) (* x y))" (ELet([("x", ENumber(10)); ("y", ENumber(7))], [EPrim2(Times, EId("x"), EId("y"))]));    
    t_parse "<parse" "(< 1 2)" (EPrim2(Less, ENumber(1), ENumber(2)));
    t_parse "letbodies" "(let ((x 5)) 1 2 3)"  (ELet([("x",ENumber(5))], [ENumber(1); ENumber(2); ENumber(3)]));
    t_parse "while" "(while (> 2 x) (+ x 3))" (EWhile(EPrim2(Greater, ENumber(2), EId("x")), [EPrim2(Plus, EId("x"), ENumber(3))]));
    t "subtest" "(- 10 3)" "7";
    t "multest" "(* 2 4)" "8";
    t "ITE" "(if true 3 4)" "3";
    t "lessT" "(< 3 4)" "true";
    t "lessF" "(< 5 4)" "false";
    t "greatT" "(> 6 5)" "true";
    t "greatF" "(> 1 5)" "false";
    t_err "letdup" "(let ((x 1) (x 2)) x)" "Multiple bindings for variable identifier x";
    t_err "unbound" "(let ((x 5)) (add1 y))" "Variable identifier y unbound";  
    t "print" "(print 5)" "5\n5";
    t "print0" "(print (+ 5 9))" "14\n14";
    t "lettest" "(let ((x -3)) (if (< x 0) (* -1 x) x))" "3";
    t "print1" "(print (let ((x (let ((x 5)) (sub1 x)))) (sub1 x)))" "3\n3";
    t "param1Num" "(def test (x : Num) : Num 1) (test 1)" "1";
    t "param2Num" "(def test (x : Num y : Num) : Num 1) (test 1 2)" "1";
    t "param3Num" "(def test (x : Num y : Num z : Num) : Num 1) (test 1 2 3)" "1";
    t "param4Num" "(def test (x : Num y : Num z : Num a : Num) : Num 1) (test 1 2 3 4)" "1";
    t "param1Bool" "(def test (x : Bool) : Num 1) (test true)" "1";
    t "param2Bool" "(def test (x : Bool y : Bool) : Num 1) (test true true)" "1";
    t "param3Bool" "(def test (x : Bool y : Bool z : Bool) : Num 1) (test true false true)" "1";
    t "param4Bool" "(def test (x : Bool y : Bool z : Bool a : Bool) : Num 1) (test false true false true)" "1";
    t "param1Mix" "(def test (x : Num) : Bool true) (test 1)" "true";
    t "param2Mix" "(def test (x : Num y : Bool) : Num 1) (test 1 true)" "1";
    t "param3Mix" "(def test (x : Num y : Bool z : Num) : Bool true) (test 1 true 2)" "true";
    t "param2Mix2" "(def test (x : Bool y : Num) : Num 1) (test true 1)" "1";
    t "fib" "(def fibonacci (n : Num) : Num (if (< n 2) 1 (+ (fibonacci (- n 1)) (fibonacci (- n 2))))) (fibonacci 3)" "3";
    t "remainder0" "(def remainder (x : Num y : Num) : Num (if (< (- x y) 1) (if (== x y) 0 x) (remainder (- x y) y))) (remainder 13 2)" "1";
    t "remainder1" "(def remainder (x : Num y : Num) : Num (if (< (- x y) 1) (if (== x y) 0 x) (remainder (- x y) y))) (remainder 24 4)" "0";
    t "prime" "(def remainder (x : Num y : Num) : Num (if (< (- x y) 1) (if (== x y) 0 x) (remainder (- x y) y))) (def isprime (y : Num) : Bool (let ((n 2)) (while (< n y) (if (== (remainder y n) 0) (set n 99999999) (set n (+ n 1)))) (if (== n 99999999) false true))) (isprime 3)" "true";
    t "deepstack3" "(def func3 (n1 : Num) : Num (set n1 (- n1 1))) (func3 10)" "9";
    t "deepstack2" "(def func2 (n1 : Num n2 : Num) : Num (while (< n1 (* n2 10)) (set n1 (* 2 n1)) (print n1)) (if (< (func3 n1) n2) n2 n1)) (def func3 (n1 : Num) : Num (set n1 (- n1 1))) (func2 3 7)" "6\n12\n24\n48\n96\n96";
    t "deepstack1" "(def func1 (n1 : Num n2 : Num b1 : Bool ) : Num (if b1 (set n1 (func2 n1 (* n1 n2))) (set n1 (func2 n1 (+ n1 n2))))) (def func2 (n1 : Num n2 : Num) : Num (while (< n1 (* n2 10)) (set n1 (* 2 n1)) (print n1)) (if (< (func3 n1) n2) n2 n1)) (def func3 (n1 : Num) : Num (set n1 (- n1 1))) (func1 3 7 true)" "6\n12\n24\n48\n96\n192\n384\n384";
    t "evenodd" "(def even (n : Num) : Bool (if (== n 0) true (odd (- n 1)))) (def odd (n : Num) : Bool (if (== n 0) false (even (- n 1)))) (def test() : Bool (print (even 30)) (print (odd 30)) (print (even 57)) (print (odd 57))) (test)" "true\nfalse\nfalse\ntrue\ntrue";
  ]
;;

(*    t_parse "def" "(def zero (n : Num) : Bool (if (== n 0) true false))" (DFun("zero", [("n", TNum)], TBool, [EIf(EPrim2(Equal, EId("n"), ENumber(0), EBool(true), EBool(false)))])); *)
