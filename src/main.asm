org 0x7C00
bits 16

start:
    jmp main


; Prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    ; Save regs that will be modified
    push si
    push ax

.loop:
    lodsb           ; laods next char in al reg
    or al, al       ; is next char null?
    jz .done
    jmp .loop

.done:
    pop ax
    pop si
    ret

main:

    ; Setup data segments
    mov ax, 0 ; Not allowed to write to es and ds regs directly
    mov ds, ax
    mov es, ax

    ; Setup stack
    mov ss, ax
    mov sp, 0x7C00 ; Stacks grows going down from where this is loaded in memory

    hlt

.halt:
    jmp .halt

times 510-($-$$) db 0
dw 0AA55h