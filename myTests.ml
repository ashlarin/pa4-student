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
  ]
;;

(*    t_parse "def" "(def zero (n : Num) : Bool (if (== n 0) true false))" (DFun("zero", [("n", TNum)], TBool, [EIf(EPrim2(Equal, EId("n"), ENumber(0), EBool(true), EBool(false)))])); *)
