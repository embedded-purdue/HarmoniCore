`timescale 1ns / 10ps

module counter #(
    parameter SIZE = 4
) (
    input logic clk,
    input logic n_rst,
    input logic clear,
    input logic count_enable,
    input logic [SIZE - 1: 0] rollover_val,
    output logic [SIZE - 1: 0] count_out,
    output logic rollover_flag
);

logic [SIZE - 1:0] next;
logic flag_next;

always_ff @(posedge clk, negedge n_rst) begin : counter_ff
    if (!n_rst) begin
        count_out <= '0;
        rollover_flag <= 1'b0;
    end else begin
        count_out <= next;
        rollover_flag <= flag_next;
    end
end

always_comb begin : counter_comb
    if(clear) begin
        next = '0;
        flag_next = 1'b0;
    end else if (count_enable) begin
        if (count_out >= rollover_val) begin
            next = 1;
            flag_next = 1'b0;
        end else begin
            next = count_out + 1;
            if (next == rollover_val) begin
                flag_next = 1'b1;
            end else begin
                flag_next = 1'b0;
            end
        end
    end else begin
        next = count_out;
        flag_next = rollover_flag;
    end
end

endmodule
