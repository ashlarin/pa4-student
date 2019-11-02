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
  and rax, 1
  cmp rax, 0
  je near expected_num
  mov rax, [rsp -24]
  sub rax, 2
  jo near overflow
  pop rbx
ret

