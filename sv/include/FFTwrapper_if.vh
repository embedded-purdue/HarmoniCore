`timescale 1ns/1ps

`ifndef FFTWRAPPER_IF
`define FFTWRAPPER_IF

`include "../include/types.sv"
import types::*;

interface FFTwrapper_if;

    logic ifft, ifft_en, in_en, in_last, out_en, blk_exp_en;
    logic [FFT_DW-1:0] in_real, in_im;

    logic ifft_ready, in_ready, out_valid, out_last, blk_exp_valid;
    logic [FFT_DW-1:0] out_real, out_im;
    logic [15:0] xk_index;
    logic [7:0] blk_exp, blk_exp_sample;


    modport fft (
        input ifft, ifft_en, in_real, in_im, in_en, in_last, out_en, blk_exp_en,
        output ifft_ready, in_ready, out_real, out_im, xk_index, blk_exp_sample, out_valid, out_last, blk_exp, blk_exp_valid
    );
    
endinterface

`endif

/*

Input: nifft, nifft_en, in_real, in_im, in_en, in_last, out_en, blk_exp_en


Output: nifft_ready, in_ready, out_real, out_im, xk_index, blk_exp_sample, 
out_valid, out_last, blk_exp, blk_exp_valid

*/