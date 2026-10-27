; CSC 3410 Assignment 3

SECTION .data

prompt          db "Please enter a string:",10
promptLen       equ $-prompt

palMsg          db "It is a palindrome",10
palMsgLen       equ $-palMsg

notPalMsg       db "It is NOT a palindrome",10
notPalMsgLen    equ $-notPalMsg

SECTION .bss

buffer          resb 1024

SECTION .text
global _start

; --------------------------------------------------
; int is_palindrome(char *buffer, int len)
;
; Returns:
;   EAX = 1 if palindrome
;   EAX = 0 otherwise
;
; Parameters:
;   [EBP+8]  = buffer
;   [EBP+12] = len
; --------------------------------------------------

is_palindrome:
    push ebp
    mov ebp, esp

    push ebx
    push esi
    push edi

    mov esi, [ebp+8]      ; buffer
    mov ecx, [ebp+12]     ; len

    xor ebx, ebx          ; i = 0

    mov edi, ecx
    dec edi               ; j = len - 1

compare_loop:
    mov eax, ecx
    shr eax, 1            ; len / 2

    cmp ebx, eax
    jge palindrome

    mov al, [esi+ebx]
    cmp al, [esi+edi]
    jne not_palindrome

    inc ebx
    dec edi

    jmp compare_loop

palindrome:
    mov eax, 1
    jmp done

not_palindrome:
    mov eax, 0

done:
    pop edi
    pop esi
    pop ebx

    mov esp, ebp
    pop ebp
    ret

; Program Entry Point

_start:

main_loop:

    ; Prints prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, promptLen
    int 0x80

    ; Reads user input
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    ; If the first character is newline then exit
    cmp byte [buffer], 10
    je exit_program

    ; Removes newline from length
    dec eax

    ; Calls is_palindrome(buffer, len)
    push eax
    push dword buffer

    call is_palindrome

    add esp, 8

    ; If the return value is nonzero => palindrome
    test eax, eax
    jnz print_palindrome

print_not_palindrome:
    mov eax, 4
    mov ebx, 1
    mov ecx, notPalMsg
    mov edx, notPalMsgLen
    int 0x80

    jmp main_loop

print_palindrome:
    mov eax, 4
    mov ebx, 1
    mov ecx, palMsg
    mov edx, palMsgLen
    int 0x80

    jmp main_loop

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80
