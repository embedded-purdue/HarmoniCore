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