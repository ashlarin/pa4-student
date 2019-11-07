  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

func1:
  mov rax, [rsp -32]
  cmp rax, 0x2
  jne near temp_else_branch_61
  mov rax, [rsp -16]
  mov [rsp -48], rax
  mov rax, [rsp -16]
  mov [rsp -56], rax
  mov rax, [rsp -24]
  sar rax, 1
  mov [rsp -64], rax
  mov rax, [rsp -56]
  sub rax, 1
  imul rax, [rsp -64]
  jo near overflow
  add rax, 1
  jo near overflow
  mov [rsp -56], rax
  mov rbx, temp_after_call_59
  mov [rsp -64], rbx
  mov [rsp -72], rsp
  mov rax, [rsp -48]
  mov [rsp -80], rax
  mov rax, [rsp -56]
  mov [rsp -88], rax
  sub rsp, 64
  jmp near func2
temp_after_call_59:
  mov rsp, [rsp -16]
  mov [rsp -48], rax
  mov [rsp -16], rax
  jmp near temp_end_of_if_62
temp_else_branch_61:
  mov rax, [rsp -16]
  mov [rsp -48], rax
  mov rax, [rsp -16]
  mov [rsp -56], rax
  mov rax, [rsp -24]
  sar rax, 1
  shl rax, 1
  add rax, [rsp -56]
  jo near overflow
  mov [rsp -56], rax
  mov rbx, temp_after_call_60
  mov [rsp -64], rbx
  mov [rsp -72], rsp
  mov rax, [rsp -48]
  mov [rsp -80], rax
  mov rax, [rsp -56]
  mov [rsp -88], rax
  sub rsp, 64
  jmp near func2
temp_after_call_60:
  mov rsp, [rsp -16]
  mov [rsp -48], rax
  mov [rsp -16], rax
temp_end_of_if_62:
  ret
func2:
temp_start_while_63:
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, [rsp -24]
  mov [rsp -40], rax
  mov rax, 21
  sar rax, 1
  mov [rsp -48], rax
  mov rax, [rsp -40]
  sub rax, 1
  imul rax, [rsp -48]
  jo near overflow
  add rax, 1
  jo near overflow
  mov [rsp -40], rax
  mov rax, [rsp -32]
  cmp rax, [rsp -40]
  jl near temp_true_branch_65
  mov rax, 0
  jmp near temp_end_equals_66
temp_true_branch_65:
  mov rax, 0x2
temp_end_equals_66:
  cmp rax, 0x2
  jne near temp_end_while_64
  mov rax, 5
  mov [rsp -32], rax
  mov rax, [rsp -16]
  sar rax, 1
  mov [rsp -40], rax
  mov rax, [rsp -32]
  sub rax, 1
  imul rax, [rsp -40]
  jo near overflow
  add rax, 1
  jo near overflow
  mov [rsp -16], rax
  mov rax, [rsp -16]
  mov rdi, rax
  sub rsp, 32
  call print
  add rsp, 32
  jmp near temp_start_while_63
temp_end_while_64:
  mov rax, 0
  mov rax, [rsp -16]
  mov [rsp -40], rax
  mov rbx, temp_after_call_67
  mov [rsp -48], rbx
  mov [rsp -56], rsp
  mov rax, [rsp -40]
  mov [rsp -64], rax
  sub rsp, 48
  jmp near func3
temp_after_call_67:
  mov rsp, [rsp -16]
  mov [rsp -40], rax
  mov [rsp -40], rax
  mov rax, [rsp -24]
  mov [rsp -48], rax
  mov rax, [rsp -40]
  cmp rax, [rsp -48]
  jl near temp_true_branch_68
  mov rax, 0
  jmp near temp_end_equals_69
temp_true_branch_68:
  mov rax, 0x2
temp_end_equals_69:
  cmp rax, 0x2
  jne near temp_else_branch_70
  mov rax, [rsp -24]
  jmp near temp_end_of_if_71
temp_else_branch_70:
  mov rax, [rsp -16]
temp_end_of_if_71:
  ret
func3:
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 3
  sar rax, 1
  shl rax, 1
  mov [rsp -32], rax
  mov rax, [rsp -24]
  sub rax, [rsp -32]
  jo near overflow
  mov [rsp -16], rax
  ret
  ret
expected_num:
  mov rdi, 11
  push 0
  call error
expected_bool:
  mov rdi, 21
  push 0
  call error
overflow:
  mov rdi, 31
  push 0
  call error
our_code_starts_here:
push rbx
  mov [rsp - 8], rdi

  mov rax, 7
  mov [rsp -16], rax
  mov rax, 15
  mov [rsp -24], rax
  mov rax, 0x2
  mov [rsp -32], rax
  mov rbx, temp_after_call_72
  mov [rsp -40], rbx
  mov [rsp -48], rsp
  mov rax, [rsp -16]
  mov [rsp -56], rax
  mov rax, [rsp -24]
  mov [rsp -64], rax
  mov rax, [rsp -32]
  mov [rsp -72], rax
  sub rsp, 40
  jmp near func1
temp_after_call_72:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  pop rbx
ret

