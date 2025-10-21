`timescale 1ns/1ps

module tb_fsm2;

    // Parameters
    localparam DATA_WIDTH = 18;
    localparam CLK_PERIOD = 10; // 100 MHz

    // DUT I/O
    logic clk;
    logic n_rst;
    logic block_full;
    logic [DATA_WIDTH-1:0] block_0_data;
    logic [DATA_WIDTH-1:0] block_1_data;
    logic [DATA_WIDTH-1:0] block_2_data;
    logic [DATA_WIDTH-1:0] block_3_data;
    logic [DATA_WIDTH-1:0] block_data;
    logic fft_ready;
    logic done;

    // Instantiate DUT
    fsm2 #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .clk(clk),
        .n_rst(n_rst),
        .block_0_data(block_0_data),
        .block_1_data(block_1_data),
        .block_2_data(block_2_data),
        .block_3_data(block_3_data),
        .block_full(block_full),
        .block_data(block_data),
        .fft_ready(fft_ready),
        .done(done)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    // Stimulus
    initial begin
        // Initialize signals
        clk = 0;
        n_rst = 0;
        block_full = 0;
        block_0_data = 18'h001;
        block_1_data = 18'h111;
        block_2_data = 18'h222;
        block_3_data = 18'h333;

        // Reset pulse
        #(2*CLK_PERIOD);
        n_rst = 1;

        // Start block_full toggling
        #(3*CLK_PERIOD);
        block_full = 1;

        // Let it run for several cycles
        repeat (2200) @(posedge clk);

        // Disable block_full to stop counting
        block_full = 0;
        #(20*CLK_PERIOD);

        // End simulation
        $display("Simulation complete.");
        $finish;
    end

    // Optional debug messages
    always @(posedge clk) begin
        if (fft_ready)
            $display("[%0t ns] FFT_READY asserted. Done = %b", $time, done);
    end

endmodule