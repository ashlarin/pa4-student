  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

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

  mov rax, -5
  mov [rsp -16], rax
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 1
  mov [rsp -32], rax
  mov rax, [rsp -24]
  cmp rax, [rsp -32]
  jl near temp_true_branch_9
  mov rax, 0
  jmp near temp_end_equals_10
temp_true_branch_9:
  mov rax, 0x2
temp_end_equals_10:
  cmp rax, 0x2
  jne near temp_else_branch_11
  mov rax, -1
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
  jmp near temp_end_of_if_12
temp_else_branch_11:
  mov rax, [rsp -16]
temp_end_of_if_12:
  pop rbx
ret

