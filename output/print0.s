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
  mov rax, 19
  mov [rsp -24], rax
  mov rax, [rsp -24]
  sar rax, 1
  shl rax, 1
  add rax, [rsp -16]
  jo near overflow
  mov rdi, rax
  sub rsp, 16
  call print
  add rsp, 16
  pop rbx
ret

