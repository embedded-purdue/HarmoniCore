
`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;
`include "../include/divwrapper_if.vh"

module divwrapper (
    input logic clk, rst,
    divwrapper_if.div divif
);

    logic s_axis_divisor_tvalid, s_axis_dividend_tvalid, m_axis_dout_tvalid;
    logic signed [31:0] s_axis_divisor_tdata, s_axis_dividend_tdata, m_axis_dout_tdata;

    div your_instance_name (
        .aclk(clk),                                      // input wire aclk
        .aresetn(rst),                                    // input wire aresetn
        .s_axis_divisor_tvalid(s_axis_divisor_tvalid),    // input wire s_axis_divisor_tvalid
        .s_axis_divisor_tdata(s_axis_divisor_tdata),      // input wire [23 : 0] s_axis_divisor_tdata
        .s_axis_dividend_tvalid(s_axis_dividend_tvalid),  // input wire s_axis_dividend_tvalid
        .s_axis_dividend_tdata(s_axis_dividend_tdata),    // input wire [23 : 0] s_axis_dividend_tdata
        .m_axis_dout_tvalid(m_axis_dout_tvalid),          // output wire m_axis_dout_tvalid
        .m_axis_dout_tdata(m_axis_dout_tdata)             // output wire [31 : 0] m_axis_dout_tdata
    );

    always_comb begin : assignInputs
        s_axis_dividend_tvalid = divif.dividend_valid;
        s_axis_divisor_tvalid  = divif.divisor_valid;
        s_axis_dividend_tdata = {{(32-18){dividend_q[17]}}, dividend_q};
        s_axis_divisor_tdata  = {{(32-18){divisor_q[17]}}, divisor_q};

        divif.out_valid = m_axis_dout_tvalid;
        divif.out_data  = m_axis_dout_tdata[DW-1:0];
    end

endmodule