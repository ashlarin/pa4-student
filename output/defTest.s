  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

abs_val:
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 1
  mov [rsp -32], rax
  mov rax, [rsp -24]
  cmp rax, [rsp -32]
  jl near temp_true_branch_7
  mov rax, 0
  jmp near temp_end_equals_8
temp_true_branch_7:
  mov rax, 0x2
temp_end_equals_8:
  cmp rax, 0x2
  jne near temp_else_branch_9
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
  jmp near temp_end_of_if_10
temp_else_branch_9:
  mov rax, [rsp -16]
temp_end_of_if_10:
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

  mov rax, -5
  mov [rsp -16], rax
  mov rbx, temp_after_call_11
  mov [rsp -24], rbx
  mov [rsp -32], rsp
  mov rax, [rsp -16]
  mov [rsp -40], rax
  sub rsp, 24
  jmp near abs_val
temp_after_call_11:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  pop rbx
ret

