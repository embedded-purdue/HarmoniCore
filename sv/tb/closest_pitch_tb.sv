`timescale 1ns / 1ps

`include "../include/closest_pitch_if.vh"
`include "../include/types.sv"
import types::*;


parameter PERIOD = 10;


module closest_pitch_tb;

    int test_num;

    logic clk = 1;
    logic nrst;

    //CLK gen
    always #(PERIOD/2) clk++;

    closest_pitch_if cpif();

    closest_pitch DUT(clk, nrst, cpif);

    int test_name[50];

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
        display_string("nrst", test_name);
        nrst = 0;
        cpif.freq_in = '0;
        cpif.scale = '0;
        cpif.active_tones = '0;
        cpif.start = 0;
        #(PERIOD * 2);

        display_string("idx 30", test_name);
        nrst = 1;
        cpif.freq_in = {7'b0101110, 11'b01000000000};
        cpif.scale = 8'd3;
        cpif.active_tones = '1;
        cpif.start = 1;
        #(PERIOD*80);

        cpif.start = 0;
        #(PERIOD * 2);

        display_string("idx 0", test_name);
        nrst = 1;
        cpif.freq_in = {7'b0, 11'b0};
        cpif.scale = 8'd3;
        cpif.active_tones = '1;
        cpif.start = 1;
        #(PERIOD*80);

        cpif.start = 0;
        #(PERIOD * 2);


        display_string("idx last", test_name);
        nrst = 1;
        cpif.freq_in = {7'b0111111, 11'b0};
        cpif.scale = 8'd20;
        cpif.active_tones = '1;
        cpif.start = 1;
        #(PERIOD*80);

        cpif.start = 0;
        #(PERIOD * 2);

        display_string("scale mask", test_name);
        nrst = 1;
        cpif.freq_in = {7'b0111111, 11'b0};
        cpif.scale = 8'd20;
        cpif.active_tones = 12'b000000000001;
        cpif.start = 1;
        #(PERIOD*80);

        cpif.start = 0;
        #(PERIOD * 2);


        $finish;
    end
endmodule