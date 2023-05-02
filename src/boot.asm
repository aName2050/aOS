[org 0x7C00]

[bits 16]

mov bp, 0x0500
mov sp, bp

mov byte[boot_drive], dl

mov bx, msg_hello_world
call print_bios

mov bx, 0x0002
mov cx, 0x0002

mov dx, 0x7E00

call load_bios

call elevate_bios

bootsector_hold:
jmp $

%include "real_mode/print.asm"
%include "real_mode/print_hex.asm"
%include "real_mode/load.asm"
%include "real_mode/gdt.asm"
%include "real_mode/elevate.asm"

msg_hello_world: db `\r\nHello World, from the BIOS!\r\n`, 0

boot_drive: db 0x00

times 510 - ($ - $$) db 0x00

dw 0xAA55

bootsector_extended:
begin_protected:

[bits 32]

call clear_protected

call detect_lm_protected

mov esi, protected_alert
call print_protected

call init_pt_protected

call elevate_protected

jmp $

%include "protected_mode/clear.asm"
%include "protected_mode/print.asm"
%include "protected_mode/detect_lm.asm"
%include "protected_mode/init_pt.asm"
%include "protected_mode/gdt.asm"
%include "protected_mode/elevate.asm"

vga_start: equ 0x000B8000
vga_extent: equ 80 * 25 * 2
kernel_start: equ 0x00100000
style_wb: equ 0x0F

protected_alert: db `64-bit long mode supported`, 0

times 512 - ($ - bootsector_extended) db 0x00
begin_long_mode:

[bits 64]

mov rdi, style_blue
call clear_long

mov rdi, style_blue
mov rsi, long_mode_note
call print_long

jmp $

%include "long_mode/clear.asm"
%include "long_mode/print.asm"

long_mode_note: db `Now running in fully-enabled, 64-bit long mode!`, 0
style_blue: equ 0x1F

times 512 - ($ - begin_long_mode) db 0x00