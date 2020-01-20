SECTION header vstart=0

SECTION code_1 align=16 vstart=0
put_string:
  ; Input: ds:bx

  mov cl, [bx]
  or cl, cl
  jz .exit
  call put_char
  inc bx
  jmp put_string

 .exit:
    ret

put_char:
  push ax
  push bx
  push cx
  push dx
  push ds
  push es

  mov dx, 0x3d4
  mov al, 0x0e
  out dx, al
  mov dx, 0x3d5
  in al, dx
  mov ah, al

  mov dx, 0x3d4
  mov al, 0x0f
  out dx, al
  mov dx, 0x3d5
  in al, dx
  mov bx, ax                    ; Get cursor pos tp bx

  cmp cl, 0x0d                  ; Enter?
  jnz .put_0a
  mov bl, 80
  div bl
  mul bl
  mov bx, ax
  jmp .set_cursor

 .put_0a:
  cmp cl, 0x0a                  ; \n?
  jnz .put_other
  add bx, 80
  jmp .roll_screen

 .put_other:
  mov ax, 0xb800
  mov es, ax
  shl bx, 1                     ; Double cursor addr 
  mov [es:bx], cl

  shr bx, 1
  add bx, 1                     ; Increase cursor addr

 .roll_screen:
  cmp bx, 2000
  jl .set_cursor

  mov ax, 0xb800
  mov ds, ax
  mov es, ax
  cld
  mov si, 0xa0
  mov di, 0x00
  mov cx, 1920
  rep movsw
  mov bx, 3840                  ; Clear bottom line
  mov cx, 80

 .cls:
  mov word [es:bx], 0x720
  add bx, 2
  loop .cls

 .set_cursor:
  mov dx, 0x3d4
  mov al, 0x0e
  out dx, al
  mov dx, 0x3d5 
  mov al, bh
  out dx, al
  mov dx, 0x3d4 
  mov al, 0x0f
  out dx, al
  mov dx, 0x3d5
  mov al, bl
  out dx, al 

  pop es
  pop ds
  pop dx
  pop cx
  pop bx
  pop ax

  ret

start:
  mov ax, [stack_segment]
  mov ss, ax
  mov sp, stack_end

  mov ax, [data_1_segment]
  mov dx, ax

  mov bx, msg0
  call put_string



stack_end:

SECTION data_1 align=16 vstart=0

  msg0 db '  This is NASM - the famous Netwide Assembler. '
       db 'Back at SourceForge and in intensive development! '
       db 'Get the current versions from http://www.nasm.us/.'
       db 0x0d, 0x0a, 0x0d, 0x0a
       db '  Example code for calculate 1+2+...+1000:',0x0d,0x0a,0x0d,0x0a
       db '     xor dx,dx',0x0d,0x0a
       db '     xor ax,ax',0x0d,0x0a
       db '     xor cx,cx',0x0d,0x0a
       db '  @@:',0x0d,0x0a
       db '     inc cx',0x0d,0x0a
       db '     add ax,cx',0x0d,0x0a
       db '     adc dx,0',0x0d,0x0a
       db '     inc cx',0x0d,0x0a
       db '     cmp cx,1000',0x0d,0x0a
       db '     jle @@',0x0d,0x0a
       db '     ... ...(Some other codes)',0x0d,0x0a,0x0d,0x0a
       db 0


