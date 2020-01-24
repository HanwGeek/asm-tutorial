all: mbr.asm clock.asm
	nasm -f bin mbr.asm -o mbr.bin
	nasm -f bin clock.asm -o clock.bin
	nasm -f bin keyboard.asm -o keyboard.bin
	-rm FstMac.vhd
	dd if=/dev/zero of=disk.img bs=512 count=8192
	dd if=mbr.bin of=disk.img conv=notrunc
	dd if=keyboard.bin of=disk.img seek=100 conv=notrunc
	VBoxManage convertfromraw disk.img FstMac.vhd --format VHD --variant Fixed --uuid 19c1b190-94fd-45fd-bf34-4b6e0373c14b
	mv FstMac.vhd "/home/han/VirtualBox VMs/FstMac"