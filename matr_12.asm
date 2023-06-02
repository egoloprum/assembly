; A text consisting of words separated by several 
; spaces is given. Define words containing an equal 
; number of vowels and consonants.

%define write 1
%define stdout 1
%define read 0
%define stdin 0
%define exit 60

section .data
    ;words db "at   aaabb qweqaa ", 10
    ;words_len equ $- words

    result_true db "equal", 10
    result_true_len equ $- result_true

    result_false db "not equal", 10
    result_false_len equ $- result_false

    space db " ", 10
    space_len equ $- space

section .bss
    words resb 255

section .text
    global _start

    _start:

    take_input:
        mov rax, read
        mov rdi, stdin
        mov rsi, words
        mov rdx, 255
        syscall

    print_input:
        mov rax, write
        mov rdi, stdout
        mov rsi, words
        mov rdx, 255
        syscall

        mov rbx, -1         ; iteration counter
        mov r8, 0           ; vowel counter
        mov r9, 0           ; consonant counter
        mov r10, 0          ; word counter
        mov rax, 255  ; word length

    iteration:
        inc rbx

        cmp rbx, rax
        je _exit

        cmp byte[words + rbx], ' '
        je check_result
        jne check_vowels

    check_vowels:
        check_a:
            cmp byte[words + rbx], 'a'
            je increment_vowels
            jne check_e

        check_e:
            cmp byte[words + rbx], 'e'
            je increment_vowels
            jne check_u

        check_u:
            cmp byte[words + rbx], 'u'
            je increment_vowels
            jne check_i

        check_i:
            cmp byte[words + rbx], 'i'
            je increment_vowels
            jne check_o

        check_o:
            cmp byte[words + rbx], 'o'
            je increment_vowels
            jne increment_cons

        increment_vowels:
            inc r8
            jmp iteration

        increment_cons:
            inc r9
            jmp iteration

        check_result:
            check_r8:
                cmp r8, 0
                je check_r9
                jne continue

            check_r9:
                cmp r9, 0
                je iteration
                jne continue

            continue:
                cmp r8, r9
                je print_equal
                jne print_not_equal


        print_equal:
            mov rax, write
            mov rdi, stdout
            mov rsi, result_true
            mov rdx, result_true_len
            syscall

            mov r8, 0
            mov r9, 0
            mov rax, 255

            jmp iteration

        print_not_equal:
            mov rax, write
            mov rdi, stdout
            mov rsi, result_false
            mov rdx, result_false_len
            syscall

            mov r8, 0
            mov r9, 0
            mov rax, 255

            jmp iteration

    _exit:
        mov rax, exit
        xor rdi, rdi
        syscall