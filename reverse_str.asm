section .data
    output db "          ", 0 
    prompt db "Enter a string: ", 0
    prompt_len equ $ - prompt
    space db " ", 10
    space_len equ $ - space

section .bss
    buffer resb 256

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 256
    int 0x80

    ; initialize registers
    mov esi, buffer ; set the source string pointer
    mov edi, output ; set the destination string pointer
    mov ecx, 0

    count:
        cmp byte [esi + ecx], 0 ; check if end of string reached
        je reverse
        inc ecx 
        jmp count

    reverse:
        mov ebx, ecx
        reverse_char:
            cmp byte [esi], 0 ; check if end of string reached
            je print_output 

            mov al, [esi] 
            mov [edi + ebx - 1], al 
            inc esi 
            dec ebx 
            jmp reverse_char 

    print_output:
        mov ebp, ecx
        mov eax, 4 
        mov ebx, 1
        mov ecx, output 
        mov edx, ecx 
        sub edx, edi 
        add edx, ebp 
        int 0x80

        mov eax, 4
        mov ebx, 1
        mov ecx, space
        mov edx, space_len
        int 0x80

        mov eax, 1 
        xor ebx, ebx 
        int 0x80 