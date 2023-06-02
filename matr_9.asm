; Enter a character string containing words separated by two spaces.
; Determine the number of words that begin and end with "q."


%define write 1
%define stdout 1
%define exit 60

section .data
    words db "qwerq qweq", 10
    words_len equ $- words

    ans_true db "true", 10
    ans_true_len equ $- ans_true

    ans_false db "false", 10
    ans_false_len equ $- ans_false



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

    iteration:
        mov rbx, rcx
        cmp byte[words + rbx], 'q'
        je check_iteration
        jne count_length

    check_iteration:
        inc rcx
        cmp byte[words + rcx], 'q'
        je check_end
        jne check_not_end

    check_end:
        cmp byte[words + rcx + 1], ' '
        jne check_iteration
        je

    check_not_end:
        cmp byte[words + rcx], ' '



        je answer_true
        jne answer_false

    count_length:
        inc rcx
        cmp rcx, words_len
        je _exit
        jne continue

        continue:
            cmp byte[words + rcx], ' '
            je iteration
            jne count_length




    answer_false:
        mov rax, write
        mov rdi, stdout
        mov rsi, ans_false
        mov rdx, ans_false_len
        syscall

        jmp _exit

    answer_true:
        mov rax, write
        mov rdi, stdout
        mov rsi, ans_true
        mov rdx, ans_true_len
        syscall

        jmp _exit




    _exit:
        mov rax, exit
        xor rdi, rdi
        syscall
