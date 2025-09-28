
setup:
	vivado -mode batch -source create_project.tcl
clean:
	rm -rf *.wdb *.jou *.log *.pb *.str
%.sim:
	for %%f in (src\*.sv) do xvlog -sv %%f
	xvlog -sv ./tb/$*_tb.sv
	xvhdl ./HarmoniCore.gen/sources_1/ip/fft_core/sim/fft_core.vhd
	xelab -debug typical $*_tb -s $*_sim
	xsim $*_sim -gui -view ./waves/$*_sim.wcfg
Template.sim:
	xvlog -sv ./tb/AFC_tb.sv ./src/*.sv 
	xvlog ./AFC.gen/sources_1/ip/rom/sim/*.v
	xvhdl ./AFC.gen/sources_1/ip/*/sim/*.vhd ./AFC.gen/sources_1/ip/fft_core/hdl/*.vhd \
	./AFC.gen/sources_1/ip/cmult/hdl/*.vhd ./AFC.gen/sources_1/ip/div/hdl/*.vhd
	xelab -debug typical AFC_tb -s AFC_sim -L blk_mem_gen_v8_4_9 -L unisims_ver
	xsim AFC_sim -gui -view /home/varun/FPGAProjects/R2FFT/AFC/waves/AFC_sim.wcfg
.PHONY: AFC.sim