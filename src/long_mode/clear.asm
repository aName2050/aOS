[bits 64]

clear_long:
    push rdi
    push rax
    push rcx

    shl rdi, 8
    mov rax, rdi

    mov al, space_char

    mov rdi, vga_start
    mov rcx, vga_extent / 2

    rep stosw

    pop rcx
    pop rax
    pop rdi
    ret

space_char: equ ` `