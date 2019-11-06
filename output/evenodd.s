  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

even:
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 1
  mov [rsp -32], rax
  mov rax, [rsp -24]
  cmp rax, [rsp -32]
  jne near temp_false_branch_22
  mov rax, 0x2
  jmp near temp_end_equals_23
temp_false_branch_22:
  mov rax, 0
temp_end_equals_23:
  cmp rax, 0x2
  jne near temp_else_branch_25
  mov rax, 0x2
  jmp near temp_end_of_if_26
temp_else_branch_25:
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, 3
  mov [rsp -40], rax
  mov rax, [rsp -40]
  sar rax, 1
  shl rax, 1
  mov [rsp -40], rax
  mov rax, [rsp -32]
  sub rax, [rsp -40]
  jo near overflow
  mov [rsp -32], rax
  mov rbx, temp_after_call_24
  mov [rsp -40], rbx
  mov [rsp -48], rsp
  mov rax, [rsp -32]
  mov [rsp -56], rax
  sub rsp, 24
  jmp near odd
temp_after_call_24:
  mov rsp, [rsp -16]
temp_end_of_if_26:
  ret
odd:
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 1
  mov [rsp -32], rax
  mov rax, [rsp -24]
  cmp rax, [rsp -32]
  jne near temp_false_branch_27
  mov rax, 0x2
  jmp near temp_end_equals_28
temp_false_branch_27:
  mov rax, 0
temp_end_equals_28:
  cmp rax, 0x2
  jne near temp_else_branch_30
  mov rax, 0
  jmp near temp_end_of_if_31
temp_else_branch_30:
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, 3
  mov [rsp -40], rax
  mov rax, [rsp -40]
  sar rax, 1
  shl rax, 1
  mov [rsp -40], rax
  mov rax, [rsp -32]
  sub rax, [rsp -40]
  jo near overflow
  mov [rsp -32], rax
  mov rbx, temp_after_call_29
  mov [rsp -40], rbx
  mov [rsp -48], rsp
  mov rax, [rsp -32]
  mov [rsp -56], rax
  sub rsp, 24
  jmp near even
temp_after_call_29:
  mov rsp, [rsp -16]
temp_end_of_if_31:
  ret
test:
  mov rax, 61
  mov [rsp -16], rax
  mov rbx, temp_after_call_32
  mov [rsp -24], rbx
  mov [rsp -32], rsp
  mov rax, [rsp -16]
  mov [rsp -40], rax
  sub rsp, 24
  jmp near even
temp_after_call_32:
  mov rsp, [rsp -16]
  mov rax, 63
  mov [rsp -24], rax
  mov rbx, temp_after_call_33
  mov [rsp -32], rbx
  mov [rsp -40], rsp
  mov rax, [rsp -24]
  mov [rsp -48], rax
  sub rsp, 24
  jmp near odd
temp_after_call_33:
  mov rsp, [rsp -16]
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

  mov rbx, temp_after_call_34
  mov [rsp -16], rbx
  mov [rsp -24], rsp
  sub rsp, 16
  jmp near test
temp_after_call_34:
  mov rsp, [rsp -16]
  pop rbx
ret

