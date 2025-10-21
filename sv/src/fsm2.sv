module fsm2 #(
    parameter DATA_WIDTH = 18
)(
    input  logic                     clk,
    input  logic                     n_rst,
    input  logic [DATA_WIDTH-1:0]    block_0_data,
    input  logic [DATA_WIDTH-1:0]    block_1_data,
    input  logic [DATA_WIDTH-1:0]    block_2_data,
    input  logic [DATA_WIDTH-1:0]    block_3_data,
    input  logic                     block_full,
    output logic [DATA_WIDTH-1:0]    block_data,
    output logic                     fft_ready,
    output logic                     done
);

    logic [1:0] counter_sel;  
    logic [9:0] counter_div;  

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            counter_sel <= '0;
            counter_div <= '0;
        end 
        else if (block_full) begin
            if (counter_div < 10'd511) begin
                counter_div <= counter_div + 1;
            end 
            else begin
                counter_div <= 0;
                if (counter_sel == 2'b11)
                    counter_sel <= 0;
                else
                    counter_sel <= counter_sel + 1;
            end
        end
    end

    always_comb begin
        case (counter_sel)
            2'b00: block_data = block_3_data;
            2'b01: block_data = block_2_data;
            2'b10: block_data = block_1_data;
            2'b11: block_data = block_0_data;
            default: block_data = '0;
        endcase
    end

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            fft_ready <= 0;
            done      <= 0;
        end 
        else if ((counter_sel == 2'b11) && (counter_div == 10'd511)) begin
            fft_ready <= 1;
            done      <= 1;
        end 
        else begin
            fft_ready <= 0;
            done      <= 0;
        end
    end

endmodule