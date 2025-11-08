`timescale 1ns / 1ps

`include "types.sv"

module datapath_1
    import types::*;
(
    input logic clear,
    input logic read_en,
    input logic [DW-1:0] data_in,
    input logic clk,
    input logic rst,

    output logic [$clog2(HOP_LEN)-1:0] count_out, 
    output logic hop_flag, 
    output logic [DW-1:0] data_out
);

    // Internal signals
    logic [DW-1:0] data_in2;
    logic [$clog2(HOP_LEN)-1:0] next_count;
    logic next_flag;

    // Sequential
    always_ff @(posedge clk) begin
        if (rst) begin
            count_out <= '0;
            hop_flag  <= '0;
            data_in2  <= '0;
            data_out  <= '0;
        end
        else begin
            count_out <= next_count;
            hop_flag  <= next_flag;
            
            // Delay by 2 cycles
            data_in2 <= data_in;
            data_out <= data_in2;
        end
    end

    // Combinational
    always_comb begin
        // Default
        next_count = count_out;
        next_flag  = 1'b0;

        if (clear) begin
            // Clear is highest priority
            next_count = '0;
            next_flag  = 1'b0;
        end 
        else if (read_en) begin
            if (count_out == HOP_LEN - 1) begin
                next_count = '0;
                next_flag  = 1'b1;
            end 
            else begin
                next_count = count_out + 1;
                next_flag  = 1'b0;
            end
        end
    end

endmodule