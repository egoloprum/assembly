%include "io.asm"

%define STDIN 0
%define READ 0
%define STDOUT 1
%define WRITE 1
%define EXIT 60

%define ROWS 6
%define COLUMNS 5
%define MATRIX_SIZE 930

section .data
    StartMsg db "Enter 6*5 matrix:", 10
    StartLen equ $-StartMsg
    NewLine: db 0xA
    ResultMsg db "Result:", 10
    ResultLen equ $-ResultMsg

    IncorrectLineMsg db "Each line should have exactly 5 numbers divided by spaces", 10
    IncorrectLineLen equ $-IncorrectLineMsg

    ErrorSTIMsg dq "Error while transform str to int", 10
    ErrorSTILen equ $-ErrorSTIMsg

    prompt db "input x number ranging from 0 to 4: "
    prompt_len equ $- prompt

    Space db "  "

    new_line db "", 10
    new_line_len equ $- new_line

    input times 16 db 0
    input_len equ $-input

section .bss
    matrix times MATRIX_SIZE resq 1

    OutBuf resw 1
    lenOut equ $-OutBuf
    InBuf resq 10
    lenIn equ $-InBuf

    x resq 1


section .text
global _start

_start:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, StartMsg
    mov rdx, StartLen
    syscall

    mov rcx, ROWS
    xor rdi, rdi

read_line:
    push rcx
    push rdi

    mov rax, READ
    mov rdi, STDIN
    mov rsi, InBuf
    mov rdx, lenIn
    syscall

    pop rdi
    mov rcx, rax ; Сохраням длину строки
    xor rdx, rdx ; Обнуляем регистр
    xor r8, r8 ; Обнуляем регистр

process_line:
    cmp byte[InBuf + rdx], 10; Если конец строки то обрабатываем число
    je process_number

    cmp byte[InBuf + rdx], ' '; Если был не конец, и следующий символ 
    jne next; не пробел, то продолжаем считывание

    mov byte[InBuf + rdx], 10; Помещаем вместо проблеа \n
    cmp r8, rdx; Если длина строки не совпадает с предыдущей
    jne process_number
    jmp next; ???

process_number:
    push rdx

    call StrToInt64; Вход: RSI Выход: RAX, RBX содержит 0 if errors = 0
    cmp rbx, 0
    jne STIError; Вывод ошибки

    mov [matrix + 8 * rdi], rax; Помещаем результат в матрицу
    inc rdi; увеличиваем счетчик введенных чисел

    pop rdx
    mov r8, rdx; Теперь считывать следующее число надо начинать с 
    inc r8; окончания длины предыдущего
    lea rsi, [InBuf + r8]; Передаем указатель на смещенный буфер

next:
    inc rdx; Увеличиваем длину числа
    loop process_line

    pop rcx
    mov rax, ROWS; Проверим количество введеных чисел < 7 в текущей строке
    sub rax, rcx
    inc rax
    push rdx
    mov rdx, COLUMNS
    imul rdx
    pop rdx 

    cmp rdi, rax; Если введено чисел больше чем длинна строки матрицы
    jne IncorrectLine

    ; loop read_line; Увы здесь не подойдет шорт прыжок
    dec rcx
    cmp rcx, 0
    jnz read_line

; ; logic starts here    

    mov rbp, 0          ; check incremetion value

x_number:
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
    mov [x], rax
    cmp rax, 4
    jle before_iter
    jg x_number

before_iter:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, new_line
    mov rdx, new_line_len
    syscall

    mov rbx, -1
    mov rbp, -40
iteration:
    inc rbx
    add rbp, 40
    cmp rbx, 6
    je output
    jne make_zero

make_zero:
    mov r8, 0
    mov rcx, [x]
    mov [matrix + 8 * rcx + rbp], r8
    jmp iteration

output:
    mov rax, WRITE
    mov rdi, STDOUT
    mov rsi, ResultMsg
    mov rdx, ResultLen
    syscall

    mov rcx, ROWS
    xor rbx, rbx; Обнуляем регистр
output_row:
    push rcx
    mov rcx, COLUMNS
output_column:
    push rcx
    mov rsi, OutBuf
    mov rax, [matrix + 8 * rbx]
    inc rbx
    call IntToStr64

    mov rax, WRITE; системная функция 1 (write)
    mov rdi, STDOUT; дескриптор файла stdout=1
    mov rsi, OutBuf ; адрес выводимой строки
    mov rdx, lenOut ; длина строки
    syscall; вызов системной функции

    call PrintSpace

    pop rcx
    loop output_column

    mov rax, WRITE; системная функция 1 (write)
    mov rdi, STDOUT; дескриптор файла stdout=1
    mov rsi, NewLine ; адрес выводимой строки
    mov rdx, 1 ; длина строки
    syscall; вызов системной функции

    pop rcx
    loop output_row

exit:
    xor rdi, rdi
    mov rax, EXIT
    syscall

IncorrectLine:
    mov rax, WRITE
    mov rdi, STDOUT   
    mov rsi, IncorrectLineMsg
    mov rdx, IncorrectLineLen
    syscall
    jmp exit

STIError:
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ErrorSTIMsg ; адрес выводимой строки
    mov rdx, ErrorSTILen ; длина строки
    syscall; вызов системной функции
    jmp exit
;end

PrintSpace:    
    mov rax, 1
    mov rdi, 1
    mov rsi, Space
    mov rdx, 1
    syscall
    ret
