onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib MercuryZX1_opt

do {wave.do}

view wave
view structure
view signals

do {MercuryZX1.udo}

run -all

quit -force
