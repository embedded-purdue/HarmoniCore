`timescale 1ns / 1ps
`include "../include/types.sv"
import types::*;
`include "../include/find_trough_if.vh"

module find_trough (
    input logic clk, rst,
    find_trough_if trif
);

    /*
        Updates:
        1. Changed always_comb block to include edge case where last sample is the min. value
        2. Changed synchronous "reset" to be at the first (zeroth) sample
        3. Changed constants/parameters to the ones in ...\include\types.sv
        4. Added new, curr, prev yin values
        5. IDK if there's a better way to track the current index other than registering. count_out - 1 doesn't work because combinational is "too fast", so I ran into cases
           where the index would be 1 greater than expected.
            
        
        Questions:
        1. Can we get negative numbers? 
        2. For trough_index, next_trough_index, I did log2(2048) to get 11 (DECIMALBITS)
    */

    parameter MAX_YIN_VAL = 10000;
    parameter TEMP_FRAME_SIZE = FRAME_LEN - 2028;

    logic signed [DW-1:0] next_yin, curr_yin, prev_yin, n_min_yin, n_tau, min_yin;
    logic [DECIMALBITS-1:0] curr_yin_ind, n_ind, n_min_ind, trough_index, n_trough_index;
    logic delay_reset, n_delay_reset, en, n_trough_found, trough_found, p_trough_found, min_found, n_min_found;

    // always_ff @(posedge clk, negedge nrst) begin : registers
    always_ff @(posedge clk) begin : registers
        // if (~nrst) begin
        //     next_yin <= 0;
        //     curr_yin <= 0;
        //     prev_yin <= 0;
            
        //     trif.idx <= 0;
        //     min_yin <= MAX_YIN_VAL;
        
        //     trough_index <= 0;
        //     trough_found <= 0;
        //     p_trough_found <= 0;

        //     delay_reset <= 0;
        //     en <= 0;

        //     trif.tau <= 0;

        //     min_found <= 0;
            
        // end
        // else begin
        if (rst) begin
            next_yin <= 0;
            curr_yin <= 0;
            prev_yin <= 0;
            
            trif.idx <= 0;
            min_yin <= MAX_YIN_VAL;
        
            trough_index <= 0;
            trough_found <= 0;
            p_trough_found <= 0;

            delay_reset <= 0;
            en <= 0;

            trif.tau <= 0;

            min_found <= 0;
        end
        else begin
            en <= trif.enable;
            delay_reset <= n_delay_reset;
            if (delay_reset) begin
                next_yin <= 0;
                curr_yin <= 0;
                prev_yin <= 0;
                min_yin <= MAX_YIN_VAL;
                trough_index <= 0;
                trough_found <= 0;
                p_trough_found <= 0;
                trif.tau <= 0;
                min_found <= 0;
            end
            else begin
                if (trif.enable) begin
                    next_yin <= trif.yin_in;
                end
                curr_yin <= next_yin;
                prev_yin <= curr_yin;
                trif.idx <= n_ind;
                min_yin <= n_min_yin;
                trough_index <= n_trough_index;
                trough_found <= n_trough_found;
                p_trough_found <= trough_found;
                trif.tau <= n_tau;
                min_found <= n_min_found;
                
            end
        end
    end
    // end

    // COUNTER
    /*
        Rather than making an entire separate counter module, I thought itd be easier to implement within this module,
        since the logic is fairly simple
        If enable is high and the frame is not at the last sample, increment the counter on every clock edge
    */
    logic frame_done, n_frame_done;
    logic [DECIMALBITS-1:0] n_yin_ind;
    always_ff @(posedge clk) begin : counter
        // if (~nrst) begin
        //     n_yin_ind <= 0;
        //     frame_done <= 0;
        // end
        // else begin
        if (rst) begin
            n_yin_ind <= 0;
            frame_done <= 0;
        end
        else begin
            frame_done <= n_frame_done;
            if (delay_reset)
                n_yin_ind <= 0;
            else if (en & ~frame_done)
                n_yin_ind <= n_yin_ind + 1;
        end
    end
    assign n_frame_done = (n_yin_ind == (TEMP_FRAME_SIZE - 2)) ? 1'b1: 1'b0; // used to pulse the frame_done flag when at the last sample index
    assign trif.frame_done = delay_reset;

    // Find the minimum logic
    /*
        Use the next_yin value and compare it to the current smallest yin value (min_yin)
        - When trif.count_out == 0, it is the first sample, and we want that to be our default minimum
        - When trif.count is not 0, do an actual comparison if the next_yin is less than min_yin
    */
    always_comb begin : find_min
        n_min_ind = trif.idx;    // its okay to have it be trif.idx because if we find a trough, then we don't care about the min.
        n_min_yin = min_yin;
        n_min_found = 0;
        if (en & n_yin_ind == 0) begin
            n_min_yin = next_yin;
            n_min_ind = '0;
        end
        // Check on the last frame to see if it is a minimum
        else if ((en || frame_done) & next_yin < min_yin) begin
            n_min_yin = next_yin;
            n_min_ind = n_yin_ind;
            n_min_found = 1'b1;
        end
    end

    // Find the troughs logic
    /*
        Use the curr_yin to find out if a value is a trough
        -> If curr_yin < prev_yin and curr_yin <= next_yin, its a trough
        -> Look for the first trough in the frame
        -> Troughs are only possible once we have actual values for prev, curr, and next yin
    */
    assign curr_yin_ind = (n_yin_ind == 0) ?  0 : (n_yin_ind - 1);     // index of current yin value
    always_comb begin : find_trough
        n_trough_index = trough_index;
        n_trough_found = trough_found;
        if (en & ~trough_found & (n_yin_ind > 1)) begin

            /*

                yin1 = pos, pos, pos, pos, neg, neg, neg, neg.
                yin2 = pos, pos, neg, neg, pos, neg, neg, pos,
                yin3 = pos, neg, neg, pos, pos, pos, neg, neg,

                     =  1,   0,   1,   1,   0,   1,   1,   0
            */
            case ({prev_yin[17], curr_yin[17], next_yin[17]})   // 5 potential trough cases
                3'b000:     begin   // all positive
                                if ((curr_yin < prev_yin) & (curr_yin <= next_yin)) begin
                                    n_trough_index = curr_yin_ind;
                                    n_trough_found = 1;
                                end
                            end

                3'b011:     begin   // pos neg neg: just need to make sure that next_yin is more negative than curr_yin
                                if (next_yin >= curr_yin )  begin// for a 3 bit example, 100 = -4, 101 = -3. 101 > 100, so if next_yin > curr_yin, then curr_yin is smaller
                                    n_trough_index = curr_yin_ind;
                                    n_trough_found = 1;
                                end
                            end

                3'b110:     begin   // neg neg pos: just need to make sure that prev_yin is bigger than curr_yin
                                if (prev_yin > curr_yin) begin //for a 3 bit example, prev_yin = 101 = -3,  curr_yin = 100 = -4. 101 > 100, so if prev_yin > curr_yin, then curr_yin is smaller
                                    n_trough_index = curr_yin_ind;
                                    n_trough_found = 1;
                                end
                            end

                3'b111:     begin   // neg neg neg
                                //for a 3 bit example, prev_yin = 101 = -3,  curr_yin = 100 = -4, next_yin = 110 = -2. 101 > 100, so prev_yin > curr_yin, and 110 > 100, so next_yin > curr_yin
                                if ((prev_yin > curr_yin) & (next_yin >= curr_yin)) begin
                                    n_trough_index = curr_yin_ind;
                                    n_trough_found = 1;
                                end
                            end
                3'b010:     begin   // this is a trough.
                                    n_trough_index = curr_yin_ind;
                                    n_trough_found = 1;
                            end
                default:    begin   // no trough
                                n_trough_index = trough_index;
                                n_trough_found = 1'b0;
                            end
            endcase
            // if ((curr_yin < prev_yin) & (curr_yin <= next_yin))
            // n_trough_index = curr_yin_ind;
            // n_trough_found = 1;
        end
    end
    assign trif.trough_found = trough_found & ~p_trough_found;      // register trough_found so we can send out a pulse when finding a trough
    assign n_ind = n_trough_found ? n_trough_index : n_min_ind;     // determine the index to be either the minimum yin index or the trough index
    assign n_tau = n_trough_found ? (n_trough_index + MIN_PERIOD) : (n_min_ind + MIN_PERIOD);   // assign the tau value based off if there is a trough or not

    // Reset signal
    /* 
        Once the frame is done, give an extra cycle so that the curr, prev, and next yin registers can be cleared
    */
    always_comb begin : reset_logic
        n_delay_reset = delay_reset;
        if (frame_done || trif.done_early)
            n_delay_reset = 1'b1;
        // This is used to toggle the "reset" signal
        if (delay_reset)
            n_delay_reset = 1'b0;    
    end

    // Register next, curr, and prev yin values
    always_ff @(posedge clk, negedge rst) begin
        // if (~nrst) begin
        //     trif.next_yin <= 0;
        //     trif.curr_yin <= 0;
        //     trif.prev_yin <= 0;
        // end
        // else begin
        if (rst) begin
                trif.next_yin <= 0;
                trif.curr_yin <= 0;
                trif.prev_yin <= 0;
        end
        if ((n_trough_found & ~trough_found) || (~n_trough_found & n_min_found)) begin
                trif.next_yin <= next_yin;
                trif.curr_yin <= curr_yin;
                trif.prev_yin <= prev_yin;
        end
    end
    































    // logic [DW-1:0] next_tau;
    // logic [DW-1:0] prev_yin, curr_yin, new_yin;
    // logic [DW-1:0] smallest_min, next_smallest_min;
    // logic [DECIMALBITS-1:0] next_idx, curr_idx;
    
    
    // logic [(DECIMALBITS-1):0] trough_index, next_trough_index, min_index, next_min_index;
    // logic next_trough_found, next_tau_ready, tau_ready;

    // // typedef enum logic[1:0] {RESET, CYCLE1, CYCLE2} state;

    // // always_ff @(posedge clk, negedge nrst) begin : fsm
    // //     if (~nrst) begin
    // //     end
    // // end

    // always_ff @(posedge clk, negedge nrst) begin : Controller
    //     if (~nrst) begin    // or rst 
    //         min_index         <= 0;
    //         trough_index      <= 0;
    //         trif.trough_found <= 0;

    //         smallest_min <= 18'h3_FFFF;  // some large value

    //         trif.tau     <= 0;
    //         curr_yin     <= 0;
    //         prev_yin     <= 0;
    //         new_yin      <= 0;

    //         next_idx     <= 0;
    //         curr_idx     <= 0;

    //         // tau_ready    <= 0;
    //         trif.tau_ready <= 1'b0;
    //     end
    //     else begin
    //         if (trif.count_out == 0)    // synch reset
    //         begin
    //             curr_yin <= 0;
    //             prev_yin <= 0;
    //             new_yin <= trif.next_yin;
    //             smallest_min <= trif.next_yin;
    //             min_index <= 0;
    //             trif.trough_found <= 1'b0;
    //             trough_index <= 1'b0;
    //             // tau_ready <= 1'b0;
    //             trif.tau_ready <= 1'b0;
    //         end
    //         else begin
    //             trough_index       <= next_trough_index;
    //             trif.trough_found  <= next_trough_found;
                
    //             smallest_min       <= next_smallest_min;
    //             min_index          <= next_min_index;

    //             new_yin           <= trif.next_yin;
    //             curr_yin          <= new_yin;
    //             prev_yin          <= curr_yin;
    //             trif.tau          <= next_tau;

    //             next_idx          <= trif.count_out;
    //             curr_idx          <= next_idx;
    //             // tau_ready         <= next_tau_ready;
    //             trif.tau_ready    <= next_tau_ready;
    //         end
    //     end
    // end

    // always_comb begin : next_xxx_logic
    //     next_tau = trif.tau;
    //     next_tau_ready = trif.tau_ready;
    //     next_trough_found = trif.trough_found;
    //     next_trough_index = trough_index;
    //     next_min_index = min_index; 
    //     next_smallest_min = smallest_min;

    //     if (trif.enable) begin
    //              // find the minimum
    //             if ((new_yin < smallest_min) && (~trif.trough_found) && (trif.count_out > 0)) begin      
    //                 next_min_index = next_idx;       // count_out count_out is the next_yin index
    //                 next_smallest_min = trif.next_yin;         // update minimum val
    //                 next_tau = next_idx + MIN_PERIOD;          // update next_tau
    //             end

    //             // check that curr_yin is a trough and is less than the threshold, if it is a trough set control flag that tau is ready
    //             if ((curr_yin < prev_yin) && (curr_yin <= new_yin) && (curr_yin < TROUGH_THRESHOLD) && (trif.count_out >= 2) && (~trif.trough_found)) begin // 
    //                 next_trough_index = curr_idx;        // count_out - 1 because count_out is the next_yin index
    //                 next_tau = curr_idx + MIN_PERIOD;       // set the tau to be the trough_index
    //                 next_trough_found = 1'b1;           // we found trough, set flag high
    //                 next_tau_ready = 1'b1;
    //             end    
                
    //             // tau will be updated on the next cycle
    //             if (trif.frame_done) begin
    //                 next_tau_ready = 1'b1;
    //             end    
    //     end
    // end
    // assign trif.idx = trif.tau - MIN_PERIOD;  // give to interpolation module 


endmodule