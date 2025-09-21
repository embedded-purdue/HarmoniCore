module main #(
    parameter WIDTH;
    parameter THRESHOLD;
    parameter FRAME_LENGTH
) 
(
    input logic clk, 
    input logic rst,
    input logic [WIDTH-1:0] next_yin,
    input logic next_idx,
    output logic [WIDTH-1:0] prev_yin, 
    output logic [WIDTH-1:0] curr_yin,
); 

endmodule

module counter #(
    parameter FRAME_LENGTH
)
(
    input logic clk,
    input logic rst,
    output logic frame_done,
    output logic [FRAME_LENGTH-1:0] count_out
)
endmodule

module find_min #(
    parameter WIDTH;
    parameter THRESHOLD;
)(
    input logic [WIDTH-1:0] prev_yin, 
    input logic [WIDTH-1:0] curr_yin,
    input logic [WIDTH-1:0] next_yin, 
    input logic frame_done,
    input logic [FRAME_LENGTH-1:0] count_out,
    output logic data_val,
    output logic trough,
    output logic min
)

endmodule