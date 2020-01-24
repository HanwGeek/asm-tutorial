  mov ax, cs 
  mov ss, ax 
  mov sp, 0x7c00

  mov ax, [cs:gdt_base + 0x7c00]
  mov dx, [cs:gdt_base + 0x7c00 + 0x02]
  mov bx, 16
  div bx 
  mov ds, ax                            ; Seg addr
  mov bx, dx                            ; Offset addr 

  ; #0 descriptor for nil
  mov dword [bx + 0x00], 0x00 
  mov dword [bx + 0x04], 0x00 

  ; #1 descriptor for code seg
  mov dword [bx + 0x08], 0x7c0001ff
  mov dword [bx + 0x0c], 0x00409800

  ; #2 descriptor for data seg 
  mov dword [bx + 0x10], 0x8000ffff
  mov dword [bx + 0x14], 0x0040920b

  ; #3 descriptor for stack seg 
  mov dword [bx + 0x18], 0x00007a00
  mov dword [bx + 0x1c], 0x00409600

  ; Init GDTR
  mov word [cs:gdt_size + 0x7c00], 31
  lgdt [cs:gdt_size + 0x7c00]

  in al, 0x92
  or al, 0000_0010B
  ; or al, 0x02
  out 0x92, al                          ; Activate A20

  cli                                   ; Turn off interrupt

  mov eax, cr0
  or eax, 1
  mov cr0, eax                          ; Activate protected mode

  jmp dword 0x0008:flush                ; Flush pipeline

  [bits 32]

flush:
  mov cx, 00000000000_10_000B
  mov ds, cx

  mov byte [0x00], 'P'
  mov byte [0x02], 'r'
  mov byte [0x04], 'o'
  mov byte [0x06], 't'
  mov byte [0x08], 'e'
  mov byte [0x0a], 'c'
  mov byte [0x0c], 't'
  mov byte [0x0e], ' '
  mov byte [0x10], 'm'
  mov byte [0x12], 'o'
  mov byte [0x14], 'd'
  mov byte [0x16], 'e'
  mov byte [0x18], ' '
  mov byte [0x1a], 'O'
  mov byte [0x1c], 'K'

  mov cx,00000000000_11_000B
  mov ss, cx
  mov esp, 0x7c00

  mov ebp, esp
  push byte '.'

  sub ebp, 4
  cmp ebp, esp 
  jnz ghalt 
  pop eax 
  mov byte [0x1e], al

ghalt:
  hlt  

; -------------------------------------------
gdt_size dw 0
gdt_base dd 0x00007e00      ; GDT phy addr

times 510 - ($ - $$) db 0
                     db 0x55, 0xaa  