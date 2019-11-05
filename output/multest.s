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

  mov rax, 5
  mov [rsp -16], rax
  mov rax, 9
  mov [rsp -24], rax
  mov rax, [rsp -24]
  sar rax, 1
  mov [rsp -24], rax
  mov rax, [rsp -16]
  sub rax, 1
  imul rax, [rsp -24]
  jo near overflow
  add rax, 1
  jo near overflow
  pop rbx
ret

