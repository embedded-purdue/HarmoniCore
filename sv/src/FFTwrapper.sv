`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;
`include "../include/FFTwrapper_if.vh"

module FFTwrapper (
    input logic clk, rst,
    FFTwrapper_if.fft fftif
);


    logic [7 : 0] s_axis_config_tdata;
    logic s_axis_config_tvalid;
    logic s_axis_config_tready;
    logic [47: 0] s_axis_data_tdata;
    logic s_axis_data_tvalid;
    logic s_axis_data_tready;
    logic s_axis_data_tlast;
    logic [47: 0] m_axis_data_tdata;
    logic [23 : 0] m_axis_data_tuser;
    logic m_axis_data_tvalid;
    logic m_axis_data_tready;
    logic m_axis_data_tlast;
    logic [7 : 0] m_axis_status_tdata;
    logic m_axis_status_tvalid;
    logic m_axis_status_tready;
    logic event_frame_started;
    logic event_tlast_unexpected;
    logic event_tlast_missing;
    logic event_status_channel_halt;
    logic event_data_in_channel_halt;
    logic event_data_out_channel_halt;


    fft_core your_instance_name (
    .aclk(clk),                                                // input wire aclk
    .aresetn(rst),                                          // input wire aresetn
    .s_axis_config_tdata(s_axis_config_tdata),                  // input wire [7 : 0] s_axis_config_tdata
    .s_axis_config_tvalid(s_axis_config_tvalid),                // input wire s_axis_config_tvalid
    .s_axis_config_tready(s_axis_config_tready),                // output wire s_axis_config_tready
    .s_axis_data_tdata(s_axis_data_tdata),                      // input wire [63 : 0] s_axis_data_tdata
    .s_axis_data_tvalid(s_axis_data_tvalid),                    // input wire s_axis_data_tvalid
    .s_axis_data_tready(s_axis_data_tready),                    // output wire s_axis_data_tready
    .s_axis_data_tlast(s_axis_data_tlast),                      // input wire s_axis_data_tlast
    .m_axis_data_tdata(m_axis_data_tdata),                      // output wire [63 : 0] m_axis_data_tdata
    .m_axis_data_tuser(m_axis_data_tuser),                      // output wire [23 : 0] m_axis_data_tuser
    .m_axis_data_tvalid(m_axis_data_tvalid),                    // output wire m_axis_data_tvalid
    .m_axis_data_tready(m_axis_data_tready),                    // input wire m_axis_data_tready
    .m_axis_data_tlast(m_axis_data_tlast),                      // output wire m_axis_data_tlast
    .m_axis_status_tdata(m_axis_status_tdata),                  // output wire [7 : 0] m_axis_status_tdata
    .m_axis_status_tvalid(m_axis_status_tvalid),                // output wire m_axis_status_tvalid
    .m_axis_status_tready(m_axis_status_tready),                // input wire m_axis_status_tready
    .event_frame_started(event_frame_started),                  // output wire event_frame_started
    .event_tlast_unexpected(event_tlast_unexpected),            // output wire event_tlast_unexpected
    .event_tlast_missing(event_tlast_missing),                  // output wire event_tlast_missing
    .event_status_channel_halt(event_status_channel_halt),      // output wire event_status_channel_halt
    .event_data_in_channel_halt(event_data_in_channel_halt),    // output wire event_data_in_channel_halt
    .event_data_out_channel_halt(event_data_out_channel_halt)  // output wire event_data_out_channel_halt
    );

    always_comb begin
        s_axis_config_tdata = {7'b0, (~fftif.ifft)};
        s_axis_config_tvalid = fftif.ifft_en;
        fftif.ifft_ready = s_axis_config_tready;
        s_axis_data_tdata = {6'b0, fftif.in_im, 6'b0, fftif.in_real};
        s_axis_data_tvalid = fftif.in_en;
        fftif.in_ready = s_axis_data_tready;
        s_axis_data_tlast = fftif.in_last;


        //{LEFTOVER{1'b0}, fftif.out_im, LEFTOVER{1'b0}, fftif.out_real} = m_axis_data_tdata;
        fftif.out_im = m_axis_data_tdata[18+24-1:24];
        fftif.out_real = m_axis_data_tdata[FFT_DW-1:0];
        {fftif.blk_exp_sample, fftif.xk_index} = m_axis_data_tuser;
        fftif.out_valid = m_axis_data_tvalid;
        m_axis_data_tready = fftif.out_en;
        fftif.out_last = m_axis_data_tlast;
        fftif.blk_exp = m_axis_status_tdata;
        fftif.blk_exp_valid = m_axis_status_tvalid;
        m_axis_status_tready = fftif.blk_exp_en;
    end

endmodule

/*

Input: nifft, nifft_en, in_real, in_im, in_en, in_last, out_en, blk_exp_en


Output: nifft_ready, in_ready, out_real, out_im, xk_index, blk_exp_sample, 
out_valid, out_last, blk_exp, blk_exp_valid

*/
