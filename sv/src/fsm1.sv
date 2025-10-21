//clone repo

module fsm1 #(
    parameter DATA_WIDTH = 18
)(
    input  logic                     clk,
    input  logic                     n_rst,
    input  logic [DATA_WIDTH-1:0]    data_in,
    input  logic                     empty,
    input  logic                     done,
    output logic                     rd_en,
    output logic                     block_full,
    output logic [DATA_WIDTH-1:0]    rdata_out
);

    // Internal registers
    logic [DATA_WIDTH-1:0] rdata_next, rdata_next1;
    logic [9:0] counter; // for 512 samples

    // Data pipeline (2-stage FF)
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            rdata_next1 <= '0;
            rdata_out   <= '0;
        end else begin
            rdata_next1 <= rdata_next;
            rdata_out   <= {14'b0, rdata_next}; // pad to 32-bit if needed
        end
    end

    // Read enable control
    always_comb begin
        if (!empty && !done)
            rd_en = 1;
        else begin
            rd_en = 0;
        end
    end

    // Counter + block_full control
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            counter <= '0;
            block_full <= 0;
        end else if (rd_en) begin
            if (counter < 511) begin
                counter <= counter + 1;
                block_full <= 0;
            end else begin
                counter <= 0;
                block_full <= 1;
            end
        end else begin
            block_full <= 0;
        end
    end

endmodule