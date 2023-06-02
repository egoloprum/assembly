; Matrix B (4.4) is given. In each column, define the products of the elements
; remember the main and side diagonals and the results in the D (4) array.

%define write 1
%define stdout 1
%define exit 60

section .data
    matr db 2,2,3,4,1
         db 5,1,5,8,1
         db 9,6,1,12,1
         db 7,3,15,1,1
         db 1,1,1,1,1

    space db " ", 10
    space_len equ $- space

section .bss
    temp resb 5

section .text
    global _start

    _start:
        mov r8, 0
        mov r9, -6

        print_output:
            add r9, 6
            mov rax, [matr + r9]
            mov rbx, [matr + 5 * r8 + 4 - r8]
            mul rbx

            add rax, '0'
            mov [temp + r8], rax

            inc r8
            cmp r8, 5
            je _exit
            jne print_output

        _exit:

            mov rsi, temp
            mov rdx, 5
            mov rax, write
            mov rdi, stdout
            syscall

            mov rax, write
            mov rdi, stdout
            mov rsi, space
            mov rdx, space_len
            syscall

            mov rax, exit
            xor rdi, rdi
            syscall
