[org 0x7c00]
KERNEL_LOCATION equ 0x1000

BOOT_DISK: db 0
mov [BOOT_DISK], dl

xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

mov bx, KERNEL_LOCATION
mov dh, 20

mov ah, 0x02
mov al, dh
mov ch, 0x00
mov dh, 0x00
mov cl, 0x02
mov dl, [BOOT_DISK]
int 0x13

mov ah, 0x0
mov al, 0x3
int 0x10

CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

cli
lgdt [GDT_Descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:start_protected_mode

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
    mov ax, DATA_SEG ; setup segment registers and stack
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000
    mov esp, ebp

    jmp KERNEL_LOCATION ; jump to kernel

; boot sector padding
times 510-($-$$) db 0
dw 0xaa55