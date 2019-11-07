  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

remainder:
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, [rsp -24]
  sar rax, 1
  shl rax, 1
  mov [rsp -40], rax
  mov rax, [rsp -32]
  sub rax, [rsp -40]
  jo near overflow
  mov [rsp -32], rax
  mov rax, 3
  mov [rsp -40], rax
  mov rax, [rsp -32]
  cmp rax, [rsp -40]
  jl near temp_true_branch_36
  mov rax, 0
  jmp near temp_end_equals_37
temp_true_branch_36:
  mov rax, 0x2
temp_end_equals_37:
  cmp rax, 0x2
  jne near temp_else_branch_43
  mov rax, [rsp -16]
  mov [rsp -40], rax
  mov rax, [rsp -24]
  mov [rsp -48], rax
  mov rax, [rsp -40]
  cmp rax, [rsp -48]
  jne near temp_false_branch_38
  mov rax, 0x2
  jmp near temp_end_equals_39
temp_false_branch_38:
  mov rax, 0
temp_end_equals_39:
  cmp rax, 0x2
  jne near temp_else_branch_40
  mov rax, 1
  jmp near temp_end_of_if_41
temp_else_branch_40:
  mov rax, [rsp -16]
temp_end_of_if_41:
  jmp near temp_end_of_if_44
temp_else_branch_43:
  mov rax, [rsp -16]
  mov [rsp -40], rax
  mov rax, [rsp -24]
  sar rax, 1
  shl rax, 1
  mov [rsp -48], rax
  mov rax, [rsp -40]
  sub rax, [rsp -48]
  jo near overflow
  mov [rsp -40], rax
  mov rax, [rsp -24]
  mov [rsp -48], rax
  mov rbx, temp_after_call_42
  mov [rsp -56], rbx
  mov [rsp -64], rsp
  mov rax, [rsp -40]
  mov [rsp -72], rax
  mov rax, [rsp -48]
  mov [rsp -80], rax
  sub rsp, 56
  jmp near remainder
temp_after_call_42:
  mov rsp, [rsp -16]
  mov [rsp -40], rax
temp_end_of_if_44:
  ret
isprime:
  mov rax, 5
  mov [rsp -24], rax
temp_start_while_45:
  mov rax, [rsp -24]
  mov [rsp -32], rax
  mov rax, [rsp -16]
  mov [rsp -40], rax
  mov rax, [rsp -32]
  cmp rax, [rsp -40]
  jl near temp_true_branch_47
  mov rax, 0
  jmp near temp_end_equals_48
temp_true_branch_47:
  mov rax, 0x2
temp_end_equals_48:
  cmp rax, 0x2
  jne near temp_end_while_46
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, [rsp -24]
  mov [rsp -40], rax
  mov rbx, temp_after_call_49
  mov [rsp -48], rbx
  mov [rsp -56], rsp
  mov rax, [rsp -32]
  mov [rsp -64], rax
  mov rax, [rsp -40]
  mov [rsp -72], rax
  sub rsp, 48
  jmp near remainder
temp_after_call_49:
  mov rsp, [rsp -16]
  mov [rsp -32], rax
  mov [rsp -32], rax
  mov rax, 1
  mov [rsp -40], rax
  mov rax, [rsp -32]
  cmp rax, [rsp -40]
  jne near temp_false_branch_50
  mov rax, 0x2
  jmp near temp_end_equals_51
temp_false_branch_50:
  mov rax, 0
temp_end_equals_51:
  cmp rax, 0x2
  jne near temp_else_branch_52
  mov rax, 199999999
  mov [rsp -24], rax
  jmp near temp_end_of_if_53
temp_else_branch_52:
  mov rax, [rsp -24]
  mov [rsp -40], rax
  mov rax, 3
  sar rax, 1
  shl rax, 1
  add rax, [rsp -40]
  jo near overflow
  mov [rsp -24], rax
temp_end_of_if_53:
  jmp near temp_start_while_45
temp_end_while_46:
  mov rax, 0
  mov rax, [rsp -24]
  mov [rsp -40], rax
  mov rax, 199999999
  mov [rsp -48], rax
  mov rax, [rsp -40]
  cmp rax, [rsp -48]
  jne near temp_false_branch_54
  mov rax, 0x2
  jmp near temp_end_equals_55
temp_false_branch_54:
  mov rax, 0
temp_end_equals_55:
  cmp rax, 0x2
  jne near temp_else_branch_56
  mov rax, 0
  jmp near temp_end_of_if_57
temp_else_branch_56:
  mov rax, 0x2
temp_end_of_if_57:
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
  mov rbx, temp_after_call_58
  mov [rsp -24], rbx
  mov [rsp -32], rsp
  mov rax, [rsp -16]
  mov [rsp -40], rax
  sub rsp, 24
  jmp near isprime
temp_after_call_58:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  pop rbx
ret

