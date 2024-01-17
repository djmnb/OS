%.bin: %.S
	nasm -f bin $< -o $@

%.img: mbr.bin loader.bin
	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat  $@
	dd if=mbr.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=loader.bin of=$@ bs=512 count=1 seek=2 conv=notrunc

run: master.img
	LTDL_LIBRARY_PATH=/usr/local/bochs/lib/bochs/plugins \
	BXSHARE=/usr/local/bochs/share/bochs \
	bochs -q -f bochsrc

debug: master.img

	LTDL_LIBRARY_PATH=/usr/local/bochs-gdb/lib/bochs/plugins \
	BXSHARE=/usr/local/bochs-gdb/share/bochs \
	bochs-gdb -q -f bochsrc-gdb
