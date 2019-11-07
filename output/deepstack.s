  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

func1:
  mov rax, [rsp -32]
  cmp rax, 0x2
  jne near temp_else_branch_41
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
  mov rbx, temp_after_call_39
  mov [rsp -64], rbx
  mov [rsp -72], rsp
  mov rax, [rsp -48]
  mov [rsp -80], rax
  mov rax, [rsp -56]
  mov [rsp -88], rax
  sub rsp, 64
  jmp near func2
temp_after_call_39:
  mov rsp, [rsp -16]
  mov [rsp -48], rax
  mov [rsp -16], rax
  jmp near temp_end_of_if_42
temp_else_branch_41:
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
  mov rbx, temp_after_call_40
  mov [rsp -64], rbx
  mov [rsp -72], rsp
  mov rax, [rsp -48]
  mov [rsp -80], rax
  mov rax, [rsp -56]
  mov [rsp -88], rax
  sub rsp, 64
  jmp near func2
temp_after_call_40:
  mov rsp, [rsp -16]
  mov [rsp -48], rax
  mov [rsp -16], rax
temp_end_of_if_42:
  mov rax, [rsp -16]
  mov [rsp -48], rax
  mov rax, [rsp -24]
  mov [rsp -56], rax
  mov rax, [rsp -48]
  cmp rax, [rsp -56]
  jl near temp_true_branch_43
  mov rax, 0
  jmp near temp_end_equals_44
temp_true_branch_43:
  mov rax, 0x2
temp_end_equals_44:
  cmp rax, 0x2
  jne near temp_else_branch_45
  mov rax, 0x2
  jmp near temp_end_of_if_46
temp_else_branch_45:
  mov rax, 0
temp_end_of_if_46:
  ret
func2:
temp_start_while_47:
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, [rsp -24]
  mov [rsp -40], rax
  mov rax, [rsp -32]
  cmp rax, [rsp -40]
  jl near temp_true_branch_49
  mov rax, 0
  jmp near temp_end_equals_50
temp_true_branch_49:
  mov rax, 0x2
temp_end_equals_50:
  cmp rax, 0x2
  jne near temp_end_while_48
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
  jmp near temp_start_while_47
temp_end_while_48:
  mov rax, 0
  mov rax, [rsp -16]
  mov [rsp -40], rax
  mov rbx, temp_after_call_51
  mov [rsp -48], rbx
  mov [rsp -56], rsp
  mov rax, [rsp -40]
  mov [rsp -64], rax
  sub rsp, 48
  jmp near func3
temp_after_call_51:
  mov rsp, [rsp -16]
  mov [rsp -40], rax
  mov [rsp -40], rax
  mov rax, [rsp -24]
  mov [rsp -48], rax
  mov rax, [rsp -40]
  cmp rax, [rsp -48]
  jl near temp_true_branch_52
  mov rax, 0
  jmp near temp_end_equals_53
temp_true_branch_52:
  mov rax, 0x2
temp_end_equals_53:
  cmp rax, 0x2
  jne near temp_else_branch_54
  mov rax, [rsp -24]
  jmp near temp_end_of_if_55
temp_else_branch_54:
  mov rax, [rsp -16]
temp_end_of_if_55:
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

  mov rax, 9
  mov [rsp -16], rax
  mov rax, 13
  mov [rsp -24], rax
  mov rax, 0x2
  mov [rsp -32], rax
  mov rbx, temp_after_call_56
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
temp_after_call_56:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  pop rbx
ret

