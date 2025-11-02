transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+C:/Xilinix/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../include" -l xpm -l xil_defaultlib \
"C:/Xilinix/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vlog -work xil_defaultlib  -incr "+incdir+C:/Xilinix/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../include" -l xpm -l xil_defaultlib \
"../../../src/FFTwrapper.sv" \
"../../../tb/FFTwrapper_tb.sv" \

vlog -work xil_defaultlib \
"glbl.v"

