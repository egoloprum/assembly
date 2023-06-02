; The given text is not more than 255 characters.
; Delete sequences of the same characters if they 
; contain more than 3 characters.

%define write 1
%define stdout 1
%define exit 60

section .text
    global printResult

printResult:
    nop
    mov rcx, rdi            ; takes string
    mov rbx, rsi            ; takes length

print:
    mov rax, write
    mov rdi, stdout
    mov rsi, rcx
    mov rdx, rbx
    syscall

_exit:
    mov rax, exit
    xor rdi, rdi
    syscall

; nasm -f elf64 -o printResult.o printResult.asm
; g++ -c lab5.cpp
; g++ -o lab5 printResult.o lab5.o