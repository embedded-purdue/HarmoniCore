`timescale 1ns/1ps

module tb_fsm1;

  // -------------------------------------------------
  // Parameters
  // -------------------------------------------------
  localparam DATA_WIDTH = 18;
  localparam CLK_PERIOD = 10; // 100 MHz clock

  // -------------------------------------------------
  // Testbench Signals
  // -------------------------------------------------
  logic clk;
  logic n_rst;
  logic [DATA_WIDTH-1:0] data_in;
  logic empty;
  logic done;
  logic rd_en;
  logic block_full;
  logic [DATA_WIDTH-1:0] rdata_out;

  // -------------------------------------------------
  // DUT Instantiation
  // -------------------------------------------------
  fsm1 #(.DATA_WIDTH(DATA_WIDTH)) dut (
    .clk(clk),
    .n_rst(n_rst),
    .data_in(data_in),
    .empty(empty),
    .done(done),
    .rd_en(rd_en),
    .block_full(block_full),
    .rdata_out(rdata_out)
  );

  // -------------------------------------------------
  // Clock Generation (100 MHz)
  // -------------------------------------------------
  always #(CLK_PERIOD/2) clk = ~clk;

  // -------------------------------------------------
  // Task: Apply Reset
  // -------------------------------------------------
  task apply_reset();
    begin
      n_rst = 0;
      #(3*CLK_PERIOD);
      n_rst = 1;
    end
  endtask

  // -------------------------------------------------
  // Stimulus Process
  // -------------------------------------------------
  initial begin
    // Initialize signals
    clk = 0;
    n_rst = 1;
    data_in = '0;
    empty = 1;  // FIFO starts empty
    done = 0;

    // Apply reset
    apply_reset();

    // Wait a few cycles
    #(5*CLK_PERIOD);

    // Start feeding data (simulate FIFO not empty)
    empty = 0;
    repeat (520) begin
      data_in = $random & ((1 << DATA_WIDTH) - 1); // random 18-bit data
      #(CLK_PERIOD);
    end

    // Simulate FIFO becomes empty again
    empty = 1;
    #(10*CLK_PERIOD);

    // Simulate 'done' condition
    done = 1;
    #(20*CLK_PERIOD);

    // Finish simulation
    $display("Simulation completed.");
    $stop;
  end

  // -------------------------------------------------
  // Monitor Signals
  // -------------------------------------------------
  initial begin
    $display("Time | rd_en | block_full | counter | rdata_out");
    $monitor("%0t | %b | %b | %0d | %h",
             $time, rd_en, block_full, dut.counter, rdata_out);
  end

endmodule