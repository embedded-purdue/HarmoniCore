module main #(
    parameter WIDTH,
    parameter THRESHOLD,
    parameter FRAME_LENGTH,
    parameter MIN_PERIOD
) 
(
    input logic clk, 
    input logic n_rst,
    input logic [WIDTH-1:0] next_yin,
    input logic next_idx,
    output logic [WIDTH-1:0] prev_yin, 
    output logic [WIDTH-1:0] curr_yin,
    output logic trough,
    output logic min
); 

    logic [$clog2(FRAME_LENGTH)-1:0] count_out;
    logic frame_done;
    
    counter #(.FRAME_LENGTH(FRAME_LENGTH)) count (.clk(clk),
        .n_rst(n_rst),
        .count_out(count_out),
        .frame_done(frame_done)
    );

    logic [WIDTH-1:0] tau, idx;
    logic trough_found;

    find_trough #(.WIDTH(WIDTH),
    .FRAME_LENGTH(FRAME_LENGTH),
    .TROUGH_THRESHOLD(THRESHOLD),
    .MIN_PERIOD(MIN_PERIOD)) f_trough (.clk(clk),
    .n_rst(n_rst),
    .frame_done(frame_done),
    .next_yin(next_yin),
    .count_out(count_out),
    .tau(tau),
    .idx(idx),
    .trough_found(trough_found));

endmodule

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


module find_trough #(
    parameter WIDTH,
    parameter FRAME_LENGTH,
    parameter TROUGH_THRESHOLD,
    parameter MIN_PERIOD
)(
    input logic clk, n_rst, frame_done, // or rst
    input logic [WIDTH-1:0] next_yin,
    input logic [$clog2(FRAME_LENGTH)-1:0] count_out,
    output logic [WIDTH-1:0] tau,        // not sure how big the width will be
    output logic [WIDTH-1:0] idx,
    output logic trough_found
);

    logic [WIDTH-1:0] next_tau;
    logic [WIDTH-1:0] prev_yin, curr_yin;
    logic [WIDTH-1:0] min, next_min, smallest_min, next_smallest_min;
    logic [WIDTH-1:0] min_index, next_min_index;
    logic [$clog2(FRAME_LENGTH)-1:0] trough, next_trough;
    logic next_trough_found;

    always_ff @(posedge clk) begin : Controller
        if (~n_rst) begin    // or rst 
            min_index    <= 0;
            trough       <= 0;
            trough_found <= 0;

            smallest_min <= 10;  // some large value

            tau          <= 0;
            curr_yin     <= 0;
            prev_yin     <= 0;

        end
        else begin
            trough       <= next_trough;
            trough_found <= next_trough_found;
            
            smallest_min <= next_smallest_min;
            min_index    <= next_min_index;

            curr_yin     <= next_yin;
            prev_yin     <= curr_yin;
            tau          <= next_tau;

        end
    end

    always_comb begin : next_xxx_logic
        next_tau = (trough_found) ? trough + MIN_PERIOD : min + MIN_PERIOD;
        next_trough_found = trough_found;
        next_trough = trough;
        next_min = min; 
        next_smallest_min = smallest_min;
        // check that curr_yin is a trough and is less than the threshold
        if ((curr_yin < prev_yin) & (curr_yin <= next_yin) & (curr_yin < TROUGH_THRESHOLD) & (~trough_found)) begin
            next_trough = count_out - 1;        // count_out - 1 because count_out is the next_yin index
            next_trough_found = 1'b1;           // we found trough, set flag high

        end

        // find the minimum
        if ((curr_yin < next_yin) & (curr_yin < smallest_min) & (~trough_found)) begin      
            next_min_index = count_out - 1;       // count_out - 1 because count_out is the next_yin index
            next_smallest_min = curr_yin;         // update minimum val

            // what about if the last yin_value is the smallest?
        end

        // if frame_done is high, we have finished the window. reset stuff
        if (frame_done) begin
            next_smallest_min = 10;  // some large number
            next_min_index    =  0;
            next_trough       =  0;
            next_trough_found =  0;
        end
    end

    assign idx = tau - MIN_PERIOD;  // give to interpolation 


endmodule