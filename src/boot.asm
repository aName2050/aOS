[org 0x7c00] 
mov [BOOT_DISK], dl 

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

cli
lgdt [GDT_Descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax ; CPU now in 32-bit protected mode
jmp CODE_SEG:start_protected_mode

jmp $


GDT_Start:
    null_descriptor:
        dd 0x0 ; four times 00000000
        dd 0x0 ; four times 00000000
    code_descriptor:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10011010
        db 0b11001111
        db 0x0
    data_descriptor:
        dw 0xffff
        dw 0x0
        db 0x0
        db 0b10010010
        db 0b11001111
        db 0x0

GDT_End:


GDT_Descriptor:
    dw GDT_End - GDT_Start - 1 ; size
    dd GDT_Start ; start


[bits 32]
start_protected_mode:
    mov al, 'A'
    mov ah, 0x0f
    mov [0xb8000], ax
    jmp $

BOOT_DISK: db 0

; boot sector padding

times 510-($-$$) db 0
dw 0xaa55