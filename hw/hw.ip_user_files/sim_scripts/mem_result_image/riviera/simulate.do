onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+mem_result_image -L xpm -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.mem_result_image xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {mem_result_image.udo}

run -all

endsim

quit -force
