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

  mov rax, 11
  mov [rsp -16], rax
  mov rax, 9
  mov [rsp -24], rax
  mov rax, [rsp -16]
  cmp rax, [rsp -24]
  jl near temp_true_branch_9
  mov rax, 0
  jmp near temp_end_equals_10
temp_true_branch_9:
  mov rax, 0x2
temp_end_equals_10:
  pop rbx
ret

