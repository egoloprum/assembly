; In each row of the matrix X (5.5), determine the product of the numbers dividing by 5
; without residue and place it in vector K (5)

%define write 1
%define stdout 1
%define exit 60

section .data
    matr db 2,2,2,8,5,
        db 2,2,2,1,1,
        db 2,1,1,1,1,
        db 2,2,1,1,1,
        db 1,1,1,1,1

    tab db "0"
    tab_len equ $- tab

    space db " ", 10
    space_len equ $- space

    rows db 4

section .bss
    temp resb 10
    mult resb 10


section .text
    global _start

    _start:
        mov rbx, 0
        mov r8, 2
        mov rcx, 1

    iteration:
        mov rax, [matr + rbx]
        div r8

        cmp rbx, 4
        je _exit

        cmp rdx, 0
        je answer_true
        jne answer_false


        answer_true:
            xor rdx, rdx

            mov rax, rcx
            mov rcx, [matr + rbx]
            mul rcx

            inc rbx
            xor rdx, rdx

            cmp rbx, 4
            je check_output
            jne iteration
            

        answer_false:
            xor rdx, rdx
            inc rbx

            cmp rbx, 4
            je check_output
            jne iteration

        check_output:
            cmp rcx, 1
            je print_false
            jne print_true


        print_false:
            mov rax, write
            mov rdi, stdout
            mov rsi, tab
            mov rdx, tab_len
            syscall

            mov rcx, 1
            jmp _exit

        print_true:
            add rcx, '0'
            mov [mult], rcx

            mov rax, write
            mov rdi, stdout
            mov rsi, mult
            mov rdx, 1
            syscall

            mov rcx, 1
            jmp _exit


    _exit:

        mov rax, write
        mov rdi, stdout
        mov rsi, space
        mov rdx, space_len
        syscall

        mov rax, exit
        xor rdi, rdi 
        syscall