  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

test:
  mov rax, 3
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

  mov rax, 0x2
  mov [rsp -16], rax
  mov rbx, temp_after_call_15
  mov [rsp -24], rbx
  mov [rsp -32], rsp
  mov rax, [rsp -16]
  mov [rsp -40], rax
  sub rsp, 24
  jmp near test
temp_after_call_15:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  pop rbx
ret

