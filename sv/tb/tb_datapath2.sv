`timescale 1ns / 10ps
/* verilator coverage_off */
`timescale 1ns/1ps

module tb_datapath2();

    // Clock period
    localparam CLK_PERIOD = 10;
    
    // Testbench signals
    logic clk;
    logic n_rst;
    logic clear;
    logic count_enable;
    logic [8:0] hoplength;
    logic [17:0] bram0_data_in;
    logic [17:0] bram1_data_in;
    logic [17:0] bram2_data_in;
    logic [17:0] bram3_data_in;
    logic [17:0] block_data;
    logic [8:0] count_out;
    logic hoplength_flag;
    logic countersel_flag;

    // Instantiate DUT
    datapath2 DUT (
        .clk(clk),
        .n_rst(n_rst),
        .clear(clear),
        .count_enable(count_enable),
        .hoplength(hoplength),
        .bram0_data_in(bram0_data_in),
        .bram1_data_in(bram1_data_in),
        .bram2_data_in(bram2_data_in),
        .bram3_data_in(bram3_data_in),
        .block_data(block_data),
        .count_out(count_out),
        .hoplength_flag(hoplength_flag),
        .countersel_flag(countersel_flag)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Reset task
    task reset_dut();
        n_rst = 0;
        @(posedge clk);
        @(posedge clk);
        n_rst = 1;
        @(posedge clk);
    endtask

    // Main test
    initial begin
        // Initialize inputs
        n_rst = 1;
        clear = 0;
        count_enable = 0;
        hoplength = 9'd5;
        bram0_data_in = 18'hAAAAA;
        bram1_data_in = 18'hBBBBB;
        bram2_data_in = 18'hCCCCC;
        bram3_data_in = 18'hDDDDD;

        // Test 1: Reset
        $display("Test 1: Reset");
        reset_dut();
        assert(count_out == 0) else $error("count_out should be 0 after reset");
        assert(hoplength_flag == 0) else $error("hoplength_flag should be 0 after reset");
        assert(countersel_flag == 0) else $error("countersel_flag should be 0 after reset");
        
        // Test 2: Count up to hoplength
        $display("Test 2: Count up to hoplength");
        count_enable = 1;
        
        repeat(4) @(posedge clk);
        assert(count_out == 4) else $error("count_out should be 4, got %0d", count_out);
        
        @(posedge clk);
        assert(count_out == 5) else $error("count_out should be 5, got %0d", count_out);
        assert(hoplength_flag == 1) else $error("hoplength_flag should be 1 when count == hoplength");
        
        @(posedge clk);
        assert(count_out == 1) else $error("count_out should wrap to 1, got %0d", count_out);
        
        // Test 3: Clear functionality
        $display("Test 3: Clear");
        clear = 1;
        @(posedge clk);
        clear = 0;
        assert(count_out == 0) else $error("count_out should be 0 after clear");
        
        // Test 4: BRAM MUX cycling
        $display("Test 4: BRAM MUX cycling");
        count_enable = 1;
        
        // countersel = 0, should output bram3
        assert(block_data == 18'hDDDDD) else $error("Expected bram3 data, got %h", block_data);
        
        // Count to hoplength to increment countersel
        repeat(5) @(posedge clk);
        @(posedge clk);
        // countersel = 1, should output bram2
        assert(block_data == 18'hCCCCC) else $error("Expected bram2 data, got %h", block_data);
        
        repeat(5) @(posedge clk);
        @(posedge clk);
        // countersel = 2, should output bram1
        assert(block_data == 18'hBBBBB) else $error("Expected bram1 data, got %h", block_data);
        
        repeat(5) @(posedge clk);
        @(posedge clk);
        // countersel = 3, should output bram0
        assert(block_data == 18'hAAAAA) else $error("Expected bram0 data, got %h", block_data);
        assert(countersel_flag == 1) else $error("countersel_flag should be 1 at max count");
        
        repeat(5) @(posedge clk);
        @(posedge clk);
        // Should wrap back to countersel = 0
        assert(block_data == 18'hDDDDD) else $error("Expected wrap to bram3 data, got %h", block_data);
        
        // Test 5: count_enable = 0
        $display("Test 5: Count enable off");
        count_enable = 0;
        clear = 1;
        @(posedge clk);
        clear = 0;
        
        repeat(10) @(posedge clk);
        assert(count_out == 0) else $error("count_out should remain 0 when count_enable is off");
        
        $display("All tests completed!");
        $finish;
    end

    // Timeout
    initial begin
        #10000;
        $display("Timeout!");
        $finish;
    end

endmodule
/* verilator coverage_off */
