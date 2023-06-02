; 11. Enter a string containing several words separated by a space. Output to
; screen number of words shorter than 4 characters and these words.

%define write 1
%define stdout 1
%define exit 60


section .data
    words db "qwer qwe qwer qw qweqw ", 10
    words_len equ $- words

    res_true db "yes", 10
    res_true_len equ $- res_true

    res_false db "no", 10
    res_false_len equ $- res_false

    space db " ", 10
    space_len equ $- space

section .bss
    temp resb 255

section .text
    global _start

    _start:

    print_input:
        mov rax, write
        mov rdi, stdout
        mov rsi, words
        mov rdx, words_len 
        syscall

        mov rbx, 0
        mov rcx, 0
        mov r8, words_len
        dec r8


    iteration:
        cmp byte[words + rbx], ' '
        je check_output

        inc rbx
        inc rcx
        cmp rbx, r8
        je check_output
        jne iteration 

    check_output:
        cmp rcx, 4
        jl print_false
        jnl print_true

    print_false:
        mov rax, write
        mov rdi, stdout
        mov rsi, res_false
        mov rdx, res_false_len
        syscall

        inc rbx
        mov rcx, 0

        cmp rbx, r8
        je _exit
        jne iteration



    print_true:
        mov rax, write
        mov rdi, stdout
        mov rsi, res_true
        mov rdx, res_true_len
        syscall

        inc rbx
        mov rcx, 0

        cmp rbx, r8
        je _exit
        jne iteration


    _exit:
        mov rax, exit
        xor rdi, rdi
        syscall
