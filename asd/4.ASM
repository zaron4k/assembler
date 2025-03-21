include 'D:\FASM\INCLUDE\win32a.inc'  ; Include Win32 API macros

format PE console
entry start

section '.data' data readable writeable
    input_prompt db 'Enter three natural numbers separated by spaces: ', 0
    fmt db '%d %d %d', 0  ; Format for scanf
    result_msg db 'Numbers ending with 1: ', 0
    space db ' ', 0
    newline db 0Ah, 0
    no_result_msg db 'No numbers ending with 1', 0Ah, 0

    num1 dd ?
    num2 dd ?
    num3 dd ?

section '.code' code readable executable
start:
main_loop:
    ; Print input prompt
    invoke printf, input_prompt

    ; Read three numbers from user input
    invoke scanf, fmt, num1, num2, num3
    add esp, 12  ; Clean stack after scanf (3 arguments, 4 bytes each)

    ; Print the message before the results
    invoke printf, result_msg

    ; Check each number
    mov esi, 0  ; Flag to check if at least one number was found

    mov eax, [num1]
    mov edx, 0
    mov ecx, 10
    div ecx  ; Divide by 10, remainder in EDX (last digit)
    cmp edx, 1
    jne check_num2
    invoke printf, fmt, [num1]
    invoke printf, space
    mov esi, 1  ; At least one number found

check_num2:
    mov eax, [num2]
    mov edx, 0
    div ecx
    cmp edx, 1
    jne check_num3
    invoke printf, fmt, [num2]
    invoke printf, space
    mov esi, 1

check_num3:
    mov eax, [num3]
    mov edx, 0
    div ecx
    cmp edx, 1
    jne check_end
    invoke printf, fmt, [num3]
    invoke printf, space
    mov esi, 1

check_end:
    ; If no number was found, print "No numbers ending with 1"
    cmp esi, 1
    je print_newline
    invoke printf, no_result_msg
    jmp main_loop

print_newline:
    invoke printf, newline
    jmp main_loop

exit:
    invoke ExitProcess, 0

section '.idata' import data readable writeable
    library kernel32, 'kernel32.dll', msvcrt, 'msvcrt.dll'
    import kernel32, ExitProcess, 'ExitProcess'
    import msvcrt, printf, 'printf', scanf, 'scanf'
