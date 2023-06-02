; Matrix A (4.4) is given. Write them in place of the elements of the side diagonal
; products on element a [4,4] and display the matrix on the screen.

%define write 1
%define stdout 1
%define exit 60


section .data
    matr db 1, 2, 3, 1,
         db 3, 3, 3, 2,
         db 4, 1, 2, 3,
         db 4, 2, 2, 2

    space db " ", 10
    space_len equ $- space

section .bss
    temp resb 4


section .text
    global _start

    _start:

        mov r8, 0

        print_output:
            mov rax, [matr + 4 * r8 + 3 - r8]
            mov rbx, [matr + 15]
            mul rbx

            add rax, '0'
            mov [temp + r8], rax

            inc r8
            cmp r8, 4
            je _exit
            jne print_output

        _exit:
            mov rax, write
            mov rdi, stdout
            mov rsi, temp
            mov rdx, 4
            syscall

            mov rax, write
            mov rdi, stdout
            mov rsi, space
            mov rdx, space_len
            syscall

            mov rax, exit
            xor rdi, rdi
            syscall


