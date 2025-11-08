`timescale 1ns / 10ps

module fsm_tb ();
    localparam CLK_PERIOD = 10ns;

    //inputs 
    logic clk;
    logic rst;
    logic empty;
    logic hop_flag; // moves away from READ (when we finish reading the first )
    logic hoplength_flag; // moves away from READ_BX
    logic countersel_flag; // ends all READ_BX
    logic fft_done;

    //outputs
    logic read_en;
    logic count_en;
    logic read_b1;
    logic read_b2;
    logic read_b3;
    logic read_b4;
    logic write_b1;
    logic write_b2;
    logic write_b3;
    logic write_b4;
    logic clear;

    fsm DUT (.*);

    always begin
        clk = 0; #(CLK_PERIOD/2.0);
        clk = 1; #(CLK_PERIOD/2.0);
    end

    //reset 
    task reset_dut;
    begin
        rst = 1;
        repeat (2) @(posedge clk);
        rst = 0;
        repeat (2) @(posedge clk);
    end
    endtask

    // Comprehensive test tasks
    task start_reading;
    begin
        // IDLE -> READ (empty=0 & fft_done=1)
        empty = 0;
        fft_done = 1;
        @(posedge clk);
        fft_done = 0;
        repeat (2) @(posedge clk);
    end
    endtask

    task move_to_bx(input int bx_num);
    begin
        case (bx_num)
            4: begin
                // READ -> READ_B4 (hop_flag=1)
                hop_flag = 1;
                @(posedge clk);
                hop_flag = 0;
                @(posedge clk);
                @(posedge clk);
            end
            3: begin
                // READ_B4 -> READ_B3 (hoplength_flag=1)
                hoplength_flag = 1;
                @(posedge clk);
                hoplength_flag = 0;
                @(posedge clk);
                @(posedge clk);
            end
            2: begin
                // READ_B3 -> READ_B2 (hoplength_flag=1)
                hoplength_flag = 1;
                @(posedge clk);
                hoplength_flag = 0;
                @(posedge clk);
                @(posedge clk);
            end
            1: begin
                // READ_B2 -> READ_B1 (hoplength_flag=1)
                hoplength_flag = 1;
                @(posedge clk);
                hoplength_flag = 0;
                @(posedge clk);
                @(posedge clk);
            end
            default: ;
        endcase
    end
    endtask

    task return_to_idle;
    begin
        // READ_B1 -> IDLE (countersel_flag=1)
        countersel_flag = 1;
        @(posedge clk);
        countersel_flag = 0;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    initial begin

        $display("Time(ns)\tclk rst empty fft_done hop_flag hoplen countersel state read_en");
       // $monitor("%0t\t%b %b %b %b %b %b %b %0d %b", $time, clk, rst, empty, fft_done, hop_flag, hoplength_flag, countersel_flag, DUT.current_state, read_en);

        empty = 0;
        hop_flag = 0;
        hoplength_flag = 0;
        countersel_flag = 0;
        fft_done = 0;
        reset_dut();

        // IDLE self-loop (start=0)
        repeat (4) @(posedge clk);

        // Start reading process
        start_reading();

        repeat (4) @(posedge clk);

        // Move through READ_BX states
        move_to_bx(4);
        move_to_bx(3);
        move_to_bx(2);
        move_to_bx(1);

        // Return to IDLE
        return_to_idle();

        // Test extraneous inputs
        empty = 1;
        fft_done = 1;

        repeat (4) @(posedge clk);

    // Check if the FSM is still in IDLE

    assert (DUT.current_state == DUT.IDLE) else $display("FSM is not in IDLE state");

        reset_dut;

        start_reading();
        repeat (4) @(posedge clk);

        // Test extraneous hop_flag in READ state
        hop_flag = 1;
        @(posedge clk);
        hop_flag = 0;
        @(posedge clk);
        @(posedge clk);

    // Check if the FSM is still in READ state
    assert (DUT.current_state == DUT.READ) else $display("FSM is not in READ state");

        @(posedge clk);

        //cycle through again with various extraneous inputs
        move_to_bx(4);
        hop_flag = 1; // extraneous
        @(posedge clk);
        hop_flag = 0;
        @(posedge clk);
        move_to_bx(3);
        countersel_flag = 1; // extraneous
        @(posedge clk);
        countersel_flag = 0;
        @(posedge clk);
        move_to_bx(2);
        move_to_bx(1);
        return_to_idle();

        $finish;
    end

endmodule