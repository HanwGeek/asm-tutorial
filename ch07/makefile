all: mbr.asm
	nasm -f bin mbr.asm -o mbr.bin
	dd if=/dev/zero of=mbr.img bs=1M count=4
	dd if=mbr.bin of=mbr.img conv=notrunc
	VBoxManage convertfromraw mbr.img FstMac.vhd --format VHD --variant Fixed --uuid 19c1b190-94fd-45fd-bf34-4b6e0373c14b
	mv FstMac.vhd "/home/han/VirtualBox VMs/FstMac"