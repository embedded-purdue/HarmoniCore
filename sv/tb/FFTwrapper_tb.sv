`timescale 1ns / 1ps

`include "../include/FFTwrapper_if.vh"
`include "../include/types.sv"
import types::*;


parameter PERIOD = 10;


module FFTwrapper_tb;

    int test_num;
    logic clk = 1;
    logic nrst;

    //CLK gen
    always #(PERIOD/2) clk++;

    FFTwrapper_if afcif();

    FFTwrapper DUT(clk, nrst, afcif);

    int test_name[50];

    integer file;
    integer i;
    string line;
    logic [31:0] hex_value;

    task display_string;
        input string str;
        output int array[];
        begin
            int i;
            array = new[50];
            for (i = 0; i < str.len(); i++) begin
                array[i] = str[i];  // Implicitly converts char to int
            end
        end
    endtask

    initial begin
        display_string("Reset", test_name);
        nrst = 1'b1;
        afcif.in_real = '0;
        afcif.in_im = '0;
        afcif.ifft = 1'b0;
        afcif.ifft_en = 1'b0;
        afcif.in_en = 1'b0;
        afcif.in_last = 1'b0;
        afcif.out_en = 1'b0;
        afcif.blk_exp_en = 1'b0;
        @(negedge clk);
        #(PERIOD*2);
        nrst = 1'b0;
        #(PERIOD*4);
        nrst = 1'b1;
        #(PERIOD*2);

        $finish;
    end
endmodule