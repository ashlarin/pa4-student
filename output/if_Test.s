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

  mov rax, 0x2
  cmp rax, 0x2
  jne near temp_else_branch_1
  mov rax, 11
  jmp near temp_end_of_if_2
temp_else_branch_1:
  mov rax, 13
temp_end_of_if_2:
  pop rbx
ret

