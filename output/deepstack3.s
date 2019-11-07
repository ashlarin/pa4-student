  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

func3:
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 3
  sar rax, 1
  shl rax, 1
  mov [rsp -32], rax
  mov rax, [rsp -24]
  sub rax, [rsp -32]
  jo near overflow
  mov [rsp -16], rax
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

  mov rax, 21
  mov [rsp -16], rax
  mov rbx, temp_after_call_34
  mov [rsp -24], rbx
  mov [rsp -32], rsp
  mov rax, [rsp -16]
  mov [rsp -40], rax
  sub rsp, 24
  jmp near func3
temp_after_call_34:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  pop rbx
ret

