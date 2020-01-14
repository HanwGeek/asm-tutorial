
jmp near start

message db '1 + 2 + 3 + ... + 100 = '

start:
  mov ax, 0x7c0
  mov ds, ax

  mov ax, 0xb800
  mov es, ax

  mov si, message
  mov di, 0
  mov cx, start - message

showm:
  mov al, [si]
  mov [es:di], al
  inc di
  mov byte [es:di], 0x07
  inc di
  inc si
  loop showm

  xor ax, ax
  mov cx, 1

sum:                  ; Sum 1 to 100
  add ax, cx
  inc cx
  cmp cx, 100
  jle sum

  xor cx, cx
  mov ss, cx          ; Set stack seg   = 0
  mov sp, cx          ; Set stack point = 0

  mov bx, 10
  xor cx, cx

number:
  inc cx
  xor dx, dx
  div bx
  or dl, 0x30         ; `or` to add 0x30
  push dx
  cmp ax, 0
  jne number

shown:
  pop dx
  mov [es:di], dl
  inc di
  mov byte [es:di], 0x07
  inc di
  loop shown

jmp near $

times 510 - ($ - $$) db 0
db 0x55, 0xaa




