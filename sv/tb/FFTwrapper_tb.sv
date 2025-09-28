`timescale 1ns / 1ps

`include "../include/AFC_if.vh"
`include "../include/types.sv"
import types::*;


parameter PERIOD = 10;


module AFC_tb;

    int test_num;
    logic clk = 1;
    logic nrst;

    //CLK gen
    always #(PERIOD/2) clk++;

    AFC_if afcif();

    AFC DUT(clk, nrst, afcif);

    int test_name[50];

    integer file;
    logic [FFT_LEN-1:0][FFT_DW-1:0] in_vals, fft_real, fft_im;
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
        file = $fopen("fftvals.txt", "r");
        if (file == 0) begin
            $display("Error");
            $finish;
        end
        i = 0;
        while (!$feof(file)) begin
            $fgets(line, file);
            if (line.len() > 0) begin
                hex_value = line.atohex();
                in_vals[i] = hex_value;
                $display("%h\n", hex_value);
                i = i + 1;
            end
        end
        $fclose(file);

        display_string("Reset", test_name);
        nrst = 1'b1;
        afcif.tx_newsample_en = 1'b0;
        afcif.rx_newsample_en = 1'b0;
        afcif.tx_newsample_real = '0;
        afcif.rx_newsample_real = '0;
        afcif.tx_newsample_im = '0;
        afcif.rx_newsample_im = '0;
        @(negedge clk);
        #(PERIOD*2);
        nrst = 1'b0;
        #(PERIOD*4);
        nrst = 1'b1;
        #(PERIOD*2);

        $finish;
    end
endmodule