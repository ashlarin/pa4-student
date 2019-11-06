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

  mov rax, 21
  mov [rsp -16], rax
  mov rax, 1
  mov [rsp -24], rax
temp_start_while_3:
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, [rsp -24]
  mov [rsp -40], rax
  mov rax, [rsp -32]
  cmp rax, [rsp -40]
  jg near temp_true_branch_5
  mov rax, 0
  jmp near temp_end_equals_6
temp_true_branch_5:
  mov rax, 0x2
temp_end_equals_6:
  cmp rax, 0x2
  jne near temp_end_while_4
  mov rax, [rsp -24]
  mov [rsp -32], rax
  mov rax, 3
  sar rax, 1
  shl rax, 1
  add rax, [rsp -32]
  jo near overflow
  mov [rsp -24], rax
  jmp near temp_start_while_3
temp_end_while_4:
  mov rax, 0
  mov rax, [rsp -24]
  pop rbx
ret

