BITS 64;

%include "io.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

section .data
    prompt db "Enter numbers a, b each in its own line:", 10
    prompt_len equ $-prompt

    err_msg db "Error: make sure that each line is a single number",10
    err_len equ $-err_msg

    buff times 8 db 0 

    input times 16 db 0
    input_len equ $-input

section .bss
    f resq 1

    a resq 1
    b resq 1

section .text
global _start

_start:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    mov rax, READ
    mov rdi, STDIN
    mov rsi, input
    mov rdx, input_len
    syscall

    call StrToInt64
    cmp rbx, 0
    jne error
    mov [a], rax

    mov rax, READ
    mov rdx, input_len
    syscall

    call StrToInt64
    cmp rbx, 0
    jne error
    mov [b], rax

    ; a**2 / 2 - (b * b * b) / (4 - a + b)

    mov rbx, 2
    mov rax, [a]    ; a
    mul rax         ; a^2
    div rbx         ; a^2 / 2

    mov rbx, rax    ; a^2 / 2
    mov rax, [b]    ; b
    mul rax         ; b^2
    mov rcx, [b]    ; b
    mul rcx         ; b^3

    mov rcx, 4      ; 4
    sub rcx, [a]    ; 4 - a
    add rcx, [b]    ; 4 - a + b
    div rcx         ; b^3 / ( 4 - a + b)

    sub rbx, rax    ; a^ 2 / 2 - b^3 / (4 - a + b)
    mov rax, rbx

    ; end of operation

    mov rsi, buff
    call IntToStr64

    mov rdx, rax
    mov rax, WRITE
    mov rdi, STDOUT   
    syscall

exit:
    xor rdi, rdi
    mov rax, EXIT
    syscall

error:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, err_msg
    mov rdx, err_len
    syscall
    jmp exit