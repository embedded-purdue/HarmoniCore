`timescale 1ns / 1ps

`include "../include/FPMultiply_if.vh"
`include "../include/types.sv"
import types::*;


parameter PERIOD = 10;


module FPMultiply_tb;

    int test_num;

    FPMultiply_if multif();

    FPMultiply DUT(multif);

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
        display_string("> max val", test_name);
        multif.a = {7'b0111111, 11'b0};
        multif.b = {7'b0111111, 11'b0};
        #(PERIOD*2);

        display_string("< min val", test_name);
        multif.a = {7'b1000000, 11'b0};
        multif.b = {7'b0111111, 11'b0};
        #(PERIOD*2);

        display_string("normal", test_name);
        multif.a = {7'b0000010, 11'b0};
        multif.b = {7'b0000010, 11'b0};
        #(PERIOD*2);

        display_string("dec no sat", test_name);
        multif.a = {7'b0000010, 1'b1, 10'b0};
        multif.b = {7'b0000010, 1'b1, 10'b0};
        #(PERIOD*2);

        display_string("dec with sat", test_name);
        multif.a = {7'b0111111, 11'b11111111111};
        multif.b = {7'b0111111, 11'b11111111111};
        #(PERIOD*2);

        $finish;
    end
endmodule