vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu  -sv "+incdir+C:/Xilinix/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../include" \
"C:/Xilinix/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vlog -work xil_defaultlib  -incr -mfcu  -sv "+incdir+C:/Xilinix/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../include" \
"../../../src/FFTwrapper.sv" \
"../../../tb/FFTwrapper_tb.sv" \

vlog -work xil_defaultlib \
"glbl.v"

