include 'D:\FASM\INCLUDE\win32a.inc'  ; Include Win32 API macros

format PE console
entry start

section '.data' data readable writeable
    input_prompt db 'Enter two numbers separated by a space: ', 0
    fmt db '%d %d', 0  ; Format for scanf
    result_msg db 'Result: %d', 0Ah, 0

    num1 dd ?
    num2 dd ?

section '.bss' readable writeable
    buffer rb 32   ; Input buffer

section '.code' code readable executable
start:
main_loop:
    ; Print input prompt
    invoke printf, input_prompt

    ; Read two numbers from user input
    invoke scanf, fmt, num1, num2
    add esp, 8  ; Clean stack after scanf (2 arguments, 4 bytes each)

    ; Load numbers into registers
    mov eax, [num1]  ; EAX = num1
    mov ebx, [num2]  ; EBX = num2

    ; Check if the first number is greater than the second
    cmp eax, ebx
    jle print_result  ; If num1 <= num2, print it as is

    ; If num1 > num2, divide num1 by 2
    shr eax, 1  ; Bitwise shift right (divides by 2 faster than `div`)

print_result:
    ; Print the result
    invoke printf, result_msg, eax

    ; Repeat the loop
    jmp main_loop

exit:
    invoke ExitProcess, 0

section '.idata' import data readable writeable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', scanf, 'scanf'
