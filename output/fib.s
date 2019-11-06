  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

fibonacci:
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 5
  mov [rsp -32], rax
  mov rax, [rsp -24]
  cmp rax, [rsp -32]
  jl near temp_true_branch_19
  mov rax, 0
  jmp near temp_end_equals_20
temp_true_branch_19:
  mov rax, 0x2
temp_end_equals_20:
  cmp rax, 0x2
  jne near temp_else_branch_23
  mov rax, 3
  jmp near temp_end_of_if_24
temp_else_branch_23:
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, 3
  sar rax, 1
  shl rax, 1
  mov [rsp -40], rax
  mov rax, [rsp -32]
  sub rax, [rsp -40]
  jo near overflow
  mov [rsp -32], rax
  mov rbx, temp_after_call_21
  mov [rsp -40], rbx
  mov [rsp -48], rsp
  mov rax, [rsp -32]
  mov [rsp -56], rax
  sub rsp, 40
  jmp near fibonacci
temp_after_call_21:
  mov rsp, [rsp -16]
  mov [rsp -32], rax
  mov [rsp -32], rax
  mov rax, [rsp -16]
  mov [rsp -40], rax
  mov rax, 5
  sar rax, 1
  shl rax, 1
  mov [rsp -48], rax
  mov rax, [rsp -40]
  sub rax, [rsp -48]
  jo near overflow
  mov [rsp -40], rax
  mov rbx, temp_after_call_22
  mov [rsp -48], rbx
  mov [rsp -56], rsp
  mov rax, [rsp -40]
  mov [rsp -64], rax
  sub rsp, 48
  jmp near fibonacci
temp_after_call_22:
  mov rsp, [rsp -16]
  mov [rsp -40], rax
  sar rax, 1
  shl rax, 1
  add rax, [rsp -32]
  jo near overflow
temp_end_of_if_24:
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
  mov rbx, temp_after_call_25
  mov [rsp -24], rbx
  mov [rsp -32], rsp
  mov rax, [rsp -16]
  mov [rsp -40], rax
  sub rsp, 24
  jmp near fibonacci
temp_after_call_25:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  pop rbx
ret

