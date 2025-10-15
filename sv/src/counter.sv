
`timescale 1ns / 10ps

module counter #(
    parameter SIZE = 4
) (
    input logic clk,
    input logic n_rst,
    input logic clear,
    input logic count_enable,
    input logic [SIZE-1:0] rollover_val,
    output logic [SIZE-1:0] count,
    output logic flag
);

logic [SIZE-1:0] next_count;
logic next_flag;

always_ff @(posedge clk, negedge n_rst) begin : counter_ff
    if (!n_rst) begin
        count <= '0;
        flag <= 1'b0;
    end else begin
        count <= next_count;
        flag <= next_flag;
    end
end

always_comb begin : countLogic
    next_count = count;
    if (clear) next_count = '0;
    else if (count_enable) begin
        if (count >= rollover_val) next_count = 1;
        else                       next_count = count + 1;
    end
end

always_comb begin : flagLogic
    next_flag = flag;
    if (count == rollover_val) next_flag = 1'b1; // We want a cycle delay
    else                       next_flag = 1'b0;
end

endmodule
