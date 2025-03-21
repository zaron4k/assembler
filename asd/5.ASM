                          include 'D:\FASM\INCLUDE\win32a.inc'  ; Include Win32 API macros

format PE console
entry start

section '.data' data readable writeable
    input_prompt db 'Enter two integers (m and n): ', 0
    fmt db '%d %d', 0  ; Format for scanf
    result_msg db 'Quotient: %d', 0Ah, 0
    error_msg db '%d is not divisible by %d', 0Ah, 0

    m dd ?
    n dd ?

section '.code' code readable executable
start:
main_loop:
    ; Print input prompt
    invoke printf, input_prompt

    ; Read two numbers from user input
    invoke scanf, fmt, m, n
    add esp, 8  ; Clean stack after scanf (2 arguments, 4 bytes each)

    ; Load values into registers
    mov eax, [m]  ; EAX = m
    mov ecx, [n]  ; ECX = n

    ; Check for division by zero (not allowed)
    cmp ecx, 0
    je main_loop  ; If n == 0, ask for input again

    ; Perform division
    cdq          ; Sign-extend EAX into EDX:EAX
    idiv ecx     ; EAX = EAX / ECX, remainder in EDX

    ; Check if remainder is zero
    cmp edx, 0
    jne not_divisible

    ; If divisible, print quotient
    invoke printf, result_msg, eax
    jmp main_loop

not_divisible:
    invoke printf, error_msg, [m], [n]
    jmp main_loop

exit:
    invoke ExitProcess, 0

section '.idata' import data readable writeable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', scanf, 'scanf'
