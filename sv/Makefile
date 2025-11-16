
setup:
	vivado -mode batch -source create_project.tcl
clean:
	del -rf *.wdb *.jou *.log *.pb *.str
%.sim:
	for %%f in (src\*.sv) do xvlog -sv %%f
	xvlog -sv ./tb/$*_tb.sv
	xvhdl ./HarmoniCore.gen/sources_1/ip/fft_core/sim/fft_core.vhd ./HarmoniCore.gen/sources_1/ip/div_gen_0/sim/div_gen_0.vhd
	xelab -debug typical $*_tb -s $*_sim
	xsim $*_sim -gui -view ./waves/$*_sim.wcfg
# %.sim:
# 	xvlog -sv src/$*.sv
# 	xvlog -sv ./tb/$*_tb.sv
# 	xvhdl ./HarmoniCore.gen/sources_1/ip/fft_core/sim/fft_core.vhd
# 	xelab -debug typical $*_tb -s $*_sim
# 	xsim $*_sim -gui -view ./waves/$*_sim.wcfg
Template.sim:
	xvlog -sv ./tb/AFC_tb.sv ./src/*.sv 
	xvlog ./AFC.gen/sources_1/ip/rom/sim/*.v
	xvhdl ./AFC.gen/sources_1/ip/*/sim/*.vhd ./AFC.gen/sources_1/ip/fft_core/hdl/*.vhd \
	./AFC.gen/sources_1/ip/cmult/hdl/*.vhd ./AFC.gen/sources_1/ip/div/hdl/*.vhd
	xelab -debug typiccdal AFC_tb -s AFC_sim -L blk_mem_gen_v8_4_9 -L unisims_ver
	xsim AFC_sim -gui -view /home/varun/FPGAProjects/R2FFT/AFC/waves/AFC_sim.wcfg
.PHONY: AFC.sim

FFTwrapper_sim:
	source C:/Xilinx/2025.1/Vivado/settings64.sh && \
	xvlog -sv src/*.sv include/*.sv && \
	xvlog -sv tb/FFTwrapper_tb.sv && \
	xvhdl HarmoniCore.gen/sources_1/ip/fft_core/sim/fft_core.vhd && \
	xelab -debug typical FFTwrapper_tb -s FFTwrapper_tb && \
	xsim FFTwrapper_tb -gui -view waves/FFTwrapper_sim.wcfg

FFTwrapper:
	xvlog -sv src/FFTwrapper.sv include/FFTwrapper_if.vh && \
	xvlog -sv tb/FFTwrapper_tb.sv && \
	xvhdl HarmoniCore.gen/sources_1/ip/fft_core/sim/fft_core.vhd && \
	xelab -debug typical FFTwrapper_tb -s FFTwrapper_tb && \
	xsim FFTwrapper_tb -gui -view waves/FFTwrapper_sim.wcfg

sim:
	xvlog -sv include/types.sv src/find_trough.sv tb/find_trough_tb.sv && \
	xvhdl ./HarmoniCore.gen/sources_1/ip/fft_core/sim/fft_core.vhd
	xelab -debug typical find_trough_tb -s find_trough_tb && \
	xsim find_trough_tb -gui -view ./waves/find_trough_sim.wcfg

int:
	xvlog -sv include/types.sv src/interpolater.sv tb/interpolater_tb.sv && \
	xvhdl ./HarmoniCore.gen/sources_1/ip/fft_core/sim/fft_core.vhd
	xelab -debug typical interpolater_tb -s interpolater_tb && \
	xsim interpolater_tb -gui -view ./waves/interpolater_sim.wcfg