
setup:
	vivado -mode batch -source create_project.tcl
clean:
	rm -rf *.wdb *.jou *.log *.pb *.str
# %.sim:
# 	for %%f in (src/*.sv) do xvlog -sv %%f
# 	xvlog -sv ./tb/$*_tb.sv
# 	xvhdl ./HarmoniCore.gen/sources_1/ip/fft_core/sim/fft_core.vhd
# 	xelab -debug typical $*_tb -s $*_sim
# 	xsim $*_sim -gui -view ./waves/$*_sim.wcfg
%.sim:
	xvlog -sv src/*.sv
	xvlog -sv ./tb/$*_tb.sv
	xvhdl ./HarmoniCore.gen/sources_1/ip/fft_core/sim/fft_core.vhd
	xelab -debug typical $*_tb -s $*_sim
	xsim $*_sim -gui -view ./waves/$*_sim.wcfg

# This is the default target that will run when you just type "make"
# It depends on the 'sim' target.
all: sim

# Target to run the simulation for your 'top' module
sim:
	xvlog -sv src/types.sv src/top.sv tb/top_tb.sv && \
	xelab -debug typical top_tb -s top_tb && \
	xsim top_tb -gui

# A 'clean' target to remove generated simulation files
clean:
	@echo "Cleaning up simulation files..."
	@rm -rf xsim.dir *.log *.jou *.pb *.wdb xelab.log xvlog.log

.PHONY: all sim clean

cft:
	xvlog -sv src/types.sv src/top.sv tb/top_tb.sv

dft:
	xelab -debug typical top_tb -s top_tb

vft:
	xsim top_tb -gui
