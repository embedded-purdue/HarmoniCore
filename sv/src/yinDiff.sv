`include "../include/types.sv"
import types ::*;

module yinDiff (
    input clk,
    input rst,
    input acf_valid,
    input energy_valid,
    input [FFT_DW-1:0] acf_data,
    input [FFT_DW-1:0] energy_data,

    output logic diff_valid,
    output logic [FFT_DW-1:0] difference
);

    logic energy_0_captured;
    logic [FFT_DW-1:0] energy_0;

    always_ff @(posedge clk) begin
        if (rst) begin
            energy_0 <= 18'b0;
            energy_0_captured <= 1'b0;
            difference <= 18'b0;
            diff_valid <= 1'b0;
        end
        else if (energy_0_captured == 1'b0 && energy_valid == 1'b1) begin
            energy_0 <= energy_data;
            energy_0_captured <= 1'b1;
        end
        else if (energy_0_captured == 1'b1 && energy_valid == 1'b1 && acf_valid == 1'b1) begin
            difference <= energy_0 + energy_data - (acf_data << 1);
            diff_valid <= 1'b1;
        end
        else begin
            diff_valid <= 1'b0;
        end
    end

endmodule