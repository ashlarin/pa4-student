open Sexplib.Sexp
module Sexp = Sexplib.Sexp
open Expr

let boa_max = int_of_float(2.**62.) - 1;;
let boa_min = -int_of_float(2.**62.);;
let valid_id_regex = Str.regexp "[a-zA-Z][a-zA-Z0-9]*"
let number_regex = Str.regexp "^[+-]?[0-9]+"
let reserved_words = ["let"; "add1"; "sub1"; "isNum"; "isBool"; "if"; "set"; "while"; "def"; "print"]
let reserved_constants = ["true"; "false"; ]
let int_of_string_opt s =
  try Some(int_of_string s) with
  | _ -> None

let rec parse sexp = match sexp with
  | Atom(s) -> (if (Str.string_match number_regex s 0)
                then (match int_of_string_opt s with
                  | Some(n) -> ENumber(n)
                  | None -> failwith "Non-representable number")
                else (if (Str.string_match valid_id_regex s 0) 
                      then (if check_const s reserved_constants 
                            then EBool((string_toBool s reserved_constants))
                            else (if check_reserved s reserved_words then failwith "Invalid" else EId(s))) 
                      else failwith "Invalid id"))
  | sexps -> match sexps with
    | List([Atom("add1"); arg]) -> EPrim1(Add1, parse arg)
    | List([Atom("sub1"); arg]) -> EPrim1(Sub1, parse arg)
    | List([Atom("isNum"); arg]) -> EPrim1(IsNum, parse arg)
    | List([Atom("isBool"); arg]) -> EPrim1(IsBool, parse arg)
    | List([Atom("print"); arg]) -> EPrim1(Print, parse arg)
    | List([Atom("+"); arg1; arg2]) -> EPrim2(Plus, parse arg1, parse arg2)
    | List([Atom("-"); arg1; arg2]) -> EPrim2(Minus, parse arg1, parse arg2)
    | List([Atom("*"); arg1; arg2]) -> EPrim2(Times, parse arg1, parse arg2)
    | List([Atom("<"); arg1; arg2]) -> EPrim2(Less, parse arg1, parse arg2)
    | List([Atom(">"); arg1; arg2]) -> EPrim2(Greater, parse arg1, parse arg2)
    | List([Atom("=="); arg1; arg2]) -> EPrim2(Equal, parse arg1, parse arg2)
    | List([Atom("if"); arg1; arg2; arg3]) -> EIf(parse arg1, parse arg2, parse arg3)
    | List([Atom("set"); Atom(s); arg1]) -> ESet(s, parse arg1)
    | List(a) -> (match a with
      | Atom("let")::List(e1)::rest -> (let binds = List.map parse_binding e1 in 
                                        let bod = List.map parse rest in 
                                        ELet(binds, bod))
      | Atom("while")::arg1::rest -> EWhile(parse arg1, List.map parse rest)
      | Atom(s)::rest -> EApp(s, List.map parse rest)
      | _ -> failwith "Invalid" )
and parse_binding binding = match binding with 
  | List([Atom(name); arg]) -> if (check_reserved name reserved_words) then failwith "Invalid" else (name, parse arg)
  | _ -> failwith "Invalid"
and check_reserved name list = match list with 
  | [] -> false
  | head::tail -> if (name = head) then true else (check_reserved name tail)
and check_const name list = match list with 
  | [] -> false
  | head::tail -> if (name = head) then true else (check_const name tail)
and string_toBool name list = match list with
  | head::tail -> if (head = name) then true else false
  | _ -> failwith "boolean creation messed up"

let rec parse_def sexp = match sexp with 
  | List(a) -> (match a with 
    | Atom("def")::Atom(s)::List(parm)::Atom(":")::Atom(ret)::rest -> let parm' = parse_type parm [] in
                                                                     let ret' = check_type ret in 
                                                                     if rest = [] 
                                                                     then failwith "Invalid"
                                                                     else let exp' = List.map parse rest in 
                                                                     DFun(s, parm', ret', exp')
    | _ -> failwith "Invalid")
  | _ -> failwith "Invalid"
and parse_type parm l = match parm with 
  | Atom(s)::Atom(":")::Atom(t)::rest -> parse_type rest [(s, check_type t)]@l
  | [] -> l
  | _ -> failwith "Invalid"
and check_type t = if t = "Num" then TNum else 
                  (if t = "Bool" then TBool else failwith "Invalid")

let rec parse_program sexps =
  match sexps with
  | [] -> failwith "Invalid: Empty program"
  | [e] -> ([], parse e)
  | e::es ->
     let parse_e = (parse_def e) in
     let defs, main = parse_program es in
     parse_e::defs, main
