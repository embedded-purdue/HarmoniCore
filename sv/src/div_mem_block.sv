
`timescale 1ns / 1ps
`include "../include/types.sv"

module div_mem_block
import types::*;
(
    input logic clk,
    input logic nRST,
    input logic rollover_flag,
    input logic [DW-1:0] total,
    input logic [DW-1:0] count,
    input logic [DW-1:0] delayed_diff,
    output logic [17:0] final_out
);
    // DIV OUTPUT
    logic [23:0] result_data;
    logic result_valid;

    // DETERMINE WHAT TO SEND INTO DIV
    logic divFlag;
    always_ff @(posedge clk, negedge nRST) begin : cummeanDone
        if (~nRST)              divFlag <= 1'b0;
        else if (rollover_flag) divFlag <= 1'b1;
    end

    // DETERMINE BRAM READ/WRITE
    logic memFlag;
    always_ff @(posedge clk, negedge nRST) begin : cummeanDivDone // one cycle delay indicates switch from write to read
        if (~nRST)                         memFlag <= 1'b0;
        else if (divFlag && ~result_valid) memFlag <= 1'b1;
    end

    // WRITE STACK POINTER LOGIC
    logic [10:0] sp_w; // 11-bit write depth
    always_ff @(posedge clk, negedge nRST) begin : spWriteLogic
        if (~nRST)             sp_w <= '0;
        else if (result_valid) sp_w <= sp_w + 8;
    end

    // READ STACK POINTER LOGIC
    logic [10:0] sp_r;
    always_ff @(posedge clk, negedge nRST) begin : spReadLogic
        if (~nRST)        sp_r <= '0;
        else if (memFlag) sp_r <= sp_r + 8;
    end

    // STORE CUMMEAN INTO BLOCK RAM
    logic [DW-1:0] a_in, b_in, a_out, b_out;
    logic [10:0] a_addr, b_addr;
    logic a_wr, b_wr;
    always_ff @(posedge clk, negedge nRST) begin : cummeanStore
        if (~nRST) begin
            a_in = '0;
            b_in = '0;
            a_wr = 1'b0;
            b_wr = 1'b0;
        end
        else if (memFlag) begin // read data
            a_in = '0;
            b_in = '0;
            a_addr = sp_r - 8;
            b_addr = sp_r - 4;
            a_wr = 1'b0;
            b_wr = 1'b0;
        end
        else if (result_valid) begin // write data
            a_in = result_data[DW-1:0];
            b_in = delayed_diff;
            a_addr = sp_w - 8;
            b_addr = sp_w - 4;
            a_wr = 1'b1;
            b_wr = 1'b1;
        end
    end

    // TRUE DUAL PORT BLOCK RAM MODULE (find ports in .srcs/blk_mem/blk_mem.xci/boundary)
    blk_mem block_ram (
        .clka(clk),
        .ena(1'b1),
        .wea(a_wr),
        .addra(a_addr),
        .dina(a_in),
        .douta(a_out),
        .clkb(clk),
        .enb(1'b1),
        .web(b_wr),
        .addrb(b_addr),
        .dinb(b_in),
        .doutb(b_out)
    );

    // DIV INPUT (COUNT/TOTAL or MEM)
    logic [23:0] dividend_data, divisor_data; // aligns 18 to the nearest byte
    logic dividend_valid, divisor_valid;
    always_ff @(posedge clk, negedge nRST) begin : divInput
        if(~nRST) begin
            dividend_valid <= 1'b0;
            divisor_valid <= 1'b0;
            dividend_data <= '0;
            divisor_data <= '0;
        end
        else if (divFlag) begin
            dividend_valid <= 1'b1;
            divisor_valid <= 1'b1;
            dividend_data <= {'0, a_out};
            divisor_data <= {'0, b_out};
        end
        else if (count >= MIN_VAL - 1) begin
            dividend_valid <= 1'b1;
            divisor_valid <= 1'b1;
            dividend_data <= {'0, total};
            divisor_data <= {'0, count};
        end
    end

    // DIV MODULE (21 cycle latency) (find ports in .srcs/div/div.xci/boundary)
    div_gen divider (
        .aclk(aclk),
        .s_axis_dividend_tvalid(dividend_valid),
        .s_axis_dividend_tdata(dividend_data),
        .s_axis_divisor_tvalid(divisor_valid),
        .s_axis_divisor_tdata(divisor_data),
        .m_axis_dout_tvalid(result_valid),
        .m_axis_dout_tdata(result_data)
    );

    // ASSIGN FINAL OUTPUT
    always_ff @(posedge clk, negedge nRST) begin : yinvalLogic
        if (~nRST)                        final_out <= '0;
        else if (memFlag && result_valid) final_out <= result_data[DW-1:0];
    end

endmodule