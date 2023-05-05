#include <cpu/ports.h>
#include <driver/vga.h>


volatile vga_char *TEXT_AREA = (vga_char*) VGA_START;


u8_t vga_color(const u8_t fg_color, const u8_t bg_color){
    // Put bg color in the higher 4 bits and mask those of fg
    return (bg_color << 4) | (fg_color & 0x0F);
}


void clearwin(u8_t fg_color, u8_t bg_color){
    const char space = ' ';
    u8_t clear_color = vga_color(fg_color, bg_color);

    const vga_char clear_char = {
        .character = space,
        .style = clear_color
    };

    for(u64_t i = 0; i < VGA_EXTENT; i++) {
        TEXT_AREA[i] = clear_char;
    }
}


void putchar(const char character, const u8_t fg_color, const u8_t bg_color){
    u8_t style = vga_color(fg_color, bg_color);
    vga_char printed = {
        .character = character,
        .style = style
    };

    u16_t position = get_cursor_pos();
    TEXT_AREA[position] = printed;
}


void putstr(const char *string, const u8_t fg_color, const u8_t bg_color){
    while (*string != '\0'){
        putchar(*string++, fg_color, bg_color);
        advance_cursor();
    }
}

void init_video(void){
    set_cursor_pos(0, 0);
    clearwin(COLOR_BLK, COLOR_LCY);
}

u16_t get_cursor_pos(){
    u16_t position = 0;

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    position |= byte_in(CURSOR_PORT_DATA);

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    position |= byte_in(CURSOR_PORT_DATA) << 8;

    return position;
}


void show_cursor(){
    u8_t current;

    byte_out(CURSOR_PORT_COMMAND, 0x0A);
    current = byte_in(CURSOR_PORT_DATA);
    byte_out(CURSOR_PORT_DATA, current & 0xC0);

    byte_out(CURSOR_PORT_COMMAND, 0x0B);
    current = byte_in(CURSOR_PORT_DATA);
    byte_out(CURSOR_PORT_DATA, current & 0xE0);
}


void hide_cursor(){
    byte_out(CURSOR_PORT_COMMAND, 0x0A);
    byte_out(CURSOR_PORT_DATA, 0x20);
}


void advance_cursor(){
    u16_t pos = get_cursor_pos();
    pos++;

    if (pos >= VGA_EXTENT){
        pos = VGA_EXTENT - 1;
    }

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    byte_out(CURSOR_PORT_DATA, (u8_t) (pos & 0xFF));

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    byte_out(CURSOR_PORT_DATA, (u8_t) ((pos >> 8) & 0xFF));
}


void set_cursor_pos(u8_t x, u8_t y){
    u16_t pos = x + ((u16_t) VGA_WIDTH * y);

    if (pos >= VGA_EXTENT){
        pos = VGA_EXTENT - 1;
    }

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    byte_out(CURSOR_PORT_DATA, (u8_t) (pos & 0xFF));

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    byte_out(CURSOR_PORT_DATA, (u8_t) ((pos >> 8) & 0xFF));
}

