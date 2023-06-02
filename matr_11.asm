%define STDOUT 1
%define WRITE 1
%define EXIT 60

section .data

    space db " ", 10
    space_len equ $- space

    words db "mqwer qwert mwert"
    words_len equ $- words

section .bss
    temp resb 255
    temp2 resb 255
    temp3 resb 255

section .text
    global _start
    _start:

        print_promt:

            mov rcx, words_len
            mov rbx, 0

        print_input:
            push rcx
            mov rbp, [words + rbx]
            mov [temp], rbp

            mov rax, WRITE
            mov rdi, STDOUT
            mov rsi, temp
            mov rdx, 1
            syscall

            inc rbx
            pop rcx
            loop print_input

        print_space:
            mov rax, WRITE
            mov rdi, STDOUT
            mov rsi, space
            mov rdx, space_len
            syscall

        print_promt2:

            mov rbx, 0
            
        check_string:
            mov rcx, 0

            cmp rbx, 18
            je _exit

            cmp BYTE[words + rbx], 'm'
            je increment_string

            inc rbx

            jmp check_string

        increment_string:
            mov rbp, [words + rcx + rbx]
            mov [temp2 + rcx], rbp
            inc rcx
            inc rbx

            cmp rcx, 5
            je check_next_string
            jne increment_string

        check_next_string:
            mov rcx, 0

            cmp rbx, 18
            ;je change_string
            je _exit

            cmp BYTE[words + rbx], 'm'
            je increment_next_string

            inc rbx

            jmp check_next_string

        increment_next_string:
            mov rbp, [words + rcx + rbx]
            mov [temp3 + rcx], rbp
            inc rcx

            cmp rcx, 5
            je before_change_string
            jne increment_next_string

        before_change_string:
            mov rbx, 0
            mov rcx, 0
            jmp change_string
        
        change_string:
            cmp BYTE[words + rbx], 'm'
            je first_string
            inc rbx
            jne change_string

        first_string:
            mov rbp, [temp3 + rcx]
            mov [words + rbx + rcx], rbp 

            inc rcx

            cmp rcx, 5
            je before_print_output
            jne first_string

        before_print_output:
            mov rbx, 0
            jmp print_output

        print_output:
            mov rbp, [words + rbx]
            mov [temp], rbp

            mov rax, WRITE
            mov rdi, STDOUT
            mov rsi, temp
            mov rdx, 1
            syscall

            inc rbx
            cmp rbx, 18
            je _exit
            jne print_output    
         

        _exit:
            mov rax, WRITE
            mov rdi, STDOUT
            mov rsi, space
            mov rdx, space_len
            syscall

            xor rdi, rdi
            mov rax, EXIT
            syscall
