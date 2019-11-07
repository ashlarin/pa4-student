  section .text
  extern error
  extern print
  extern printPrint
  global our_code_starts_here

even:
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 1
  mov [rsp -32], rax
  mov rax, [rsp -24]
  cmp rax, [rsp -32]
  jne near temp_false_branch_45
  mov rax, 0x2
  jmp near temp_end_equals_46
temp_false_branch_45:
  mov rax, 0
temp_end_equals_46:
  cmp rax, 0x2
  jne near temp_else_branch_48
  mov rax, 0x2
  jmp near temp_end_of_if_49
temp_else_branch_48:
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, 3
  sar rax, 1
  shl rax, 1
  mov [rsp -40], rax
  mov rax, [rsp -32]
  sub rax, [rsp -40]
  jo near overflow
  mov [rsp -32], rax
  mov rbx, temp_after_call_47
  mov [rsp -40], rbx
  mov [rsp -48], rsp
  mov rax, [rsp -32]
  mov [rsp -56], rax
  sub rsp, 40
  jmp near odd
temp_after_call_47:
  mov rsp, [rsp -16]
  mov [rsp -32], rax
temp_end_of_if_49:
  ret
odd:
  mov rax, [rsp -16]
  mov [rsp -24], rax
  mov rax, 1
  mov [rsp -32], rax
  mov rax, [rsp -24]
  cmp rax, [rsp -32]
  jne near temp_false_branch_50
  mov rax, 0x2
  jmp near temp_end_equals_51
temp_false_branch_50:
  mov rax, 0
temp_end_equals_51:
  cmp rax, 0x2
  jne near temp_else_branch_53
  mov rax, 0
  jmp near temp_end_of_if_54
temp_else_branch_53:
  mov rax, [rsp -16]
  mov [rsp -32], rax
  mov rax, 3
  sar rax, 1
  shl rax, 1
  mov [rsp -40], rax
  mov rax, [rsp -32]
  sub rax, [rsp -40]
  jo near overflow
  mov [rsp -32], rax
  mov rbx, temp_after_call_52
  mov [rsp -40], rbx
  mov [rsp -48], rsp
  mov rax, [rsp -32]
  mov [rsp -56], rax
  sub rsp, 40
  jmp near even
temp_after_call_52:
  mov rsp, [rsp -16]
  mov [rsp -32], rax
temp_end_of_if_54:
  ret
test:
  mov rax, 61
  mov [rsp -16], rax
  mov rbx, temp_after_call_55
  mov [rsp -24], rbx
  mov [rsp -32], rsp
  mov rax, [rsp -16]
  mov [rsp -40], rax
  sub rsp, 24
  jmp near even
temp_after_call_55:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  mov rdi, rax
  sub rsp, 16
  call print
  add rsp, 16
  mov rax, 61
  mov [rsp -24], rax
  mov rbx, temp_after_call_56
  mov [rsp -32], rbx
  mov [rsp -40], rsp
  mov rax, [rsp -24]
  mov [rsp -48], rax
  sub rsp, 32
  jmp near odd
temp_after_call_56:
  mov rsp, [rsp -16]
  mov [rsp -24], rax
  mov rdi, rax
  sub rsp, 16
  call print
  add rsp, 16
  mov rax, 115
  mov [rsp -32], rax
  mov rbx, temp_after_call_57
  mov [rsp -40], rbx
  mov [rsp -48], rsp
  mov rax, [rsp -32]
  mov [rsp -56], rax
  sub rsp, 40
  jmp near even
temp_after_call_57:
  mov rsp, [rsp -16]
  mov [rsp -32], rax
  mov rdi, rax
  sub rsp, 32
  call print
  add rsp, 32
  mov rax, 115
  mov [rsp -40], rax
  mov rbx, temp_after_call_58
  mov [rsp -48], rbx
  mov [rsp -56], rsp
  mov rax, [rsp -40]
  mov [rsp -64], rax
  sub rsp, 48
  jmp near odd
temp_after_call_58:
  mov rsp, [rsp -16]
  mov [rsp -40], rax
  mov rdi, rax
  sub rsp, 32
  call print
  add rsp, 32
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

  mov rbx, temp_after_call_59
  mov [rsp -16], rbx
  mov [rsp -24], rsp
  sub rsp, 16
  jmp near test
temp_after_call_59:
  mov rsp, [rsp -16]
  mov [rsp -16], rax
  pop rbx
ret

