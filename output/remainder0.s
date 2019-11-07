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
  jl near temp_true_branch_24
  mov rax, 0
  jmp near temp_end_equals_25
temp_true_branch_24:
  mov rax, 0x2
temp_end_equals_25:
  cmp rax, 0x2
  jne near temp_else_branch_31
  mov rax, [rsp -16]
  mov [rsp -40], rax
  mov rax, [rsp -24]
  mov [rsp -48], rax
  mov rax, [rsp -40]
  cmp rax, [rsp -48]
  jne near temp_false_branch_26
  mov rax, 0x2
  jmp near temp_end_equals_27
temp_false_branch_26:
  mov rax, 0
temp_end_equals_27:
  cmp rax, 0x2
  jne near temp_else_branch_28
  mov rax, 1
  jmp near temp_end_of_if_29
temp_else_branch_28:
  mov rax, [rsp -16]
temp_end_of_if_29:
  jmp near temp_end_of_if_32
temp_else_branch_31:
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
  mov rbx, temp_after_call_30
  mov [rsp -56], rbx
  mov [rsp -64], rsp
  mov rax, [rsp -40]
  mov [rsp -72], rax
  mov rax, [rsp -48]
  mov [rsp -80], rax
  sub rsp, 56
  jmp near remainder
temp_after_call_30:
  mov rsp, [rsp -16]
  mov [rsp -40], rax
temp_end_of_if_32:
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

  mov rax, 27
  mov [rsp -16], rax
  mov rax, 5
  mov [rsp -24], rax
  mov rbx, temp_after_call_33
  mov [rsp -32], rbx
  mov [rsp -40], rsp
  mov rax, [rsp -16]
  mov [rsp -48], rax
  mov rax, [rsp -24]
  mov [rsp -56], rax
  sub rsp, 32
  jmp near remainder
temp_after_call_33:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  pop rbx
ret

