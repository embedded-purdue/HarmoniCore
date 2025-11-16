`timescale 1ns / 1ps

`include "../include/interpolater_if.vh"
`include "../include/types.sv"
import types::*;

parameter PERIOD = 10;

module interpolater_tb ();

    //CLK gen
    logic clk = 0;
    always #(PERIOD/2) clk++;
    logic rst;

    interpolater_if intif();
    interpolater DUT(.clk(clk), .rst(rst), .intif(intif.interp));
    
    task reset_dut();
        begin
            rst = 1'b1;
            @(posedge clk);
            @(posedge clk);
            @(negedge clk);
            rst = 1'b0;
            @(posedge clk);
            @(posedge clk);
        end
    endtask

    task check(input logic [17:0] a, b, c);
    int denom = $signed(a) - ($signed(b) <<< 1) + $signed(c);
    int numer = ($signed(a)-$signed(c)) >>> 1;
        if (numer > MAX_VAL) begin
            assert(intif.numer == MAX_VAL) $display ("SATURATED, GOOD");
            else $display ("SMAX, BAD NUMER, expected %d, got %d", MAX_VAL, intif.numer);
        end
        else if (numer < MIN_VAL) begin
            assert(intif.numer == MIN_VAL) $display ("SATURATED, GOOD");
            else $display ("SMIN, BAD NUMER, expected %d, got %d", MIN_VAL, intif.numer);
        end
        else begin
            assert(intif.numer == (($signed(a)-$signed(c)) >>> 1)) $display("GOOD");
            else $display("BAD NUMER, expected %d, got %d", ($signed(a)-$signed(c)) >>> 1, intif.numer);
        end

        if (denom > MAX_VAL) begin
            assert(intif.denom == MAX_VAL) $display ("SATURATED, GOOD");
            else $display ("SMAX, BAD DENOM, expected %d, got %d", MAX_VAL, intif.denom);
        end
        else if (denom < MIN_VAL) begin
            assert(intif.denom == MIN_VAL) $display ("SATURATED, GOOD");
            else $display ("SMIN, BAD DENOM, expected %d, got %d", MIN_VAL, intif.denom);
        end
        else begin
            assert(intif.denom == ($signed(a) - ($signed(b) <<< 1) + $signed(c))) $display("GOOD");
            else $display("BAD DENOM, expected %d, got %d", ($signed(a) - ($signed(b) <<< 1) + $signed(c)), intif.denom);
        end
    endtask

    task test(
        input logic [17:0] a, b, c
    );
        @(negedge clk);
        intif.trough_found = 1'b1;
        intif.prev_yin = a;
        intif.curr_yin = b;
        intif.next_yin = c;
        @(negedge clk);
        intif.trough_found = 1'b0;

    endtask 

    task frame_end();
        @(negedge clk);
        intif.frame_done = 1'b1;
        @(negedge clk);
        intif.frame_done = 1'b0;
    endtask //automatic

    string curr;
    initial begin
        // $monitor("%0t min_yin: %h", $time, min_yin);
        // curr = "RESET";

        // intif.prev_yin = '0;
        // intif.curr_yin = '0;
        // intif.next_yin = '0;

        // @(negedge clk);

        // curr = "Random Numbers";

        // intif.prev_yin = 18'h3_ffff;
        // intif.curr_yin = '0;
        // intif.next_yin = 18'h3_ffff;

        // @(negedge clk)

        // intif.prev_yin = 18'h0;
        // intif.curr_yin = 18'h3_ffff;
        // intif.next_yin = 18'h0;

        // @(negedge clk)

        // intif.prev_yin = 18'h1234;
        // intif.curr_yin = 18'h1010;
        // intif.next_yin = 18'h1988;
        
        // #(PERIOD * 30);
        
        intif.prev_yin = '0;
        intif.curr_yin = '0;
        intif.next_yin = '0;
        intif.trough_found = 1'b0;
        intif.frame_done = 1'b0;
        reset_dut();
        
        test(24'd100, 24'd250, 24'd125);
        #(PERIOD * 5);
        check(24'd100, 24'd250, 24'd125);
        #(PERIOD*2);
        frame_end();
        
        test(24'd0, 24'h1_ffff, 24'h1_ffff);
        #(PERIOD * 5);
        check(24'd0, 24'h1_ffff, 24'h1_ffff);
        #(PERIOD*2);
        frame_end();
        #(PERIOD * 6);
        
        test(24'd0, 24'h2_0000, 24'h2_0000);
        #(PERIOD * 20)
        check(24'd0, 24'h2_0000, 24'h2_0000);
        #(PERIOD*2);
        frame_end();

        // saturated stuff
        test(24'd0, 24'h1_ffff, 24'h0);
        #(PERIOD * 5);
        check(24'd0, 24'h1_ffff, 24'h0);
        #(PERIOD*2);
        frame_end();
        #(PERIOD * 6);
        $finish;
    end
endmodule