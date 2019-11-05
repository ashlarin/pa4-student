open Expr
open Printf

let rec find ls x =
  match ls with
  | [] -> None
  | (y,v)::rest ->
    if y = x then Some(v) else find rest x

type def_env = (string * (typ list * typ)) list

let build_def_env (defs : def list) : def_env =
  let get_typ (DFun(name, args, ret_typ, body)) = (name, ((List.map snd args), ret_typ)) in
  List.map get_typ defs

let rec tc_e (e : expr) (env : (string * typ) list) (def_env : def_env) : typ =
  match e with
  | ENumber(_) -> TNum
  | EBool(_) -> TBool
  | EId(x) -> (match find env x with 
    | Some(v) -> v
    | None -> failwith (sprintf "Variable identifier %s unbound" x))
  | EIf(i, t, e) -> (let type_i = tc_e i env def_env in 
                     let type_t = tc_e t env def_env in 
                     let type_e = tc_e e env def_env in 
                     match type_i with 
                     | TNum -> failwith "Type mismatch"
                     | TBool -> (match type_t, type_e with 
                       | TNum, TNum -> TNum
                       | TBool, TBool -> TBool
                       | _, _ -> failwith "Type mismatch"))
  | EPrim1(op, e1) -> (match op with 
                      | Add1 -> (match tc_e e1 env def_env with
                        | TNum -> TNum
                        | TBool -> failwith "Type mismatch")
                      | Sub1 -> (match tc_e e1 env def_env with
                        | TNum -> TNum
                        | TBool -> failwith "Type mismatch")
                      | IsBool -> (match tc_e e1 env def_env with
                        | TNum -> TNum
                        | TBool -> TBool)
                      | IsNum -> (match tc_e e1 env def_env with
                        | TNum -> TNum
                        | TBool -> TBool)
                      | Print -> (match tc_e e1 env def_env with
                        | TNum -> TNum
                        | TBool -> TBool))
  | EPrim2(op, e1, e2) -> (let type1 = tc_e e1 env def_env in 
                           let type2 = tc_e e2 env def_env in 
                           match op with 
                           | Plus -> if (type1 = TNum && type2 = TNum) then TNum else failwith "Type mismatch"
                           | Minus -> if (type1 = TNum && type2 = TNum) then TNum else failwith "Type mismatch"
                           | Times -> if (type1 = TNum && type2 = TNum) then TNum else failwith "Type mismatch"
                           | Less -> if (type1 = TNum && type2 = TNum) then TBool else failwith "Type mismatch"
                           | Greater -> if (type1 = TNum && type2 = TNum) then TBool else failwith "Type mismatch"
                           | Equal -> if (type1 = TNum && type2 = TNum) then TBool else failwith "Type mismatch")
  | ESet(x, e) -> (match find env x with 
    | None -> failwith "Unbound"
    | Some(v) -> let type_e = tc_e e env def_env in 
                 if type_e = v then v else failwith "Type mismatch")
  | EWhile(e, exps) -> (match tc_e e env def_env with 
    | TNum -> failwith "Type mismatch"
    | TBool -> check_while_bod exps env def_env)
  | ELet(v, b) -> let (newEnv, def_env') = (List.fold_left type_letbinds (env, def_env) v) in 
                  let type_b = check_seq TNum b newEnv def_env in 
                  type_b
  | EApp(v, exp) -> (match find def_env v with 
    | None -> failwith "Unbound"
    | Some(args, ret) -> if (List.length args = List.length exp) 
                         then check_parms_args exp args ret env def_env
                         else failwith "Type mismatch")
and check_while_bod exp env def_env = match exp with 
  | [] -> TBool
  | head::tail -> (match tc_e head env def_env with
    | TNum -> check_while_bod tail env def_env
    | TBool -> check_while_bod tail env def_env)
and check_seq prev list env def_env = match list with 
  | [] -> prev 
  | head::tail -> let h = tc_e head env def_env in 
                  (match h with 
                  | TNum -> check_seq h tail env def_env
                  | TBool -> check_seq h tail env def_env)
and type_letbinds (newEnv, def_env) l = match l with 
  | (x, v) -> let type_v = tc_e v newEnv def_env in 
              ((x,type_v)::newEnv, def_env)
and check_parms_args exp args ret env def_env = match (exp, args) with 
  | [], [] -> ret
  | (h::t), (h'::t') -> let h_type = tc_e h env def_env in 
                        if (h_type = h') 
                        then check_parms_args t t' ret env def_env
                        else failwith "Type mismatch tt"
  | _,_ -> failwith "Type mismatch"
    
let rec tc_def def_env (DFun(name, args, ret_typ, body)) = 
  let bod_type = check_bod args def_env body in 
  if (bod_type = ret_typ) then ret_typ else failwith "Type mismatch"
and check_bod env def_env bods = match bods with
  | head::[] -> tc_e head env def_env 
  | head::tail -> check_bod env def_env tail 

let tc_p (defs, main) def_env : typ =
  begin ignore (List.map (tc_def def_env) defs); tc_e main [("input", TNum)] def_env end