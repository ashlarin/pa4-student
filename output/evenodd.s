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
  jne near temp_false_branch_16
  mov rax, 0x2
  jmp near temp_end_equals_17
temp_false_branch_16:
  mov rax, 0
temp_end_equals_17:
  cmp rax, 0x2
  jne near temp_else_branch_19
  mov rax, 0x2
  jmp near temp_end_of_if_20
temp_else_branch_19:
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
  mov rbx, temp_after_call_18
  mov [rsp -40], rbx
  mov [rsp -48], rsp
  mov rax, [rsp -32]
  mov [rsp -56], rax
  sub rsp, 24
  jmp near odd
temp_after_call_18:
  mov rsp, [rsp -16]
temp_end_of_if_20:
  ret
odd:
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 1
  mov [rsp -32], rax
  mov rax, [rsp -24]
  cmp rax, [rsp -32]
  jne near temp_false_branch_21
  mov rax, 0x2
  jmp near temp_end_equals_22
temp_false_branch_21:
  mov rax, 0
temp_end_equals_22:
  cmp rax, 0x2
  jne near temp_else_branch_24
  mov rax, 0
  jmp near temp_end_of_if_25
temp_else_branch_24:
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
  mov rbx, temp_after_call_23
  mov [rsp -40], rbx
  mov [rsp -48], rsp
  mov rax, [rsp -32]
  mov [rsp -56], rax
  sub rsp, 24
  jmp near even
temp_after_call_23:
  mov rsp, [rsp -16]
temp_end_of_if_25:
  ret
test:
  mov rax, 61
  mov [rsp -16], rax
  mov rbx, temp_after_call_26
  mov [rsp -24], rbx
  mov [rsp -32], rsp
  mov rax, [rsp -16]
  mov [rsp -40], rax
  sub rsp, 24
  jmp near even
temp_after_call_26:
  mov rsp, [rsp -16]
  mov rax, 63
  mov [rsp -24], rax
  mov rbx, temp_after_call_27
  mov [rsp -32], rbx
  mov [rsp -40], rsp
  mov rax, [rsp -24]
  mov [rsp -48], rax
  sub rsp, 24
  jmp near odd
temp_after_call_27:
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

  mov rbx, temp_after_call_28
  mov [rsp -16], rbx
  mov [rsp -24], rsp
  sub rsp, 16
  jmp near test
temp_after_call_28:
  mov rsp, [rsp -16]
  pop rbx
ret

