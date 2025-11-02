`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;
`include "../include/interpolater_if.vh"

module interpolater (
    input logic clk, nrst,
    interpolater_if.interp intif
);

logic [23:0] denom_tdata, numer_tdata, quotient_tdata;
logic denom_tvalid, denom_tready, numer_tvalid,
      numer_tready, quotient_tvalid;

always_comb begin : 
  denom_tdata = (intif.prev_yin - (intif.curr_yin << 1) + intif.next_yin)
  if ()
  
end


assign ;

div_gen_0 divide (
  .aclk(clk),                                      // input wire aclk
  .s_axis_divisor_tvalid({6'b0, intif.prev_yin}),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tready(s_axis_divisor_tready),    // output wire s_axis_divisor_tready
  .s_axis_divisor_tdata({6'b0, intif.prev_yin}),      // input wire [23 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(s_axis_dividend_tvalid),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tready(s_axis_dividend_tready),  // output wire s_axis_dividend_tready
  .s_axis_dividend_tdata(s_axis_dividend_tdata),    // input wire [23 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(m_axis_dout_tvalid),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(m_axis_dout_tdata)            // output wire [23 : 0] m_axis_dout_tdata
);


// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file div_gen_0.v when simulating
// the core, div_gen_0. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.


endmodule