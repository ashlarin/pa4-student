  section .text
  extern error
  extern print
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

  mov rax, 11
  mov [rsp -16], rax
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 15
  mov [rsp -32], rax
  mov rax, [rsp -24]
  cmp rax, [rsp -32]
  jne near temp_false_branch_1
  mov rax, 0x2
  jmp near temp_end_equals_2
temp_false_branch_1:
  mov rax, 0
temp_end_equals_2:
  cmp rax, 0x2
  jne near temp_else_branch_3
  mov rax, 15
  jmp near temp_end_of_if_4
temp_else_branch_3:
  mov rax, 17
temp_end_of_if_4:
  pop rbx
ret

