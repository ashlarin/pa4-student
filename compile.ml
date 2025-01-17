open Printf
open Expr
open Asm
open Typecheck

let rec find ls x =
  match ls with
  | [] -> None
  | (y,v)::rest ->
    if y = x then Some(v) else find rest x

let rec find_def p x =
  match p with
  | [] -> None
  | (DFun(name, args, ret, body) as d)::rest ->
    if name = x then Some(d) else find_def rest x

let stackloc si = RegOffset(-8 * si, RSP)

let true_const  = HexConst(0x0000000000000002L)
let false_const = HexConst(0x0000000000000000L)

let rec well_formed_e (e : expr) (env : (string * int) list) : string list =
  match e with
  | ENumber(_)
  | EBool(_) -> []
  (* TODO *)
  | EId(x) -> (match find env x with 
    | Some(i) -> []
    | None -> [sprintf "Variable identifier %s unbound" x])
  | ELet(def, body) -> (match env with 
                       | [] -> []
                       | (x, si) :: rest -> (match (check_duplicate def (si+1) env) with 
                                            | [(x, -10)] -> [sprintf "Multiple bindings for variable identifier %s" x]
                                            | newEnv -> (match body with
                                              | [] -> []
                                              | head::tail -> (well_formed_e head newEnv)@(check_body [] tail newEnv))))
  | EPrim1(op, arg) -> well_formed_e arg env
  | EPrim2(op, arg1, arg2) -> (well_formed_e arg1 env) @ (well_formed_e arg2 env)
  | EWhile(exp, exp_list) -> (well_formed_e exp env) @ (check_body [] exp_list env)
  | ESet(x, arg) -> (match find env x with 
    | Some(i) -> []
    | None -> [sprintf "Variable identifier %s unbound" x])
  | EIf(i, t, e) -> (well_formed_e i env)@(well_formed_e t env)@(well_formed_e e env)
  | EApp(v, exp) -> (check_body [] exp env)
and check_duplicate l si env = match l with 
  | [] -> env
  | (x, v) :: rest -> (match find env x with 
                      | None -> check_duplicate rest si ((x, si)::env)
                      | Some(i) -> if i = si then [(x, -10)] else check_duplicate rest si ((x, si)::env))
and check_body list exp env = match exp with 
  | [] -> list
  | head::tail -> check_body (list@(well_formed_e head env)) tail env

let rec well_formed_prog (defs, main) =
  (check_funs defs []) @ (well_formed_e main [("input", 1)])
and check_funs defs def_env = match defs with 
  | [] -> []
  | DFun(n, args, ret, body)::rest -> (match find_def def_env n with 
    | Some(_) -> ["Multiple functions"] @ check_funs rest def_env
    | None -> let parmdup = check_parms args [] in 
              if parmdup = [] 
              then check_funs rest (DFun(n, args, ret, body)::def_env)
              else parmdup @ check_funs rest (DFun(n, args, ret, body)::def_env))
and check_parms parms env = (match parms with 
  | [] -> []
  | (s, t)::rest -> (match find env s with 
    | Some(_) -> ["Multiple bindings"] @ check_parms rest env
    | None -> check_parms rest ((s, 0)::env)))


let check p : string list =
  match well_formed_prog p with
  | [] -> []
  | errs -> failwith (String.concat "\n" errs)

let rec compile_expr (e : expr) (si : int) (env : (string * int) list) def_env: instruction list =  match e with
  | EPrim1(op, e) -> compile_prim1 op e si env def_env
  | EPrim2(op, e1, e2) -> compile_prim2 op e1 e2 si env def_env
  | ENumber(i) -> [IMov(Reg(RAX), Const64(Int64.of_int ((2 * i)+1)))]
  | EBool(true) -> [IMov(Reg(RAX), true_const)]
  | EBool(false) -> [IMov(Reg(RAX), false_const)]
  | EId(x) -> (match find env x with
    | Some(i) -> [IMov(Reg(RAX), (stackloc i))]
    | None -> failwith (sprintf "Unbound variable identifier %s" x))
  | ELet(l, body) -> let (instr, envNew, i, def_env') = (List.fold_left bindings ([], env, si, def_env) l) in
                     let (instr', envNew', i', def_env') = (List.fold_left compile_bod ([], envNew, i, def_env) body) in 
                     instr @ instr' 
  | EIf(i, t, e) -> let cond = compile_expr i si env def_env in
                    let t_b = compile_expr t (si+1) env def_env in 
                    let e_b = compile_expr e (si+1) env def_env in
                    let elsebranch = gen_temp "else_branch" in 
                    let end_if = gen_temp "end_of_if" in 
                    cond
                    @ [ICmp(Reg(RAX), true_const)]
                    @ [IJne(elsebranch)]
                    @ t_b
                    @ [IJmp(end_if)]
                    @ [ILabel(elsebranch)]
                    @ e_b
                    @ [ILabel(end_if)]
  | ESet(x, e) -> let eval_e = compile_expr e si env def_env in
                  (match find env x with 
                  | None -> failwith (sprintf "Unbound variable identifier %s" x)
                  | Some(v) -> eval_e @ [IMov((stackloc v), Reg(RAX))])
  | EWhile(e, exps) -> let start_while = gen_temp "start_while" in 
                       let end_while = gen_temp "end_while" in 
                       let e_eval = compile_expr e si env def_env in
                       let (instr, envNew, si', def_env') = (List.fold_left compile_bod ([], env, si, def_env) exps) in 
                       [ILabel(start_while)]
                       @ e_eval
                       @ [ICmp(Reg(RAX), true_const)]
                       @ [IJne(end_while)]
                       @ instr
                       @ [IJmp(start_while)]
                       @ [ILabel(end_while)]
                       @ [IMov(Reg(RAX), false_const)]
  | EApp(name, exps) -> (match find_def def_env name with 
    | None -> failwith "Unbound"
    | Some(DFun(name, args, ret, body)) -> 
      let (instr', env', si', def_env') = (List.fold_left compile_appExps ([], env, si, def_env) exps) in
      let after_call = gen_temp "after_call" in
      let (move_instr, new_si, new_si') = (List.fold_left mov_args ([], si, (si'+2)) exps) in 
      instr' @ [IMov(Reg(RBX), Label(after_call))]
      @ [IMov((stackloc si') , Reg(RBX))]
      @ [IMov((stackloc (si'+1), Reg(RSP)))]
      @ move_instr 
      @ [ISub(Reg(RSP), Const((si'*8)))]
      @ [IJmp(name)]
      @ [ILabel(after_call)]
      @ [IMov(Reg(RSP), (stackloc 2))])
      @ [IMov((stackloc si), Reg(RAX))]
and compile_prim1 op e si env def_env = let args_expr = compile_expr e si env def_env in
  let expr = e in 
  match op with 
  | Add1 -> args_expr 
            @ [IAdd(Reg(RAX), Const(2))]
            @ [IJo("overflow")]
  | Sub1 -> args_expr 
            @ [ISub(Reg(RAX), Const(2))]
            @ [IJo("overflow")]
  | IsNum -> (match expr with 
    | ENumber(_) -> [IMov(Reg(RAX), true_const)]
    | _ -> [IMov(Reg(RAX), false_const)])
  | IsBool -> (match expr with 
    | EBool(_) -> [IMov(Reg(RAX), true_const)]
    | _ -> [IMov(Reg(RAX), false_const)])
  | Print -> let offset = if ((si mod 2) = 1) then (8*(si-1)) else (8*si) in
            args_expr
            @ [IMov(Reg(RDI), Reg(RAX))]
            @ [ISub(Reg(RSP), Const(offset))]
            @ [ICall("print")]
            @ [IAdd(Reg(RSP), Const(offset))]
and compile_prim2 op e1 e2 si env def_env = let args1 = compile_expr e1 si env def_env in 
  let args2 = compile_expr e2 (si+1) env def_env in 
  match op with 
  | Plus -> args1 @ [IMov((stackloc si), Reg(RAX))]
            @ args2 
            @ [ISar(Reg(RAX), Const(1))] @ [IShl(Reg(RAX), Const(1))]
            @ [IAdd(Reg(RAX), (stackloc (si)))]
            @ [IJo("overflow")]
  | Minus -> args1 @ [IMov((stackloc si), Reg(RAX))]
            @ args2 
            @ [ISar(Reg(RAX), Const(1))] @ [IShl(Reg(RAX), Const(1))]
            @ [IMov((stackloc (si+1)), Reg(RAX))]
            @ [IMov(Reg(RAX), (stackloc si))] 
            @ [ISub(Reg(RAX), (stackloc (si+1)))]
            @ [IJo("overflow")]
  | Times -> args1 @ [IMov((stackloc si), Reg(RAX))]
            @ args2  @ [ISar(Reg(RAX), Const(1))]
            @ [IMov((stackloc (si+1), Reg(RAX)))]
            @ [IMov(Reg(RAX), (stackloc si))] @ [ISub(Reg(RAX), Const(1))]             
            @ [IMul(Reg(RAX), (stackloc (si+1)))]
            @ [IJo("overflow")]
            @ [IAdd(Reg(RAX), Const(1))]
            @ [IJo("overflow")]
  | Less -> let true_branch = gen_temp "true_branch" in 
            let end_equals = gen_temp "end_equals" in 
            args1 @ [IMov((stackloc si), Reg(RAX))]
            @ args2 @ [IMov((stackloc (si+1)), Reg(RAX))]
            @ [IMov(Reg(RAX), (stackloc si))]
            @ [ICmp(Reg(RAX), (stackloc (si+1)))] 
            @ [IJl(true_branch)]
            @ [IMov(Reg(RAX), false_const)]
            @ [IJmp(end_equals)]
            @ [ILabel(true_branch)]
            @ [IMov(Reg(RAX), true_const)]
            @ [ILabel(end_equals)]
  | Greater -> let true_branch = gen_temp "true_branch" in 
            let end_equals = gen_temp "end_equals" in 
            args1 @ [IMov((stackloc si), Reg(RAX))]
            @ args2 @ [IMov((stackloc (si+1)), Reg(RAX))]
            @ [IMov(Reg(RAX), (stackloc si))]
            @ [ICmp(Reg(RAX), (stackloc (si+1)))] 
            @ [IJg(true_branch)]
            @ [IMov(Reg(RAX), false_const)]
            @ [IJmp(end_equals)]
            @ [ILabel(true_branch)]
            @ [IMov(Reg(RAX), true_const)]
            @ [ILabel(end_equals)]
  | Equal -> let false_branch = gen_temp "false_branch" in 
            let end_equals = gen_temp "end_equals" in 
            args1 @ [IMov((stackloc si), Reg(RAX))]
            @ args2 @ [IMov((stackloc (si+1)), Reg(RAX))]
            @ [IMov(Reg(RAX), (stackloc si))]
            @ [ICmp(Reg(RAX), (stackloc (si+1)))] 
            @ [IJne(false_branch)]
            @ [IMov(Reg(RAX), true_const)]
            @ [IJmp(end_equals)]
            @ [ILabel(false_branch)]
            @ [IMov(Reg(RAX), false_const)]
            @ [ILabel(end_equals)]
and compile_def (DFun(name, args, ret, body)) def_env =
  let (env, si) = List.fold_left compile_args ([], 2) args in  
  let (instr', env', si', def_env') = (List.fold_left compile_bod ([], env, si, def_env) body) in 
  [ILabel(name)]
  @ instr'
  @ [IRet]
and compile_args (env, si) args = match args with 
  | (s, _) -> ((s, si)::env, si+1)
and bindings (instr, env, si, def_env) l = match l with
                                  | (n, v) -> let value = compile_expr v si env def_env in 
                                              let store = [IMov((stackloc si), Reg(RAX))] in
                                              match find env n with 
                                                | None -> (instr @ value @ store, (n, si)::env, (si+1), def_env)
                                                | Some(i) -> if (i > si - (2 * List.length(instr))) 
                                                             then failwith "Duplicate binding" 
                                                             else (instr @ value @ store, (n, si)::env, (si+1), def_env)
and compile_bod (instr, env, si, def_env) l = (let cur = compile_expr l si env def_env in 
                                     (instr @ cur, env, (si+1), def_env))
and compile_appExps (instr, env, si, def_env) l = (let cur = compile_expr l si env def_env in 
                                     (instr @ cur @ [IMov(stackloc si, Reg(RAX))], env, (si+1), def_env))
and mov_args (move_instr, si, si') l = (move_instr @ [IMov(Reg(RAX), stackloc si)]
                                                           @ [IMov((stackloc si', Reg(RAX)))], (si+1), (si'+1))

let compile_to_string ((defs, main) as prog : Expr.prog) =
  let _ = check prog in
  let def_env = build_def_env defs in
  let _ = tc_p prog def_env in
  let compiled_defs = List.concat (List.map (fun d -> compile_def d defs) defs) in
  let compiled_main = compile_expr main 2 [("input", 1)] defs in
  let prelude = "  section .text\n" ^
                "  extern error\n" ^
                "  extern print\n" ^
                "  extern printPrint\n" ^
                "  global our_code_starts_here\n" in
  let kickoff = "our_code_starts_here:\n" ^
                "push rbx\n" ^
                "  mov [rsp - 8], rdi\n" ^ 
                to_asm compiled_main ^
                "\n  pop rbx\nret\n" in
  let postlude = [IRet] 
                @ [ILabel("expected_num")] 
                @ [IMov(Reg(RDI), Const(11))]
                @ [IPush(Const(0))]
                @ [ICall("error")]
                @ [ILabel("expected_bool")] 
                @ [IMov(Reg(RDI), Const(21))]
                @ [IPush(Const(0))]
                @ [ICall("error")]
                @ [ILabel("overflow")] 
                @ [IMov(Reg(RDI), Const(31))]
                @ [IPush(Const(0))]
                @ [ICall("error")] in
  let as_assembly_string = (to_asm (compiled_defs @ postlude)) in
  sprintf "%s%s\n%s\n" prelude as_assembly_string kickoff
