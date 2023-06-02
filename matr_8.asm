; change the max elements of each rows with side diagonal

%define write 1
%define stdout 1
%define exit 60

section .data
  matr dq 1,2,3,4,5,6,7
       dq 1,2,3,4,5,6,7
       dq 1,2,3,4,5,6,7
       dq 1,2,3,4,5,6,7
       dq 1,2,3,4,5,6,7
       dq 1,2,3,4,5,6,7
       dq 1,2,3,4,5,6,7

  space dq " ", 10
  space_len equ $- space

section .bss
  max resq 1
  temp resq 1

section .text
  global _start

  _start:
      mov r9, 48                                    ; side diagonal value
      mov rbx, -56                                  ; column value
      mov r8, 0                                     ; value that takes max element


    before_iter:
      mov rbp, 0                                    ; row value
      add rbx, 56                                   ; changes rows

    iteration:
      inc rbp 
      mov rcx, [matr + rbp * 8 + rbx - 8]           
      mov rax, [matr + rbp * 8 + rbx] 
      cmp rax, rcx                                  ; compares two values like matr[1] > matr[0]
      jge change_max
      jl change_not

      iter_cycle:
        cmp rbp, 7                                  ; checks if column has reached the last element or not
        jne iteration                               ; if not repeat
        je change_diag                              ; if yes i can change side diagonal now

      change_max:
        mov r8, rax                                 ; puts max element in r8
        jmp iter_cycle

      change_not:
        mov r8, rcx                                 ; puts max element in r8
        jmp iter_cycle

    change_diag:
      mov QWORD[matr + r9], r8                      ; puts max elements in side diagonal
      add r9, 48

      cmp rbx, 448                                  ; checks if its end of matrix or not
      je print_output
      jne before_iter

    print_output:
      mov rbx, 0                                    ; prepares for iteration
      jmp output

      output:
        mov rcx, [matr + rbx * 8]                   ; takes matrix element
        add rcx, '0'                                ; turns integers to ASCII
        mov [temp], rcx                             ; puts it to temporary value
        inc rbx

        mov rax, write                              ; prints out
        mov rdi, stdout
        mov rsi, temp
        mov rdx, 1
        syscall

        cmp rbx, 7                                  ; i was too lazy to write iteration here
        je print_space

        cmp rbx, 14                                  ; i was too lazy to write iteration here
        je print_space

        cmp rbx, 21                                  ; i was too lazy to write iteration here
        je print_space

        cmp rbx, 28                                  ; i was too lazy to write iteration here
        je print_space

        cmp rbx, 35                                  ; i was too lazy to write iteration here
        je print_space

        cmp rbx, 42                                  ; i was too lazy to write iteration here
        je print_space

        continue:

        cmp rbx, 49                                  ; checks if its the end of matrix
        je _exit
        jne output

    _exit:
      mov rax, exit
      xor rdi, rdi
      syscall

    print_space:
      mov rax, write                                ; prints out space to make it more understandable
      mov rdi, stdout
      mov rsi, space
      mov rdx, space_len
      syscall

      jmp continue
