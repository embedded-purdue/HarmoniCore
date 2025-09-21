module main #(
    parameter WIDTH;
    parameter THRESHOLD;
    parameter FRAME_LENGTH
) 
(
    input logic clk, rst,
    input logic [WIDTH-1:0] next_yin,
    input logic next_idx,
    output logic [WIDTH-1:0] prev_yin, curr_yin,
); 

endmodule