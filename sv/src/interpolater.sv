`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*; 
`include "../include/interpolater_if.vh"

module interpolater (interpolater_if.interp intif
  );

  logic [23:0] denom_tdata, numer_tdata, quotient_tdata;
  logic denom_tvalid, denom_tready, numer_tvalid,
        numer_tready, quotient_tvalid;

  logic signed [DW + 1:0] ex_max, ex_min, denom_temp, numer_temp;
  assign ex_max = MAX_VAL;
  assign ex_min = MIN_VAL;

  always_comb begin
    denom_temp = (intif.prev_yin - (intif.curr_yin << 1) + intif.next_yin);
    
    if (denom_temp > ex_max)
    begin
        denom_temp = ex_max;
    end
    else if (denom_temp < ex_min)
    begin
        denom_temp = ex_min;
    end
    else
    begin
        denom_temp = denom_temp;
    end

    denom_tdata = {6'b0, denom_temp[17:0]};

    if (numer_temp > ex_max)
    begin
        numer_temp = ex_max;
    end
    else if (numer_temp < ex_min)
    begin
        numer_temp = ex_min;
    end
    else
    begin
        numer_temp = denom_temp;
    end

    numer_tdata = {6'b0, numer_temp[17:0]};
    
  end

  // div_gen_0 divide (
  //   .aclk(clk),                                      // input wire aclk
  //   .s_axis_divisor_tvalid({6'b0, intif.prev_yin}),    // input wire s_axis_divisor_tvalid
  //   .s_axis_divisor_tready(s_axis_divisor_tready),    // output wire s_axis_divisor_tready
  //   .s_axis_divisor_tdata({6'b0, intif.prev_yin}),      // input wire [23 : 0] s_axis_divisor_tdata
  //   .s_axis_dividend_tvalid(s_axis_dividend_tvalid),  // input wire s_axis_dividend_tvalid
  //   .s_axis_dividend_tready(s_axis_dividend_tready),  // output wire s_axis_dividend_tready
  //   .s_axis_dividend_tdata(s_axis_dividend_tdata),    // input wire [23 : 0] s_axis_dividend_tdata
  //   .m_axis_dout_tvalid(m_axis_dout_tvalid),          // output wire m_axis_dout_tvalid
  //   .m_axis_dout_tdata(m_axis_dout_tdata)            // output wire [23 : 0] m_axis_dout_tdata
  // );


  // INST_TAG_END ------ End INSTANTIATION Template ---------

  // You must compile the wrapper file div_gen_0.v when simulating
  // the core, div_gen_0. When compiling the wrapper file, be sure to
  // reference the Verilog simulation library.


endmodule