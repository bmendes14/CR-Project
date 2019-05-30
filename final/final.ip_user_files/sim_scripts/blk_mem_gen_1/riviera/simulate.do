onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+blk_mem_gen_1 -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_2 -L work -L unisims_ver -L unimacro_ver -L secureip -O5 work.blk_mem_gen_1 work.glbl

do {wave.do}

view wave
view structure

do {blk_mem_gen_1.udo}

run -all

endsim

quit -force
