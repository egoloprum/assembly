bits 64;

%include "io.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

section .data
    prompt db "Input three numbers, each on its own line",10
    prompt_len equ $-prompt

    err_msg db "Error: make sure that each line is a single number",10
    err_len equ $-err_msg

    input times 8 db 0
    input_len equ $-input

    output times 8 db 0

section .bss
    a resq 1
    d resq 1
    q resq 1

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
    mov [d], rax

    mov rax, READ
    mov rdx, input_len
    syscall

    call StrToInt64
    cmp rbx, 0
    jne error
    mov [q], rax

    mov rax, [q]

    cmp rax, 5
    jg true
    jl false

true:
    mov rax, [q]
    mul rax
    mov rbx, 3
    div rbx
    mov rcx, rax

    mov rax, [a]
    mov rbx, [d]
    mul rbx

    sub rcx, rax

    mov rax, rcx

    jmp return

false:
    mov rax, [a]
    mul rax
    mov rbx, [q]
    div rbx

return:
    mov rsi, output
    call IntToStr64

    mov rdx, rax
    mov rax, WRITE
    mov rdi, STDOUT
    syscall

    jmp exit

error:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, err_msg
    mov rdx, err_len
    syscall

exit:
    xor rdi, rdi
    mov rax, EXIT
    syscall

; test a = 3 d = 2 q = 6
; test2 a = 3 d = 2 q = 4