onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib mem_source_image_opt

do {wave.do}

view wave
view structure
view signals

do {mem_source_image.udo}

run -all

quit -force
