# Set up a new project
create_project HarmoniCore ./ -part xc7a25tcsg325-2 -force
#create_project AFC ./ -part xc7k325tffg900-2 -force

set_property SIMULATOR_LANGUAGE Verilog [current_project]
set FFT_DW 18
set FFT_LEN 1024

create_ip -name xfft -vendor xilinx.com -library ip -version 9.1 -module_name fft_core
set_property CONFIG.channels 1 [get_ips fft_core]
set_property CONFIG.transform_length $FFT_LEN [get_ips fft_core]
set_property CONFIG.target_clock_frequency 250 [get_ips fft_core]
set_property CONFIG.target_data_throughput 1 [get_ips fft_core]
set_property CONFIG.phase_factor_width 16 [get_ips fft_core]
set_property CONFIG.scaling_options Block_Floating_Point [get_ips fft_core]
set_property CONFIG.aresetn true [get_ips fft_core]
set_property CONFIG.xk_index true [get_ips fft_core]
set_property CONFIG.Input_Width $FFT_DW [get_ips fft_core]
set_property CONFIG.Cyclic_Prefix_Insertion false [get_ips fft_core]
set_property CONFIG.Output_Ordering natural_order [get_ips fft_core]
set_property CONFIG.Implementation_Options radix_2_burst_io [get_ips fft_core]
generate_target all [get_ips fft_core]

add_files constraints.xdc
set_property FILE_TYPE XDC [get_files constraints.xdc]
set_property top AFC [current_fileset] 

set include_path "./include"
foreach file [glob -directory $include_path *] {
     add_files $file    
}
set src_path "./src"
foreach file [glob -directory $src_path *] {
     add_files $file    
}
set tb_path "./tb"
foreach file [glob -directory $tb_path *] {
     add_files $file    
}
set wav_path "./waves"
foreach file [glob -directory $wav_path *] {
     add_files $file    
}
