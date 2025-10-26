`timescale 1ns / 1ps

module top_tb;

    import types::*;

    // tb signals
    logic clk;
    logic n_rst;
    logic [DW-1:0] next_yin;
    logic [DW-1:0] prev_yin;
    logic [DW-1:0] curr_yin;
    logic trough_found_out;
    logic [DW-1:0] min_val_out;
    logic [DW-1:0] first_trough;
    logic [DW-1:0] tau;

    top dut (
        .clk(clk),
        .n_rst(n_rst),
        .next_yin(next_yin),
        .prev_yin(prev_yin),
        .curr_yin(curr_yin),
        .trough_found_out(trough_found_out),
        .min_val_out(min_val_out),
        .first_trough(first_trough),
        .tau(tau)
    );

    localparam CLK_PERIOD = 10;
    // always #(CLK_PERIOD / 2) clk = ~clk;

    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end


    initial begin
        automatic real test_freq = 440.0;
        automatic real phase;
        automatic real scale_factor = MAX_VAL;

        $display("Starting Testbench for 'top' module");
        
        // initialize signals
        // clk = 0;
        n_rst = 0; 
        next_yin = 0;

        // deassert reset after a few cycles
        #(CLK_PERIOD * 5);
        n_rst = 1;
        $display("Reset de-asserted at time %0t", $time);

        $display("Generating a %f Hz sine wave for %d samples.", test_freq, FRAME_LEN);

        for (int i = 0; i < FRAME_LEN; i++) begin
            @(posedge clk);
            
            phase = 2 * 3.14159 * test_freq * (real'(i) / real'(DR));
            next_yin = integer'(scale_factor * $sin(phase));
            
            @(posedge clk);
        end
        
        $display("Finished generating sine wave at time %0t", $time);

        #(CLK_PERIOD * 20);

        $display("Testbench finished at time %0t", $time);
        $display("First trough: %d", first_trough);
        $display("Overall min: %d", min_val_out);
        $finish;
    end
    
    initial begin
        wait(n_rst === 1);
        forever @(posedge clk) begin
            if (trough_found_out) begin
                $display("Trough found at time %0t! curr_yin = %d, prev_yin = %d", 
                         $time, curr_yin, prev_yin);
            end
        end
    end

endmodule

