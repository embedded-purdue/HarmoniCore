`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*; 
`include "../include/interpolater_if.vh"

module interpolater (
    interpolater_if.interp intif
  );

  logic [23:0] denom_tdata, numer_tdata, quotient_tdata;
  logic denom_tvalid, denom_tready, numer_tvalid,
        numer_tready, quotient_tvalid;

  always_comb begin
    denom_tdata = (intif.prev_yin - (intif.curr_yin << 1) + intif.next_yin);
    
    
  end


  // INST_TAG_END ------ End INSTANTIATION Template ---------

  // You must compile the wrapper file div_gen_0.v when simulating
  // the core, div_gen_0. When compiling the wrapper file, be sure to
  // reference the Verilog simulation library.


endmodule