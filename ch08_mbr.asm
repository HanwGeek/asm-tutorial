app_lba_start equ 100

SECTION mbr align=16 vstart=0x7c00

  ; Set stack pointer
  mov ax, 0
  mov ss, ax
  mov sp, ax

  mov ax, [cs:phy_base]
  mov dx, [cs:phy_base + 0x02]
  mov bx, 16
  div bx                        ; Convert phy addr to ds reg
  mov ds, ax
  mov es, ax

  ; Read header of program
  xor di, di
  mov si, app_lba_start         ; Program start sector num
  xor bx, bx
  call read_hard_disk_0

  mov dx, [2]                   ; High 16 bits of program size
  mov ax, [0]                   ; Low 16 bits of program size
  mov bx, 512
  div bx                        ; Calulate `size mod 512`
  cmp dx, 0
  jnz l1
  dec ax

l1:
  cmp ax, 0
  jz direct

  push ds 
  mov ax, cx                    ; Move sector num left to counter

l2:
  mov ax, ds
  add ax, 0x20                  ; Next seg addr
  mov ds, ax

  xor bx, bx
  inc si,                       ; Next disk sector
  call read_hard_disk_0
  loop l2

  pop ds                        ; Restore data addr to program header

direct:
  

read_hard_disk_0:                                
  push ax                       ; Store temp var
  push bx
  push cx
  push dx

  mov dx, 0x1f2                 ; Disk io port
  mov al, 1                     ; Read 1 disk sector
  out ax, al

  inc dx
  mov ax, si                    ; Get high 16bit sector addr from si
  out dx, al                    ; LBA addr 0 - 7

  inc dx
  mov al, ah
  out dx, al                    ; LBA addr 8 - 15


  inc dx  
  mov ax, di                    ; Get low 16 bit sector addr from di
  out dx, al                    ; LBA addr 16 - 23

  inc dx 
  mov al, 0xe0                  ;
  or al, ah                     ; LBA addr 24 - 27
  out dx, al

  inc dx
  mov al, 0x20                  ; Command `Read`
  out dx, al

.waits:                         ; Wait disk preparing for data
  in al, dx
  and al, 0x88
  cmp al, 0x08
  jnz .waits

.readw:                         ; Read data by word to ds:bx
  in ax, dx
  mov [bx], ax
  add bx, 2
  loop .readw

  pop dx                        ; Restore temp var
  pop cx 
  pop bx 
  pop ax

  ret

phy_base dd 0x10000