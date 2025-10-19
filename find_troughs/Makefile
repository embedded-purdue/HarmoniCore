
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
	# Step 1: Source the Vivado environment settings script to set up paths.
	# This ensures all subsequent commands can be found.
	source C:/Xilinx/2025.1/Vivado/settings64.sh && \
	\
	# Step 2: Compile all SystemVerilog files with xvlog.
	# The order is critical: package first, then the design, then the testbench.
	xvlog -sv src/types.sv src/top.sv tb/top_tb.sv && \
	\
	# Step 3: Elaborate the design using the testbench as the top level.
	# The top module in your tb is 'top_tb'.
	# We create a simulation snapshot also named 'top_tb'.
	xelab -debug typical top_tb -s top_tb && \
	\
	# Step 4: Run the simulation on the snapshot and open the GUI.
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
