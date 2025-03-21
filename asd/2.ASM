include 'D:\FASM\INCLUDE\win32a.inc'  ; Include Win32 API macros

format PE console
entry start

section '.data' data readable writeable
    input_prompt db 'Enter three different numbers separated by spaces: ', 0
    fmt db '%d %d %d', 0  ; Format for scanf
    result_msg db 'Largest number: %d', 0Ah, 0

    num1 dd ?
    num2 dd ?
    num3 dd ?

section '.code' code readable executable
start:
main_loop:
    ; Print input prompt
    invoke printf, input_prompt

    ; Read three numbers entered by the user
    invoke scanf, fmt, num1, num2, num3
    add esp, 12  ; Clean stack after scanf (3 arguments, 4 bytes each)

    ; Load numbers into registers
    mov eax, [num1]  ; EAX = num1
    mov ebx, [num2]  ; EBX = num2
    mov ecx, [num3]  ; ECX = num3

    ; Determine the largest number
    cmp eax, ebx
    jge check_eax_ecx
    mov eax, ebx  ; If ebx > eax, set eax = ebx

check_eax_ecx:
    cmp eax, ecx
    jge print_result
    mov eax, ecx  ; If ecx > eax, set eax = ecx

print_result:
    ; Print the largest number
    invoke printf, result_msg, eax

    ; Repeat input process
    jmp main_loop

exit:
    invoke ExitProcess, 0

section '.idata' import data readable writeable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', scanf, 'scanf'
