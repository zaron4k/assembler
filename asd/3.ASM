include 'D:\FASM\INCLUDE\win32a.inc'  ; Include Win32 API macros

format PE console
entry start

section '.data' data readable writeable
    input_prompt db 'Enter coordinates x y (non-zero): ', 0
    fmt db '%d %d', 0  ; Format for scanf
    result_msg db 'Quadrant: %d', 0Ah, 0
    error_msg db 'Coordinates must not be zero!', 0Ah, 0

    x dd ?
    y dd ?

section '.code' code readable executable
start:
main_loop:
    ; Print input prompt
    invoke printf, input_prompt

    ; Read two numbers entered by the user
    invoke scanf, fmt, x, y
    add esp, 8  ; Clean stack after scanf (2 arguments, 4 bytes each)

    ; Load x and y into registers
    mov eax, [x]  ; EAX = x
    mov ebx, [y]  ; EBX = y

    ; Check if x or y is zero
    cmp eax, 0
    je error_case
    cmp ebx, 0
    je error_case

    ; Determine the quadrant
    mov ecx, 1  ; Default to Quadrant 1

    cmp eax, 0
    jg check_y_pos   ; If x > 0, check y
    mov ecx, 2       ; If x < 0, assume Quadrant 2

check_y_neg:
    cmp ebx, 0
    jg print_quadrant ; If y > 0, print quadrant number (2)
    add ecx, 1        ; If y < 0, it's Quadrant 3
    jmp print_quadrant

check_y_pos:
    cmp ebx, 0
    jg print_quadrant ; If y > 0, it's Quadrant 1
    add ecx, 3        ; If y < 0, it's Quadrant 4

print_quadrant:
    ; Print quadrant number
    invoke printf, result_msg, ecx
    jmp main_loop

error_case:
    invoke printf, error_msg
    jmp main_loop  ; Ask for new coordinates

exit:
    invoke ExitProcess, 0

section '.idata' import data readable writeable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', scanf, 'scanf'
