[bits 32]

print_protected:
    pushad
    mov edx, vga_start

    print_protected_loop:
        cmp byte[esi], 0
        je print_protected_done

        mov al, byte[esi]
        mov ah, style_wb

        mov word[edx], ax

        add esi, 1
        add edx, 2

        jmp print_protected_loop

print_protected_done:
    popad
    ret