module counter #(
    parameter FRAME_LENGTH // integer not bit
)
(
    input  logic clk,
    input  logic n_rst,
    output logic [$clog2(FRAME_LENGTH)-1:0] count_out, 
    output logic frame_done
);

    logic [$clog2(FRAME_LENGTH)-1:0] next_count;
    logic next_frame_done;

    always_ff @(posedge clk) begin 
        if (~n_rst) begin
            count_out   <= '0;
            frame_done  <= 1'b0;
        end else begin
            count_out   <= next_count;
            frame_done  <= next_frame_done;
        end
    end

    always_comb begin 
        if (count_out == FRAME_LENGTH) begin
            next_count        = '0;
            next_frame_done   = 1'b1;
        end else begin
            next_count        = count_out++;
            next_frame_done   = 1'b0;
        end
    end

endmodule