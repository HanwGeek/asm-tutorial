; @HanwGeek
; @Show label set of number

jmp near start

; Init data
text db 'L', 0x07, 'a', 0x07, 'b', 0x07, 'e', 0x07, 'l', 0x07, ' ', 0x07, 'o', 0x07, \
        'f', 0x07, 'f', 0x07, 's', 0x07, 'e', 0x07, 't', 0x07, ':', 0x07

number db 0, 0, 0, 0, 0

start:
  mov ax, 0x7c0  ; Set data seg addr
  mov ds, ax

  mov ax, 0xb800 ; Set extra seg addr
  mov es, ax

  cld            ; Set flag DF = 0
  mov si, text
  mov di, 0

  mov cx, (number - text) / 2
  rep movsw

  mov bx, number
  mov ax, bx
  mov cx, 5
  mov si, 10

digit:
  xor dx, dx
  div si
  mov [bx], dx
  inc bx
  loop digit

  mov bx, number
  mov si, 4

show:
  mov al, [bx + si]
  add al, 0x30
  mov ah, 0x04
  mov [es:di], ax
  add di, 2
  dec si
  jns show

  mov word [es:di], 0x0744

infi: jmp near $

times 510 - ($ - $$) db 0
db 0x55, 0xaa

