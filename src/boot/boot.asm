[org 0x7c00]

KERNEL_OFFSET equ 0x1000 

mov [BOOT_DRIVE], dl 
mov bp, 0x9000
mov sp, bp

mov ah, 0x0
mov al, 0x3
int 0x10  

mov bx, MSG_REAL_MODE 
call print
call print_nl

call load_kernel 
call switch_to_pm 
jmp $ 

%include "D:/aOS/src/display/print.asm"
%include "D:/aOS/src/display/print_hex.asm"
%include "D:/aOS/src/disk/disk.asm"
%include "D:/aOS/src/32-bit/gdt.asm"
%include "D:/aOS/src/display/print32.asm"
%include "D:/aOS/src/32-bit/switch.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET 
    mov dh, 2
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET 
    jmp $ 


BOOT_DRIVE db 0 
MSG_REAL_MODE db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE db "Loaded in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

; boot sector padding
times 510 - ($-$$) db 0
dw 0xaa55